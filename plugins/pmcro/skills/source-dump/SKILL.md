---
name: source-dump
description: Generate a deterministic text-only source dump of selected repository/project context for text-only LLMs.
---

# /pmcro:source-dump

Generate a PMCR-O Source Dump for an external LLM or text-only runtime.

## Skill resources

This skill keeps its supporting resources inside its own skill directory, following the Agent Skills directory model:

```text
source-dump/
├── SKILL.md
├── references/
│   └── source-dump.md
└── scripts/
    └── export-source-dump.ps1
```

Read `references/source-dump.md` for the format and safety contract. Use `scripts/export-source-dump.ps1` for deterministic filesystem enumeration and serialization.

## Inputs

Accept an optional natural-language selection describing the context needed. When no selection is provided, use the repository's configured/default export scope rather than assuming the entire workspace is safe to export.

## Requirements

1. Determine the required context from the current Goal, Seed Intent, task instructions, or explicit user selection.
2. Prefer repository-relative paths and preserve file boundaries.
3. Include relevant source, skills, references, scripts, assets, templates, configuration, and selected `.pmcro` state when requested and permitted.
4. Apply protected-path exclusions before reading file contents.
5. Exclude secrets, credentials, tokens, private keys, environment files containing secrets, and other sensitive material unless a separate explicit capability and policy authorizes handling them.
6. Use the bundled deterministic exporter when available; do not ask the LLM to invent or reconstruct file contents.
7. Emit the `PMCR-O-SOURCE-DUMP/1` envelope and manifest metadata.
8. Keep repository context distinct from PMCR-O operational state. Use the PMCR-O Text Protocol for Seed Intents, Frames, trails, constraints, approvals, and O-Mode decisions.

## Output

The result is a text-only artifact suitable for pasting into or sending to a third-party LLM that cannot directly consume the repository or ZIP archive.

Minimum output structure:

```text
=== PMCR-O SOURCE DUMP ===
FORMAT: PMCR-O-SOURCE-DUMP/1
...
=== MANIFEST ===
...
=== FILE: <path> ===
...
=== END PMCR-O SOURCE DUMP ===
```

## Operational boundary

This skill exports context; it does not grant repository access, credentials, approvals, or authority to an external model. The consumer runtime remains responsible for execution identity and permissions.
