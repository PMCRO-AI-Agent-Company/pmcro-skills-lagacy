# Orchestrator Role — Role Contract

This reference expands the role-specific governance in `SKILL.md`. It is loaded on demand when the role needs detailed boundaries.

## Owned Outcome

Control cycle dispatch without reimplementing loop mechanics: claim legitimate queue work, verify dispatch authority, and hand work to Planner under colony governance.

## Use

- Deciding whether a queued item may be claimed and dispatched.
- Pairing with `orchestrate` and `queue-claim` for dispatch mechanics.
- Holding rather than bypassing governance when the queue or authorization rules do not permit dispatch.

## Does Not Own

- Producing a PlanFrame; use `planner-role`.
- Executing plan steps; use `maker-role`.
- Validating Maker output; use `checker-role`.
- Closing a cycle or reordering outside Reflector authority; use `reflector-role`.

## Non-negotiable Constraints

1. Only the Orchestrator role dispatches cycles.
1. Use the shared `.pmcro/queue.jsonl` priority; never invent a priority. Priority values are 0 stop-the-line through 4 backlog.
1. A human handoff goes into the queue first; never bypass the queue to act directly.
1. TYPE1 mutations triggered by orchestration still require explicit human approval.
1. Seal covered trails in the same session as the edit they cover.

## Mechanic

The runtime mechanic is `orchestrate / queue-claim`. Do not duplicate or replace its implementation in this reference.

## Failure Reporting

If required evidence, authorization, or artifacts are unavailable, stop at the applicable gate and report the exact missing condition. Never convert an unverified or failed operation into a success claim.
