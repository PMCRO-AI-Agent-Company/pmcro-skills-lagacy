---
name: make-frame
description: Execute a PlanFrame. Maker role — perform the steps, produce artifacts, report results. TYPE1 mutations require a matching approval before execution. Do not self-check. Invoke as /pmcro-skills:make-frame.
---

# Make Frame

## Invocation

```text
/pmcro-skills:make-frame
```

## Inputs
- PlanFrame from Planner
- Any required TYPE1 approval record

## Behavior
1. Execute steps in order (or parallel where PlanFrame allows).
2. Before every TYPE1 state-changing operation, require a matching unexpired approval for the exact operation, actor, and targets.
3. Fail closed when approval is missing, denied, expired, or scope-mismatched.
4. Never expand an approved scope during execution; request a new approval instead.
5. Prefer small, reversible changes.
6. Record artifacts produced and commands run.
7. Stop on hard constraint violation; report to Orchestrator.

## Destructive operations
Deletion and other irreversible mutations require explicit human approval. A delegated policy alone is insufficient.

## Output (MakeFrame)
- `artifacts[]`
- `notes`
- `status`: success | partial | failed
- approval references used
- Link back to PlanFrame id

Do **not** run Checker logic yourself.
