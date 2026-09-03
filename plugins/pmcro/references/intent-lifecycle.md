# PMCR-O Intent Lifecycle

PMCR-O treats intent as something that can be progressively refined without losing the original human objective.

```text
Human message
    │
    ▼
Messy Seed Intent
    │
    ▼
Initial Seed Intent
    │
    ▼
┌──────────────────────────────┐
│ PMCR-O cycle                 │
│ Plan → Make → Check → Reflect│
└──────────────┬───────────────┘
               │
               ▼
        Next Seed Intent
               │
               └───────► next cycle

Goal persists across the cycles.
Intent lineage records each transition.
Convergence establishes when another refinement cycle is not materially useful.
```

## Responsibility boundaries

The Orchestrator manages the Goal and decides whether another cycle should run.

The Planner turns the current Seed Intent into a cycle plan.

The Maker executes permitted work under the governing approval boundary.

The Checker evaluates the work and its evidence.

The Reflector synthesizes the cycle into the next Seed Intent or a terminal status.

## Human input

A human message is the initial Messy Seed Intent. The system may normalize it into structured intent, but it must preserve the original input in the trail and must not pretend that the normalized interpretation was explicitly supplied by the human.

## Intent lineage

Every Seed Intent should be traceable to:

- the originating human message or command,
- its parent Seed Intent,
- the PMCR-O cycle that produced it,
- the reflection/evidence supporting the transition,
- and its terminal or successor state.

This allows the system to explain how an operational objective evolved.

## Autonomy

Autonomous operation means the Orchestrator can continue through eligible PMCR-O cycles without requiring the human to restate the next Seed Intent. The Reflector supplies the next Seed Intent by default.

Autonomy does not remove governance. TYPE1 mutation approvals, scope limits, and human-decision boundaries remain authoritative.
