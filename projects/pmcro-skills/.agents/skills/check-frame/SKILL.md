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

## Failure routing

A `fail` verdict does **not** loop back directly to Maker or Planner within
this cycle. Checker's only next step is to hand the CheckFrame (with
`recommendation: retry | escalate` and findings/blockers) to Reflector.
Reflector alone decides whether this becomes a new seed intent for a
fresh next cycle. Checker must not re-invoke `make-frame` or `plan-frame`
itself, even informally, to "give Maker another shot" mid-cycle.
