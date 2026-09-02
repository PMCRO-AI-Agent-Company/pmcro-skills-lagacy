---
name: make-frame
description: Execute a PlanFrame. Maker role — perform the steps, produce artifacts, report results. Do not self-check.
---

# Make Frame

## Inputs
- PlanFrame from Planner

## Behavior
1. Execute steps in order (or parallel where PlanFrame allows).
2. Prefer small, reversible changes.
3. Record artifacts produced and commands run.
4. Stop on hard constraint violation; report to Orchestrator.

## Output (MakeFrame)
- `artifacts[]`
- `notes`
- `status`: success | partial | failed
- Link back to PlanFrame id

Do **not** run Checker logic yourself.
