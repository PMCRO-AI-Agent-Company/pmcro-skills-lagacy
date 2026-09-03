---
name: plan-frame
description: Produce a PlanFrame from the current seed intent, domain, and earned constraints. Planner role only — no execution.
---

# Plan Frame

## Inputs
- Seed intent from `.pmcro/session-state.md`
- Earned constraints from `.pmcro/constraints/`
- Domain Owns / Does-not-own (from C-suite skill if domain set)

## Output (PlanFrame)
Write to trail or session as structured markdown/JSON containing:
- `goal`
- `steps[]` (ordered, each with owner role if multi-agent)
- `acceptance_criteria[]`
- `constraints[]` (hard + earned)
- `risks[]`
- `domain`

Do **not** execute steps. Hand the PlanFrame to Maker via Orchestrator.

## Portability
Use repo-relative or environment-resolved paths in the PlanFrame; never embed
literal drive-letter paths (e.g. `P:\...`, `C:\...`) in plan artifacts.

## Validation
- [ ] The PlanFrame contains steps only and no execution occurred during planning.
- [ ] Priority matches the source queue item.
- [ ] TYPE1 steps are explicitly identified.
- [ ] No literal drive-letter paths are embedded.
