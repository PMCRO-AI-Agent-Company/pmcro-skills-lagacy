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

## Text-only LLM transport

Some third-party LLMs cannot accept a ZIP archive or directly inspect a repository tree. PMCR-O therefore provides a deterministic **Source Dump** workflow that serializes selected repository/project context into one text artifact while preserving file paths and boundaries.

Generate one from the repository with the skill's bundled exporter:

```powershell
./plugins/pmcro/skills/source-dump/scripts/export-source-dump.ps1 -Root . -OutputPath ./pmcro-source-dump.txt
```

For a focused handoff, select only the relevant areas:

```powershell
./plugins/pmcro/skills/source-dump/scripts/export-source-dump.ps1 `
  -Root . `
  -Include plugins/pmcro,projects/pmcro-skills/.agents,projects/pmcro-skills/.pmcro `
  -OutputPath ./pmcro-context.txt
```

An agent can use `/pmcro:source-dump` to determine and describe the required context, while the bundled deterministic exporter remains authoritative for actual file contents. Protected paths and binary files are excluded by default.

The Source Dump is distinct from the PMCR-O Text Protocol: Source Dump carries repository/project context; the Text Protocol carries structured operational objects such as Seed Intents, Frames, trails, constraints, approvals, and O-Mode decisions.

## Plugins

- `plugins/pmcro` — semantic model and session bootstrap.
- `plugins/pmcro-loop` — runtime engine.
- `projects/pmcro-skills` — executable governance and capabilities.

Use namespaced invocation such as `/pmcro:initialize`, `/pmcro:source-dump`, `/pmcro:intent-model`, or `/pmcro-skills:orchestrate`.
