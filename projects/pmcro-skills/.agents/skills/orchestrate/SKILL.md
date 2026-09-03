---
name: orchestrate
description: Run one full PMCR-O cycle. Claims this repo's colony priority queue when idle, then plan → make → check → reflect. Invoke as /pmcro-skills:orchestrate.
---

# Orchestrate (PMCR-O)

## Invocation

```text
/pmcro-skills:orchestrate [optional arguments]
```

Use the canonical `/pmcro-skills:<skill-name>` namespace for every skill this
plugin explicitly invokes.

## Preconditions
- `.pmcro/` exists at this repo's root.
- Colony queue lives at `.pmcro/queue.jsonl` (single backlog for this repo).
- Read `references/dispatch-contract.md` before dispatching a cycle.

## Algorithm
1. **Read session-state** (`.pmcro/session-state.md`).
2. **If idle / no seed** → invoke `/pmcro-skills:queue-claim`. A queue snapshot with no open item is not sufficient reason to declare the colony complete; Reflector owns the justified idle disposition.
3. **Plan** → invoke `/pmcro-skills:plan-frame` with current seed + domain + earned constraints.
4. **Make** → invoke `/pmcro-skills:make-frame` (or spawn Maker subagent) with PlanFrame.
5. **Check** → invoke `/pmcro-skills:check-frame` with PlanFrame + Maker artifacts.
6. **Reflect** → invoke `/pmcro-skills:reflect-and-seed`. Reflector closes the queue item and may enqueue follow-ups.
7. Write trail id into session-state. If Reflector left a new seed, the next cycle can start immediately or on heartbeat.

## Dispatch contract
- `cycle_count` defaults to 1 and is capped at 4.
- `until_queue_empty` is also capped at 4 cycles.
- Every role turn receives the current cycle/task/phase and prior artifact.
- Reject stale cycles or wrong-phase handoffs; do not silently advance them.
- TYPE1 execution requires a recorded approval scope before Maker acts.

## Failure path (strict phase order)
Phase order is strictly Orchestrator -> Planner -> Maker -> Checker ->
Reflector, with no shortcuts on failure. If Checker's CheckFrame is
`verdict: fail`, Orchestrator does **not** dispatch back to Maker or
Planner mid-cycle. Checker hands the fail to Reflector; Reflector closes
this cycle (queue item -> `blocked`, RetryContext recorded, new seed
intent written per `reflect-and-seed`); only then does Orchestrator open the
**next** cycle and dispatch it fresh to Planner. A failed check is a
cycle boundary, never an in-cycle loop.

## Hard rules
- Orchestrator is the **only** role that dispatches.
- Priority scale: 0 stop-the-line → 1 CEO/CoS → 2 domain critical → 3 normal → 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.
- Never read or write another repo's `.pmcro/` state.
- Auto-run stops only for a priority-0 stop-the-line condition; TYPE1 mutation approval still applies inside each cycle.

## Outputs
- Updated `.pmcro/session-state.md`
- New trail under `.pmcro/trails/`
- Possibly updated `.pmcro/queue.jsonl` and `.pmcro/constraints/`

## Implementation
Steps 1-2 (read state, claim if idle) and trail allocation are deterministic and implemented in `../../../engine/PmcroEngine.psm1`, runnable via `../../../engine/run-cycle.ps1 -PmcroRoot <path to .pmcro>`.
This script performs no reasoning: it claims a task and writes a trail skeleton with PlanFrame/MakeFrame/CheckFrame/Reflection sections marked `PENDING`, then stops. Steps 3-6 require a model and are not automated by this script — an agent must fill in the PENDING sections and seal the trail (`trail_sealed: true`).
