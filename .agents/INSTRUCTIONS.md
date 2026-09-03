# INSTRUCTIONS.md — pmcro-skills

Operational guidelines for any agent acting inside this repo. Read
`colony-laws.md` and `CONTEXT.md` first — this file is the "how", those are
the "what's fixed."

## Lifecycle command invocation

1. **Primary entry point:** `/send-message` captures human, agent, system,
   or external messages and hands them to Orchestrator. It never executes
   work inline.
2. **New seed convenience:** `/seed-intent` remains the explicit command for
   turning a raw human intent into a new queued seed. `/send-message` may
   route a classified message to it.
3. **Mechanics (`pmcro-loop:*`):** role charters invoke `.agents/skills/`
   mechanics; mechanics do not replace role ownership:
   - `queue-claim` — Orchestrator claims the next open queue item
   - `orchestrate` — Orchestrator dispatches the lifecycle
   - `approve-operation` — Orchestrator authorizes bounded TYPE1 mutations
   - `plan-frame` / `make-frame` / `check-frame` — phase mechanics
   - `reflect-and-seed` — closes the cycle and owns disposition
   - `queue-enqueue` — files new/follow-up work
4. `/createskill` scaffolds a PMCR-O-compliant skill; use it instead of
   hand-rolling SKILL.md frontmatter.

## Approval protocol

- TYPE1 state-changing mutations require explicit approval before execution.
- Delegated autonomous approval is valid only when its scope names the
  operation/targets and remains inside the approved boundary.
- Destructive deletion, external publishing, credentials/secrets, security
  bypasses, and irreversible external actions always need separate approval.
- Approval is recorded in the active trail before Maker executes.

## Trail-logging protocol

- Seal the trail in the **same session** as the edit/cycle it covers.
- Before authoring a trail, confirm which schema class (`trail-format.md`
  Class A or B) the runtime actually implements.
- Writes go through native write tools, never shell echo, so changes stay
  attributable and trail-visible.

## Handoff protocols

- **Human → colony:** enqueue human intent before acting on it.
- **Session → session:** `session-state.md` is the continuity pointer and
  takes precedence over a fresh queue claim unless human intent redirects.
- **Cycle → cycle:** Reflector marks done/blocked, records the next seed or
  idle disposition, and enqueues follow-up work.
- **Role → role:** Plan → Make → Check → Reflect is the strict lifecycle;
  the trail is the handoff artifact.

## Architecture governance

For architecture reconciliation, read `docs/architecture-governance.md` before
planning changes. Record scope, affected boundaries, and validation evidence in
the active trail; keep the change inside the approved cycle boundary.

## Workflow topology

The workflow bounded context uses `AgentSkills.Workflows.*` project names:
`Domain`, `Application`, `Infrastructure`, and `Mcp`. Aspire AppHost is the
composition boundary and Aspire integration tests live under `tests/`.
