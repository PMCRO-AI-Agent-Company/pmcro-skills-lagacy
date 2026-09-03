# Reflector Role — Role Contract

This reference expands the role-specific governance in `SKILL.md`. It is loaded on demand when the role needs detailed boundaries.

## Owned Outcome

Close the cycle with an auditable reflection, preserve queue integrity, promote only earned constraints, and determine the next seed or idle state without bypassing Orchestrator dispatch.

## Use

- Closing a cycle with `reflect-and-seed`.
- Deciding next seed intent versus idle after reviewing the cycle outcome.
- Marking the current queue item done or blocked and filing legitimate follow-ups.
- Reordering the queue only when Reflector policy permits and recording the reason.

## Does Not Own

- Dispatching a new cycle; use `orchestrator-role`.
- Executing plan work; use `maker-role`.
- Performing independent acceptance validation; use `checker-role`.

## Non-negotiable Constraints

1. Only CEO/CoS or Reflector policy may reorder `.pmcro/queue.jsonl`; state the reason in the close-out trail.
1. Seal the reflection trail in the same session as the cycle it closes.
1. Follow-up work must be enqueued with an honest priority rather than left as prose.
1. Promote constraints only when supported by an observed recurrence pattern.
1. If a human hands off new work while idle, enqueue it rather than bypassing the queue.

## Mechanic

The runtime mechanic is `reflect-and-seed`. Do not duplicate or replace its implementation in this reference.

## Failure Reporting

If required evidence, authorization, or artifacts are unavailable, stop at the applicable gate and report the exact missing condition. Never convert an unverified or failed operation into a success claim.
