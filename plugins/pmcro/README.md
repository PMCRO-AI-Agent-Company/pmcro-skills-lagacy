# PMCR-O Semantic Model

The `pmcro` plugin is the canonical semantic layer for PMCR-O. It defines the Goal, Messy Seed Intent, executable Seed Intent, self-referential cycle, O-Mode: Dynamic Resonance, accountability Frames, governance knowledge, session bootstrap, learning, Trail Products, convergence, and external context transport.

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
Seed Intent: /[plugin]:[skill] [optional instructions]
  ↓
next PMCR-O cycle
  ↓
...
  ↓
Converged Intent
```

## Intent

- **Goal** — durable high-level objective managed by the Orchestrator.
- **Messy Seed Intent** — raw human message/command preserved verbatim as provenance.
- **Seed Intent** — structured executable command for the next cycle, normally produced by Reflector after the first cycle.
- **Converged Intent** — sufficiently resolved operational intent under current evidence, constraints, and acceptance conditions.

Once canonical Seed Intent exists, the original Messy Seed Intent remains historical provenance and is not the active control instruction.

## Seed Intent command form

```text
/[plugin]:[skill] [optional instructions]
```

The command resolves against the installed marketplace capability surface. Planner/Maker/Checker evidence informs the capability choice; Reflector packages the next operational command.

## O-Mode: Dynamic Resonance

`O` is the adaptive strategy/output layer. Orchestrate keeps PMCR-O moving; O-Mode can select or change strategies such as direct execution, repeated optimization, options/clarification, chain/tree/graph-style deliberation, ReAct-style interaction, or future strategies supported by available capabilities.

Repeated failure is evidence for strategy reassessment, not blind retry.

## Accountability and trails

Trails are composed of self-referential role Frames. Frames point backward to relevant inputs, artifacts, evidence, and prior Frames so decisions can be audited. A Trail is not a transcript; it is durable operational memory and accountability.

## Governance knowledge

PMCR-O distinguishes **laws/principles**, **constraints**, **rules/policies**, **strategies**, and **skills**. Laws are framework invariants; constraints are scoped boundaries; rules are learned operational guidance; strategies are O-Mode choices; skills are reusable executable capabilities.

## Learning and Trail Products

Trails can be promoted into scoped constraints, rules/policies, strategy evidence, skill candidates, training examples, evaluation cases, or audit-only history. A Trail Product packages validated operational experience for reuse; execution identity, credentials, accounts, and approvals come from the consumer runtime.

## Session bootstrap

Use `/pmcro:initialize` to load `.agents/` instructions, marketplace capabilities, `.pmcro/` state, constraints, approvals, and relevant trails before autonomous execution.

## Packaging and external LLM transport

Use `/pmcro:package` to generate a consumer-specific projection from canonical PMCR-O source. Supported projections are text, ZIP, directory, Gemini, and Agent Skills directory layouts.

The lower-level `/pmcro:source-dump` capability supplies the `PMCR-O-SOURCE-DUMP/1` text transport used by the `txt` projection. Runtime-specific layouts are generated projections, not alternate canonical source trees.

Skill-specific resources remain colocated with their skill:

```text
skills/<skill>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

The cross-cutting PMCR-O semantic contracts are owned by the `foundation` Agent Skill at `skills/foundation/`.

## Plugin boundaries

- `pmcro` — plugin manifests and discovery boundary.
- `pmcro-loop` — runtime/execution engine.
- `pmcro-skills` — executable governance and capabilities.

The plugin directory does not carry a plugin-level `references/` or `scripts/` tree. Supporting material belongs to the Agent Skill that owns it.
