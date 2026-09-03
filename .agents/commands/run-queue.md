---
name: run-queue
description: Run one or more queued PMCR-O cycles by invoking engine/run-cycle.ps1 for the deterministic claim/trail-skeleton step, then continuing as Orchestrator through Plan/Make/Check/Reflect. Use to advance the colony queue without hand-rolling each cycle.
---

# /run-queue

## Purpose
Advance `task-agents-commands-scaffold`'s parent goal: let a human (or a
heartbeat) advance the queue without manually invoking each PMCR-O phase.
Wraps the existing deterministic engine rather than reimplementing it.

## Args
- `cycle_count` (optional, integer): how many cycles to auto-run before
  stopping. **Defaults to 1.** This must default to a small, sane,
  non-unbounded cap — every cycle is real, billed model usage, not free.
- `until_queue_empty` (optional, boolean): if true, keep auto-running
  cycles until no open queue item remains, subject to the same stop
  condition below. It is hard-capped at **4 cycles** to avoid a runaway
  loop from a malformed queue.

## Steps
1. Run `../../engine/run-cycle.ps1 -PmcroRoot .pmcro`. This is the
   deterministic, non-reasoning half: it reads session-state, claims the
   next open item if idle, and writes a trail skeleton with
   PlanFrame/MakeFrame/CheckFrame/Reflection sections marked `PENDING`.
   It performs no reasoning and calls no model.
2. As Orchestrator, continue the opened cycle through
   `plan-frame` -> `make-frame` -> `check-frame` -> `reflect-and-seed`,
   filling each PENDING section and sealing the trail
   (`trail_sealed: true`) before moving to Reflect.
3. If `cycle_count` (or `until_queue_empty`) calls for another cycle,
   repeat from step 1 — but only after the current trail is sealed.
4. **TYPE1 mutations remain individually gated inside every cycle**,
   regardless of auto-run mode. Auto-run authorizes running multiple
   cycles without a human confirming *between* cycles; it never waives
   the explicit human approval a TYPE1 (state-changing) mutation needs
   *before* it executes within a cycle.

## Stop condition
Auto-run halts immediately, even mid-`cycle_count`, on a **priority-0
stop-the-line condition** (Checker hard fail, security issue) per
`queue.schema.md`. A queue that merely looks empty is not itself a stop
condition to declare colony-complete — see `reflect-and-seed`'s
Auto-run stop condition section — but it does mean there is nothing left
to claim, so auto-run naturally ends there too.

## Validation
- [ ] Each cycle's trail is sealed before another cycle opens.
- [ ] No TYPE1 mutation executed without explicit human approval, even
      under auto-run.
- [ ] `cycle_count` (or the internal hard cap under `until_queue_empty`)
      was respected; the loop did not run unbounded.
