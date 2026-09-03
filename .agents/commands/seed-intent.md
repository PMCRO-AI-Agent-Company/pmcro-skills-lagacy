---
name: seed-intent
description: Seed a new PMCR-O intent through the typed governance API/MCP boundary.
argument-hint: <intent-description>
---

# /seed-intent

This command is a thin trigger. It does not edit `.pmcro` state directly.

## Invocation
Call the MCP tool `pmcro_seed_intent` with:

```json
{
  "rawIntent": "$ARGUMENTS",
  "requestedBy": "user"
}
```

The same use case is exposed by `POST /api/v1/sessions/seed-intent`.
The Application layer owns validation, session creation, persistence, and
trail event emission. The Domain layer owns session invariants.

## Handoff
When the tool returns `sessionId` and `planArtifactPath`, hand the session to
`@orchestrator`. Orchestrator remains the only role allowed to dispatch Planner.

## Governance
- Never hand-edit `queue.jsonl`, `session-state.md`, or trails from this command.
- TYPE1 mutations remain governed by `laws.md` and the approval protocol.
- Missing API/MCP capability is a failure to report, not permission to bypass it.
