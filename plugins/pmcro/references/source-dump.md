# PMCR-O Source Dump

## Purpose

A Source Dump is a deterministic, text-only transport representation of a repository or selected project context for an LLM or runtime that cannot directly consume ZIP archives, repository trees, or other file containers.

It is a transport artifact, not the canonical repository and not a replacement for PMCR-O's semantic contracts.

## Design goals

- Preserve repository-relative paths and file boundaries.
- Support source, skills, assets, references, scripts, templates, configuration, and selected `.pmcro` state.
- Allow explicit include and exclude scope.
- Never include secrets, credentials, tokens, private keys, or other sensitive material by default.
- Be deterministic enough that repeated exports from the same revision and selection produce materially equivalent output.
- Remain readable by humans and usable by text-only third-party LLMs.
- Record revision and generation metadata without pretending that the dump itself is authoritative state.

## Format

The canonical envelope identifier is `PMCR-O-SOURCE-DUMP/1`.

```text
=== PMCR-O SOURCE DUMP ===
FORMAT: PMCR-O-SOURCE-DUMP/1
PROJECT: <project>
REVISION: <git revision or UNKNOWN>
GENERATED: <UTC timestamp>

=== MANIFEST ===
ROOT: <repository-relative root>
FILES: <count>

=== FILE: <repository-relative path> ===
TYPE: <source|skill|reference|script|asset|template|configuration|state|other>
ENCODING: utf-8
--- BEGIN FILE ---
<file contents>
--- END FILE ---

=== END PMCR-O SOURCE DUMP ===
```

`FILE` boundaries are mandatory. Paths must be repository-relative and use `/` separators. File contents are preserved as text; the generator may skip non-text/binary files unless they are explicitly supported by a future extension.

## Selection

A dump may be generated from a manifest/configuration rather than the entire repository. The recommended configuration has `include`, `exclude`, and `include_types` sections.

Example:

```yaml
include:
  - plugins/pmcro
  - projects/pmcro-skills/.agents
  - projects/pmcro-skills/.pmcro
exclude:
  - .git
  - bin
  - obj
  - node_modules
  - secrets
  - credentials
include_types:
  - source
  - skill
  - reference
  - script
  - asset
  - template
  - configuration
  - state
```

The generator must apply exclusion rules before reading file contents.

## Safety boundary

Source dumps are not permission escalation. They must not copy credentials, authentication material, private keys, environment secrets, account exports, or hidden control data merely because those files are present in the repository or workspace.

An LLM may request a broader dump, but the generator remains authoritative about protected-path exclusions.

## LLM generation

An LLM can select the context needed for a task and request a dump, but the actual file enumeration and serialization should be performed by a deterministic exporter. This keeps context selection adaptive while keeping file contents grounded in the filesystem.

Recommended flow:

```text
Goal / Seed Intent
      ↓
Orchestrator selects required context
      ↓
Source Dump selection
      ↓
Deterministic exporter
      ↓
Text-only dump
      ↓
Third-party LLM
```

## Relationship to the PMCR-O Text Protocol

The Source Dump transports repository/project context. The PMCR-O Text Protocol transports structured PMCR-O objects such as Seed Intents, Frames, trails, constraints, approvals, and O-Mode decisions.

They are complementary:

```text
Repository context → Source Dump
PMCR-O state       → Text Protocol
```

A future runtime may embed both in one text request, but their schemas remain distinct so repository contents do not become confused with operational state.