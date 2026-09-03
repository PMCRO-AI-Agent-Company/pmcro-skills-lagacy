# PMCR-O

This repository contains the PMCR-O ecosystem: semantic contracts, the execution loop, governance skills, and related Agent Skills plugins.

## Architecture

```text
Human
  ↓
Messy Seed Intent
  ↓
Orchestrator
  ↓
Planner → Maker → Checker → Reflector
  ↓
Seed Intent: /[plugin]:[skill] [optional instructions]
  ↓
next PMCR-O cycle
```

The human supplies a raw message. The Orchestrator manages the durable high-level Goal and may discover and resolve capabilities from the installed marketplace. Planner, Maker, and Checker provide evidence. Reflector synthesizes that evidence and normally produces the next executable Seed Intent.

## O-Mode: Dynamic Resonance

The `O` is the adaptive strategy/output layer. Orchestrate keeps the loop moving; O-Mode can select or change strategies based on intent, available capabilities, prior trails, constraints, and observed failure patterns. Repeated failure should trigger strategy reassessment rather than blind retry.

## Durable learning

PMCR-O trails are composed of accountable self-referential role Frames. Trails preserve provenance, decisions, actions, checks, constraints, strategy transitions, outcomes, and next intent. Selected experience can later be promoted into constraints, rules, strategy evidence, skill candidates, training examples, or evaluation cases.

A Trail Product is reusable operational experience; execution identity, credentials, accounts, and approvals come from the consumer runtime.

## Packaging and external LLM transport

PMCR-O keeps canonical skills in Agent Skills form and generates consumer-specific projections rather than maintaining duplicate source trees.

Use `/pmcro:package` to project a plugin, skill, or selected project context as:

```text
TXT       → one text artifact for text-only LLMs
ZIP       → portable archive preserving structure
directory → local materialized projection
Gemini    → .gemini/skills/<skill>/...
Agents    → .agents/skills/<skill>/...
```

The lower-level `/pmcro:source-dump` capability provides the `PMCR-O-SOURCE-DUMP/1` text transport used by the `txt` projection. The package system keeps runtime-specific layouts generated from the canonical source.

Gemini CLI currently discovers workspace skills from `.gemini/skills/` and also supports the `.agents/skills/` alias; each skill is a self-contained directory with `SKILL.md` and optional `scripts/`, `references/`, and `assets/`. citeturn942087search0turn942087search1

## Repository layout

As of 2026-09-03 this repo's governance, colony state, and .NET solution
all live at the true repo root — there is no separate nested project
copy. See `.pmcro/repo-topology.md` for the authoritative directory map
and the history of how this consolidation happened.

- `plugins/pmcro` — semantic model, lifecycle, and packaging/projection capabilities.
- `plugins/pmcro-loop` — runtime engine.
- `.pmcro/` — this repo's own colony queue, session-state, trails, and constraints.
- `.agents/` — this repo's own agent roster and PMCR-O-governed `pmcro-skills` capability skills.
- `laws.md`, `CONTEXT.md` (now `.agents/CONTEXT.md`) — cross-repo dispatch/queue/mutation/trail rules and this repo's own operating context.
- `AgentSkills.slnx`, `src/`, `tests/`, `eng/` — the .NET solution and its build/eval tooling.

Use namespaced invocation such as `/pmcro:initialize`, `/pmcro:package`, `/pmcro:source-dump`, `/pmcro:intent-model`, or `/pmcro-skills:orchestrate`.
