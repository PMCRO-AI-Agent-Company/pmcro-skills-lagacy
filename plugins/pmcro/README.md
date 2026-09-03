# PMCR-O Semantic Model

The `pmcro` plugin is the canonical semantic layer for PMCR-O. It defines the Goal, Messy Seed Intent, executable Seed Intent, self-referential cycle, O-Mode: Dynamic Resonance, accountability Frames, knowledge promotion, session bootstrap, and convergence.

## Core loop

```text
Human
  ↓
Messy Seed Intent (literal human message/command)
  ↓
Orchestrator (Goal + capability discovery + O-Mode)
  ↓
Planner
  ↓
Maker
  ↓
Checker
  ↓
Reflector
  ↓
Seed Intent (executable /[plugin]:[skill] command)
  ↓
next PMCR-O cycle
  ↓
...
  ↓
Converged Intent
```

### Intent

- **Goal** — durable high-level objective managed by the Orchestrator.
- **Messy Seed Intent** — the raw human message/command. It is preserved verbatim and is not required to be perfectly structured.
- **Seed Intent** — the structured executable command for the next PMCR-O cycle. The Reflector normally produces it after the first cycle.
- **Converged Intent** — sufficiently resolved operational intent under current evidence, constraints, and acceptance conditions.

The original Messy Seed Intent remains provenance after the first canonical Seed Intent exists; it is not silently rewritten into the canonical history.

### Seed Intent command form

```text
/[plugin]:[skill] [optional instructions]
```

The command is resolved through the installed marketplace capability surface.

### O-Mode: Dynamic Resonance

`O` is the adaptive strategy/output layer. Orchestrate keeps PMCR-O moving, while O-Mode selects or changes strategies such as direct execution, repeated optimization, options/clarification, tree/graph-style deliberation, ReAct-style interaction, or future strategies supported by available capabilities.

Repeated failure is evidence for changing strategy, not permission to retry forever.

### Accountability

Trails are made of self-referential role Frames. Each Frame identifies who acted, what input it used, what it produced, and what later evidence validated or contradicted it. The backward references form the accountability layer.

A Trail is not a transcript. It is a durable record of decisions, actions, observations, constraints, strategy changes, outcomes, and next intent.

### Learning

Trails can be promoted into scoped constraints, rules/policies, strategy evidence, skill candidates, training examples, evaluation cases, or audit-only history. A trail is experience; a skill is a generalized reusable capability.

Trail Frames may form a future PMCR-O training/evaluation corpus. Fine-tuning is optional and must not be confused with the core runtime.

### Session bootstrap

Use `/pmcro:initialize` to load `.agents/` instructions, marketplace capabilities, `.pmcro/` state, constraints, approvals, and relevant trails before autonomous execution.

### Plugin boundaries

- `pmcro` — semantics and contracts.
- `pmcro-loop` — runtime/execution engine.
- `pmcro-skills` — executable governance and domain capabilities.
- Assets, templates, and generated artifact catalogs are outside `pmcro` unless a capability explicitly consumes them.

## Reference documents

- `references/architecture.md`
- `references/seed-intent-contract.md`
- `references/o-mode.md`
- `references/accountability-and-trails.md`
- `references/knowledge-promotion.md`
- `references/trail-as-product.md`
- `references/session-bootstrap.md`
- `references/intent-lifecycle.md`
