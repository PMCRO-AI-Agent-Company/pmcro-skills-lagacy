# PMCR-O Intent Model

The `pmcro` plugin is the semantic layer for PMCR-O. It defines what an objective, intent, seed intent, reflection, lineage, and convergence mean without owning execution mechanics.

## Intent progression

```text
Human input
   ↓
Messy Seed Intent
   ↓
PMCR-O cycle
   ↓
Seed Intent
   ↓
Reflector
   ↓
Next Seed Intent
   ↓
...repeat...
   ↓
Converged / Resolved Intent
```

Human input is intentionally treated as **messy seed intent**. The system must not require the human to pre-format a perfect task specification.

A **Seed Intent** is the current operational hypothesis for the next PMCR-O cycle. The Reflector owns the handoff of the next Seed Intent after each cycle.

A **Goal** is the durable high-level objective managed by the Orchestrator. A Seed Intent is a current step toward that goal, not the goal itself.

A **Converged Intent** is the resolved operational objective after sufficient refinement, evidence, constraint discovery, and checking. `True Intent` may be used informally, but executable contracts should prefer `converged_intent` or `resolved_intent`.

## Boundaries

- `pmcro` defines semantic contracts and lifecycle meaning.
- `pmcro-skills` provides executable skills and governance capabilities.
- `pmcro-loop` provides the execution runtime.
- Assets, templates, generated artifacts, and asset catalogs do not belong in this plugin.

## Invocation

The conceptual skills are invoked with the plugin namespace, for example:

`/pmcro:intent-model`

`/pmcro:intent-refinement`

`/pmcro:convergence`
