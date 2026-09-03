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
1. Create a message envelope with source, message, timestamp, and any
   explicitly supplied routing metadata.
2. Hand the envelope to Orchestrator. The message boundary does not execute
   work and does not silently convert communication into authorization.
3. Orchestrator decides whether the message is informational, a follow-up,
   or a new seed intent. New work is enqueued before execution.
4. If the message requests a TYPE1 mutation, Orchestrator invokes its
   approval skill and records the approval scope before Maker executes.

## Relationship to /seed-intent
`/seed-intent` remains a specialized convenience for explicitly creating a
new work seed. `/send-message` is the canonical ingress and may route to
`/seed-intent` after Orchestrator classifies the message.
