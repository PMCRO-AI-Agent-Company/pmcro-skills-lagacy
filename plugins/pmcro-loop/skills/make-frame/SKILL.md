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

## Write discipline & portability
- Use native write tools (Edit/Write) for all writes; never use shell echo or
  equivalent write shortcuts, so changes stay attributable and trail-visible.
- Keep produced artifacts portable: resolve paths relative to repo root or
  environment, never hardcode drive-letter paths.
- Every state-changing TYPE1 mutation requires explicit human approval before
  execution.

## Validation
- [ ] Every executed action traces to a PlanFrame step.
- [ ] No TYPE1 mutation ran without prior explicit approval.
- [ ] Writes used attributable native write tools.
- [ ] The execution trail is sealed in-session.
