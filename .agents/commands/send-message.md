---
name: send-message
description: Primary PMCR-O ingress for human, agent, and external messages. Normalize a message, preserve provenance, and hand it to Orchestrator for approval, routing, or seed creation.
---

# /send-message

## Purpose
Use one communication boundary for new intent, events, follow-ups, and
requests. Do not bypass Orchestrator by writing PlanFrame or executing work.

## Args
- `message` (required): message body.
- `source` (optional): `human|agent|external|system`; default `human`.
- `priority` (optional, 0-4): preserve an explicitly supplied priority.
- `domain` (optional): bounded context for routing.
- `approval` (optional): delegated approval scope, if already authorized.

## Steps
1. **Durably persist first, before any reasoning.** Call
   `plugins/pmcro-loop/scripts/intake-message.ps1` (or `Add-PmcroIntake`)
   with the message, source, and any explicitly supplied routing metadata.
   This writes an `intake` item straight to `.pmcro/queue.jsonl` -- the
   colony's one shared queue, not a separate inbox -- deterministically and
   without a model call, so the message survives even if the session is
   interrupted immediately after this step. Do this unconditionally, even
   for messages that will turn out purely informational.
2. Hand the resulting intake item to Orchestrator. The message boundary
   does not execute work and does not silently convert communication into
   authorization.
3. Orchestrator classifies the intake item and resolves it via
   `plugins/pmcro-loop/scripts/resolve-intake.ps1` (or `Resolve-PmcroIntake`)
   with one disposition: `enqueued` (rewritten into a normal canonical
   Seed Intent item, `status: open`), `informational` (`status: done`, no
   work follows), or `split` (closed as `done`; each derived work item is
   separately enqueued with `derived_from_intake` pointing back to this
   intake id for provenance). The original raw message is preserved
   permanently in `messy_seed_text` regardless of disposition.
4. If the message requests a TYPE1 mutation, Orchestrator invokes its
   approval skill and records the approval scope before Maker executes.

## Reconnect
A message durably captured in step 1 but never resolved in step 3 (session
interrupted mid-classification) is discovered on the next reconnect: both
`engine/run-cycle.ps1` and `foundation/session-bootstrap.md` scan for
unresolved intake before doing anything else, and refuse to claim new
backlog work until every pending message has been classified -- a human
message is never silently skipped just because the process that received
it disappeared.

## Relationship to /seed-intent
`/seed-intent` remains a specialized convenience for explicitly creating a
new work seed through the typed governance API/MCP boundary (a separate,
already-durable path owned by the Application layer -- see
`/seed-intent`'s own command file). `/send-message` is the canonical
ingress for the file-based colony queue (`.pmcro/queue.jsonl`) and may
route to `/seed-intent` after Orchestrator classifies the message; the two
ingress paths are not merged by this durability change.
