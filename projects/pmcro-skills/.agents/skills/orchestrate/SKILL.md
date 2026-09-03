---
name: orchestrate
description: Run one full PMCR-O cycle and evolve intent autonomously across cycles. A human message is accepted as messy seed intent; the Reflector supplies later seed intents. Invoke as /pmcro-skills:orchestrate.
---

# Orchestrate (PMCR-O)

## Invocation

```text
/pmcro-skills:orchestrate [optional human intent]
```

Use the canonical `/pmcro-skills:<skill-name>` namespace for every executable skill this plugin explicitly invokes. Use `/pmcro:<skill>` for the semantic intent-model contracts.

## Intent contract

- A supplied human message is the initial **Messy Seed Intent**.
- The Orchestrator owns the durable high-level **Goal**.
- The current **Seed Intent** is the operational hypothesis for the current cycle.
- After the first cycle, the **Reflector** normally owns production of the next Seed Intent.
- Repeated cycles refine intent toward a **Converged / Resolved Intent**; the human does not need to restate the next seed.
- Consult `/pmcro:intent-model` and `/pmcro:intent-refinement` when normalizing or evolving intent.

## Preconditions
- `.pmcro/` exists at this repo's root.
- Colony queue lives at `.pmcro/queue.jsonl` (single backlog for this repo).
- Read `references/dispatch-contract.md` before dispatching a cycle.

## Algorithm
1. **Ingest intent** — when an explicit human message is supplied, preserve it as the initial Messy Seed Intent and derive the first Seed Intent; otherwise read the file-backed current Seed Intent/session state.
2. **Read session-state** (`.pmcro/session-state.md`).
3. **If idle / no current seed** → invoke `/pmcro-skills:queue-claim`. A queue snapshot with no open item is not sufficient reason to declare the colony complete; Reflector owns the justified idle disposition.
4. **Plan** → invoke `/pmcro-skills:plan-frame` with current Seed Intent + Goal + domain + earned constraints.
5. **Make** → invoke `/pmcro-skills:make-frame` (or spawn Maker subagent) with PlanFrame and the approved TYPE1 scope when applicable.
6. **Check** → invoke `/pmcro-skills:check-frame` with PlanFrame + Maker artifacts.
7. **Reflect** → invoke `/pmcro-skills:reflect-and-seed`. Reflector closes the queue item and either produces the next Seed Intent or establishes a terminal/converged status.
8. **Trail** — write the cycle trail id into session-state and preserve intent lineage. If Reflector left a next seed, the Orchestrator may immediately dispatch the next cycle subject to cycle bounds and stop conditions.

## Dispatch contract
- `cycle_count` defaults to 1 and is capped at 4.
- `until_queue_empty` is also capped at 4 cycles.
- Every role turn receives the current cycle/task/phase, Goal, Seed Intent, and prior artifact.
- Reject stale cycles or wrong-phase handoffs; do not silently advance them.
- TYPE1 execution requires a recorded approval scope before Maker acts.
- Never treat a normalized Seed Intent as verbatim human intent; preserve the originating Messy Seed Intent in lineage.

## Failure path (strict phase order)
Phase order is strictly Orchestrator -> Planner -> Maker -> Checker -> Reflector, with no shortcuts on failure. If Checker's CheckFrame is `verdict: fail`, Orchestrator does **not** dispatch back to Maker or Planner mid-cycle. Checker hands the fail to Reflector; Reflector closes this cycle (queue item -> `blocked`, RetryContext recorded, new seed intent written per `reflect-and-seed`); only then does Orchestrator open the **next** cycle and dispatch it fresh to Planner. A failed check is a cycle boundary, never an in-cycle loop.

## Hard rules
- Orchestrator is the **only** role that dispatches.
- Priority scale: 0 stop-the-line → 1 CEO/CoS → 2 domain critical → 3 normal → 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.
- Never read or write another repo's `.pmcro/` state.
- Auto-run stops only for a priority-0 stop-the-line condition; TYPE1 mutation approval still applies inside each cycle.

## Outputs
- Updated `.pmcro/session-state.md`
- New trail under `.pmcro/trails/`
- Updated intent lineage / next Seed Intent when another cycle is warranted
- Possibly updated `.pmcro/queue.jsonl` and `.pmcro/constraints/`

## Implementation
Steps 1-3 (intent/session/claim) and trail allocation are deterministic and implemented in `../../../engine/PmcroEngine.psm1`, runnable via `../../../engine/run-cycle.ps1 -PmcroRoot <path to .pmcro>`.
This script performs no reasoning: it claims a task and writes a trail skeleton with PlanFrame/MakeFrame/CheckFrame/Reflection sections marked `PENDING`, then stops. Steps 4-7 require a model and are not automated by this script — an agent must fill in the PENDING sections and seal the trail (`trail_sealed: true`). The semantic intent model is defined by the `pmcro` plugin; this skill consumes that contract rather than redefining it.
