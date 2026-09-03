---
name: plan-frame
description: Produce a PlanFrame from the current seed intent, domain, and earned constraints. Planner role only — no execution. Invoke as /pmcro-skills:plan-frame.
---

# Plan Frame

## Invocation

```text
/pmcro-skills:plan-frame
```

## Inputs
- Seed intent from `.pmcro/session-state.md`
- Earned constraints from `.pmcro/constraints/`
- Domain Owns / Does-not-own (if domain set)

## Output (PlanFrame)
Write to trail or session as structured markdown/JSON containing:
- `goal`
- `steps[]` (ordered, each with owner role if multi-agent)
- `acceptance_criteria[]`
- `constraints[]` (hard + earned)
- `risks[]`
- `domain`

Do **not** execute steps. Hand the PlanFrame to Maker via Orchestrator.

## Capability discovery

When the PlanFrame requires a tool, plugin, or specialized skill, invoke
`/pmcro-skills:discover-capabilities` before assigning that step to Maker.
Resolve against installed filesystem manifests, not marketplace registration alone.
Record provider, manifest path, capability matched, and resolution reason in the
PlanFrame so Checker and Trailkeeper can verify provenance later.
