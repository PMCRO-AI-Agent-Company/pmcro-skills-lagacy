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

Do **not** implement fixes. Any retry is Maker's job on a **fresh next cycle**,
never a same-cycle handback — see Failure routing below.

## Failure routing
A `fail` verdict hands off to Reflector only — never loop back to Maker or
Planner mid-cycle. Phase order is strictly
Orchestrator → Planner → Maker → Checker → Reflector, with no shortcuts on
failure. Reflector closes the cycle (queue item → `blocked`, RetryContext
recorded, new seed intent written per `reflect-and-seed`); only then does
Orchestrator open the **next** cycle and dispatch it fresh to Planner. A
"retry" recommendation above means "worth a fresh cycle," not "hand back to
Maker now" — the underlying engine (`PmcroEngine.psm1`) has no mid-cycle
loop-back mechanism at all, only per-cycle trail allocation, so this reading
is consistent with what is actually implemented.

## Validation
- [ ] The verdict is supported by independent inspection and concrete evidence.
- [ ] No unapproved TYPE1 mutation occurred during checking.
- [ ] The CheckFrame trail is sealed in the same session.
