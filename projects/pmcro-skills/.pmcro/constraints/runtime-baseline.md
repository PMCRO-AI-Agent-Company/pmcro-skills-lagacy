# PMCR-O Runtime Baseline

This file defines the baseline relationship between runtime state, agent
identity, and persistent memory for this repository.

## Authoritative surfaces

- `.pmcro/queue.jsonl` — one shared execution queue.
- `.pmcro/session-state.md` — active cross-session continuity pointer.
- `.pmcro/trails/` — sealed historical execution evidence.
- `.pmcro/constraints/` — earned constraints; this baseline does not override
  `colony-laws.md`.

## Agent surfaces

- `.agents/agents/` — identity, role ownership, and operating contract.
- `.agents/agents-memory/<agent>/MEMORY.md` — advisory persistent memory.
- `.agents/skills/` — procedural mechanics.

## Separation rule

Identity, memory, and runtime governance are separate concerns. Memory may
inform reasoning but cannot authorize mutation, alter queue state, rewrite
sealed trails, or become a binding constraint without governed promotion.

## Lifecycle rule

Only Orchestrator dispatches. Planner plans, Maker executes, Checker verifies,
and Reflector closes the cycle. Trailkeeper and Memorykeeper remain adjacent
support roles and do not create a second lifecycle or queue.
