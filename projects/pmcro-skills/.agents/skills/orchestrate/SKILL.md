---
name: orchestrate
description: Run one full PMCR-O cycle. Claims from this repo's colony priority queue when session is idle, then plan → make → check → reflect. Use whenever this repo should advance autonomously or a human hands off an intent.
---

# Orchestrate (PMCR-O)

## Preconditions
- `.pmcro/` exists at this repo's root.
- Colony queue lives at `.pmcro/queue.jsonl` (single backlog for this repo).

## Algorithm
1. **Read session-state** (`.pmcro/session-state.md`).
2. **If idle / no seed** → run `queue-claim`. If queue empty, stop and report idle.
3. **Plan** → load `plan-frame` with current seed + domain + earned constraints.
4. **Make** → load `make-frame` (or spawn Maker subagent) with PlanFrame.
5. **Check** → load `check-frame` with PlanFrame + Maker artifacts.
6. **Reflect** → load `reflect-and-seed`. Reflector closes the queue item and may enqueue follow-ups.
7. Write trail id into session-state. If Reflector left a new seed, the next cycle can start immediately or on heartbeat.

## Hard rules
- Orchestrator is the **only** role that dispatches.
- Priority scale: 0 stop-the-line → 1 CEO/CoS → 2 domain critical → 3 normal → 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.
- Never read or write another repo's `.pmcro/` state.

## Outputs
- Updated `.pmcro/session-state.md`
- New trail under `.pmcro/trails/`
- Possibly updated `.pmcro/queue.jsonl` and `.pmcro/constraints/`

## Implementation
Steps 1-2 (read state, claim if idle) and trail allocation are
deterministic and implemented in `../../../engine/PmcroEngine.psm1`,
runnable via `../../../engine/run-cycle.ps1 -PmcroRoot <path to .pmcro>`.
This script performs no reasoning: it claims a task and writes a trail
skeleton with PlanFrame/MakeFrame/CheckFrame/Reflection sections marked
`PENDING`, then stops. Steps 3-6 require a model and are not automated
by this script — an agent must fill in the PENDING sections and seal
the trail (`trail_sealed: true`).
