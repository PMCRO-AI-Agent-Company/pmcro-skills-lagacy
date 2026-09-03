---
name: check-frame
description: Independently validate Maker output against PlanFrame acceptance criteria. Produce pass/fail CheckFrame. Prefer read-only tools.
---

# Check Frame

## Inputs
- PlanFrame
- MakeFrame / artifacts

## Behavior
1. Evaluate each acceptance criterion.
2. Note severity of findings (blocker / major / minor).
3. Prefer independent verification (read, test, lint) over trusting Maker claims.

## Output (CheckFrame)
- `verdict`: pass | fail
- `findings[]`
- `blockers[]`
- Recommendation: accept | retry | escalate

Do **not** implement fixes. That is Maker's job on a retry cycle.
