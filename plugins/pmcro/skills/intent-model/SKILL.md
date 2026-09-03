---
name: intent-model
description: Define and classify PMCR-O Goal, Messy Seed Intent, executable Seed Intent, intent lineage, and Converged Intent. Invoke with /pmcro:intent-model.
---

# PMCR-O Intent Model

Use this skill when a PMCR-O agent needs to classify, normalize, or audit intent.

## Canonical concepts

### Goal

A durable high-level objective managed by the Orchestrator. It persists across cycles unless explicitly superseded or completed.

### Messy Seed Intent

The literal human-provided message or command. It may be a sentence, fragment, or imprecise instruction. Preserve it verbatim as provenance. The human does not need to pre-format it as a canonical Seed Intent.

### Seed Intent

The current structured, executable intent for the next PMCR-O cycle. Canonical Seed Intent uses:

```text
/[plugin]:[skill] [optional instructions]
```

The command addresses the installed marketplace capability surface. After initialization, the Reflector normally owns production of the next Seed Intent.

### Converged Intent

The sufficiently resolved operational objective reached when further cycles are not expected to materially improve the interpretation or outcome. `True Intent` may be used informally, but machine-readable contracts should prefer `converged_intent` or `resolved_intent`.

## Core rules

- Never confuse Goal with Seed Intent.
- Never confuse Messy Seed Intent with canonical Seed Intent.
- Do not let the Orchestrator silently replace the Reflector as next-Seed owner.
- Preserve intent lineage from the original human message through every successor Seed Intent.
- Treat a Seed Intent as a current operational hypothesis, not a claim that the human originally supplied that exact wording.
