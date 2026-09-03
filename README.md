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

## Plugins

- `plugins/pmcro` — semantic model and session bootstrap.
- `plugins/pmcro-loop` — runtime engine.
- `projects/pmcro-skills` — executable governance and capabilities.

Use namespaced invocation such as `/pmcro:initialize`, `/pmcro:intent-model`, or `/pmcro-skills:orchestrate`.
