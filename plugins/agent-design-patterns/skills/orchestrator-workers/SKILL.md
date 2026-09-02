---
name: orchestrator-workers
description: Decompose work into bounded specialist tasks and collect results.
license: MIT
---

# orchestrator-workers

Decompose work into bounded specialist tasks and collect results.

## Workflow

1. Define the input and success condition.
2. Select the smallest useful model/tool composition.
3. Keep stage contracts explicit.
4. Add deterministic validation at failure boundaries.
5. Measure quality, latency, cost, and risk before adding complexity.

## Support

- eferences/pattern.md contains selection guidance.
- assets/example.md.template is an implementation skeleton.
- scripts/validate-pattern.ps1 validates the package.

## References

- `references/pattern.md` — pattern design guidance.
