---
name: package
description: Package a canonical PMCR-O plugin, skill, or selected project context into a text, ZIP, or runtime-specific directory projection without maintaining consumer-specific source copies.
---

# /pmcro:package

Create a distributable projection of canonical PMCR-O content for a target runtime or transport.

## Supported projections

- `txt` — single text artifact suitable for text-only LLMs.
- `zip` — archive preserving the selected directory structure.
- `directory` — materialized directory projection.
- `gemini` — Gemini-oriented directory projection using the supported `.gemini/` convention available to the target runtime.
- `agents` — Agent Skills-oriented directory projection using `.agents/skills/`.

Runtime-specific projections are generated outputs. They are not alternate canonical source trees.

## Requirements

1. Start from the canonical plugin/skill/project source.
2. Determine the requested target projection and selection scope.
3. Preserve skill-local `SKILL.md`, `references/`, `scripts/`, and `assets/` relationships.
4. Preserve repository-relative paths where the target convention supports them.
5. Translate only the directory/manifest conventions required by the target runtime.
6. Do not silently create or modify credentials, accounts, approvals, or runtime identity configuration.
7. Apply protected-path exclusions before packaging file contents.
8. Use deterministic packaging logic for actual file enumeration and copying.
9. For text output, use the `PMCR-O-SOURCE-DUMP/1` transport defined by the Source Dump skill.
10. Record the target projection and source revision in the package manifest where the target format permits it.

## Canonical relationship

```text
Canonical PMCR-O source
        ↓
Package selection
        ↓
Projection
  ├── txt
  ├── zip
  ├── directory
  ├── gemini
  └── agents
```

The package is disposable/reproducible. Changes belong in the canonical source, then the projection is regenerated.

## Skill resources

The packaging implementation should keep its own references, scripts, and assets under this skill directory. It may reuse the Source Dump skill for text serialization rather than duplicating its serializer.

## Safety boundary

Packaging is a distribution operation, not a permission escalation. Sensitive material remains excluded by default. A package must not be treated as granting authority merely because it contains a skill, manifest, or runtime-specific directory.
