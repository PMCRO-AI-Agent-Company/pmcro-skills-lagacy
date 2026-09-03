---
name: reflect-and-seed
description: Close the cycle. Write trail, promote earned constraints, set next seed intent or idle, mark queue item done/blocked, and optionally enqueue follow-ups. This is the autonomy engine.
---

# Reflect and Seed

## Inputs
- PlanFrame, MakeFrame, CheckFrame
- Current task_id from session-state

## Actions
1. **Trail** — append under `.pmcro/trails/<cycle-id>.md` (or jsonl) summarizing plan / make / check / outcome / lessons.
2. **Earned constraints** — if Checker or experience produced durable rules, write under `.pmcro/constraints/`.
3. **Queue item** — set status `done` or `blocked` on the claimed task in `queue.jsonl`.
4. **Next seed**
   - If natural follow-up exists → write it into session-state **or** enqueue via `queue-enqueue` and set session idle.
   - If cycle complete with no follow-up → `status: idle`.
5. **Lessons** — short note for future Planners.

## Failure / retry path
On a Checker `fail`, close this cycle: set the claimed queue item to
`blocked` with RetryContext recorded (what failed, why, what a retry needs),
and write a new seed intent for the **next** cycle. Never reopen this cycle
or hand back to Maker/Planner directly — Orchestrator dispatches the retry
fresh, from Planner, on the following cycle.

## Validation
- [ ] The close-out trail is sealed in-session.
- [ ] Any queue reorder has an explicit reason in the trail.
- [ ] Follow-ups are actually enqueued.
- [ ] Any promoted constraint traces to an observed recurrence.

## Autonomy contract
The next cycle must be able to start from files alone (session-state + queue). Chat memory is not required for continuity.
