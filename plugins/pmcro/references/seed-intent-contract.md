# Seed Intent Contract

## Human input versus Seed Intent

A human message is **Messy Seed Intent**. It may be a sentence, a command, a fragment, or an imprecise request. Preserve it exactly for provenance.

A canonical **Seed Intent** is produced for the next cycle by PMCR-O. The Reflector is the default owner of the next-seed handoff after the first cycle.

## Canonical command form

```text
/[plugin]:[skill] [optional instructions]
```

The command identifies a marketplace capability. The optional instruction supplies the current operational direction.

Example:

```text
/pmcro-skills:orchestrate inspect the current runtime and continue the PMCR-O goal
```

## Structured representation

```yaml
seed_intent:
  command: /plugin:skill
  plugin: plugin
  skill: skill
  instructions: optional free-form instructions
  source: reflector
  parent_cycle_id: cycle-123
  goal_id: goal-007
  lineage_id: intent-007
```

`command` is the executable address. The remaining fields preserve lineage, provenance, and semantic context.

## Ownership

1. Human supplies Messy Seed Intent.
2. Orchestrator manages the Goal and capability surface.
3. Planner determines the minimum sufficient work and capability requirements.
4. Maker executes the PlanFrame within governance.
5. Checker validates the result and evidence.
6. Reflector synthesizes the cycle and emits the next Seed Intent when another cycle is justified.

The Orchestrator must not manufacture a replacement next Seed Intent in place of the Reflector. It may dispatch the Seed Intent that the Reflector produced.

## Continuation rule

When the next Seed Intent exists, the next PMCR-O cycle consumes that Seed Intent rather than the original Messy Seed Intent. The Messy Seed remains immutable historical provenance.
