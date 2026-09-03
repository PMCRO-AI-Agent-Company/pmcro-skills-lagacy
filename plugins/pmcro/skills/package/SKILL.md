---
name: package
description: Package a canonical PMCR-O plugin, skill, or selected project context into text, ZIP, or runtime-specific directory projections, adapting to the consumer's effective context budget.
---

# /pmcro:package

Create a distributable projection of canonical PMCR-O content for a target runtime or transport.

## Supported projections

- `txt` — text artifact or ordered text chunks suitable for text-only LLMs.
- `zip` — archive preserving the selected directory structure.
- `directory` — materialized directory projection.
- `gemini` — Gemini workspace skill projection under `.gemini/skills/`.
- `agents` — Agent Skills projection under `.agents/skills/`.

Runtime-specific projections are generated outputs. They are not alternate canonical source trees.

## Requirements

1. Start from the canonical plugin/skill/project source.
2. Determine the requested target projection and selection scope.
3. Determine the target's effective context budget when available. Do not assume the model's advertised context window equals the safe size of one prompt or turn.
4. Preserve skill-local `SKILL.md`, `references/`, `scripts/`, and `assets/` relationships.
5. Preserve repository-relative paths where the target convention supports them.
6. Translate only the directory/manifest conventions required by the target runtime.
7. Do not silently create or modify credentials, accounts, approvals, or runtime identity configuration.
8. Apply protected-path exclusions before packaging file contents.
9. Use deterministic packaging logic for actual file enumeration and copying.
10. For text output, use the `PMCR-O-SOURCE-DUMP/1` transport defined by the Source Dump skill.
11. If the selected text context exceeds the effective budget, prefer priority selection and ordered chunking over silent lossy summarization.
12. Keep authoritative source files lossless when included. Summaries are derived navigation aids, not replacements.
13. Record the target projection, source revision, budget assumptions, completeness, and chunk ordering where the target format permits it.

## Context-budget strategy

```text
fits budget?
   ├── yes → full-fidelity projection
   └── no  → priority selection → chunking → optional derived summary
```

ZIP compression can reduce transfer/storage size but does not reduce the token count once text is read by the LLM. Text-only transport therefore uses selection and chunking rather than relying on archive compression.

See `references/context-budget.md` for the detailed budget and chunking contract.

## Canonical relationship

```text
Canonical PMCR-O source
        ↓
Package selection + budget
        ↓
Projection
  ├── txt / chunks
  ├── zip
  ├── directory
  ├── gemini
  └── agents
```

The package is disposable/reproducible. Changes belong in the canonical source, then the projection is regenerated.

## Skill resources

The packaging implementation keeps its own references, scripts, and assets under this skill directory. It may reuse the Source Dump skill for text serialization rather than duplicating its serializer.

## Safety boundary

Packaging is a distribution operation, not a permission escalation. Sensitive material remains excluded by default. A package must not be treated as granting authority merely because it contains a skill, manifest, or runtime-specific directory.
