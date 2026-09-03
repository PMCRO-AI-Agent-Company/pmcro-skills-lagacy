---
name: intent-model
description: Define the canonical PMCR-O model of goal, messy seed intent, seed intent, and converged intent. Invoke with /pmcro:intent-model.
---

# PMCR-O Intent Model

Use this skill when a PMCR-O agent needs to classify, describe, or normalize intent.

## Canonical concepts

### Goal

A durable high-level objective owned by the Orchestrator. The Goal persists across cycles unless explicitly superseded or completed.

### Messy Seed Intent

The raw human-provided message or command. Treat it as authoritative evidence of what the human is trying to accomplish, but do not assume it is complete, precise, or internally consistent.

### Seed Intent

The current structured operational intent used to drive the next PMCR-O cycle. It may be created from messy seed intent initially and thereafter is normally produced by the Reflector.

### Converged Intent

The operational objective reached when repeated PMCR-O cycles have resolved relevant ambiguity, constraints, evidence, and acceptance conditions. Prefer this term in machine-readable contracts.

## Core rule

Never confuse the current Seed Intent with the durable Goal. Never require the human to provide a perfect Seed Intent before the loop can begin.
