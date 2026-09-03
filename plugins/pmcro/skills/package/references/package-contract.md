# PMCR-O Package Projection Contract

## Purpose

PMCR-O packaging converts canonical source into consumer-specific projections. The canonical source remains the source of truth; projections are generated artifacts.

## Projection model

```text
Canonical source
      ↓
Selection manifest
      ↓
Target adapter
      ↓
Projection
```

Supported target classes:

| Target | Output | Purpose |
|---|---|---|
| `txt` | one text file | text-only LLM transport |
| `zip` | ZIP archive | file-preserving distribution |
| `directory` | directory tree | local consumption |
| `gemini` | `.gemini/...` tree | Gemini-compatible runtime projection |
| `agents` | `.agents/skills/...` tree | Agent Skills projection |

The exact runtime-specific path must be determined from the target runtime's current supported convention. The package system should not invent a convention when one is not known.

## Preservation rules

A skill's internal relationship is preserved:

```text
<skill>/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

Runtime projection may relocate the skill root, but should not flatten or detach its supporting resources.

Plugin-level manifests remain plugin-level metadata. Skill-specific resources stay inside their skill directory.

## Text projection

The `txt` projection uses:

`PMCR-O-SOURCE-DUMP/1`

The text artifact includes file path, type, encoding, and explicit begin/end boundaries. It is intended for manual copy/paste or submission to third-party text-only LLMs.

## ZIP projection

The ZIP projection preserves the selected canonical relative tree. The archive is a transport artifact and should not contain credentials or protected material by default.

## Runtime projections

Runtime-specific projections are adapters over the same canonical source. Example:

```text
plugins/pmcro/skills/foo/
      ↓
Gemini adapter
      ↓
.gemini/<supported-skill-location>/foo/
```

or:

```text
plugins/pmcro/skills/foo/
      ↓
Agent Skills adapter
      ↓
.agents/skills/foo/
```

A runtime adapter may add or transform only the metadata required by that runtime. It must not change the semantic meaning of the skill.

## Manifest

A package manifest should identify at minimum:

- format/projection identifier;
- source repository or project;
- source revision when available;
- selected roots/files;
- exclusions;
- generation time;
- package version/contract version.

## Safety

Packaging must not be used to export secrets, credentials, private keys, account state, or approvals merely because they exist in the source workspace. Consumer credentials and execution identity remain external to the package.
