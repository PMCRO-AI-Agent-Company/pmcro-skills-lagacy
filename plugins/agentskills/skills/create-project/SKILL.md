---
name: create-project
description: Generates a complete Agent Skills project from a declarative manifest, including marketplace manifests, project-local configuration, plugins, skills, tests, and repository guidance. Use when bootstrapping a new Agent Skills marketplace or regenerating its structure. Do not use for adding one skill to an existing project.
license: MIT
---

# Create Project

Generate an entire Agent Skills repository as a coherent instance of the
AgentSkills project template. The generator is deterministic and must not
silently overwrite existing files.

## Output boundary

When no output path is supplied, create the new instance at
`projects/<project-name>/`. The repository root `.agents/` remains global
authoring infrastructure; generated projects receive their own local `.agents/`.

## Agents

Agents are optional project artifacts. Do not impose a repository-wide `agent0`
identity. Projects define their own personas, tools, and handoff topology.

## Inputs

- Project name: lowercase identifier used by generated manifests.
- Display name: human-facing marketplace name.
- Description: project purpose.
- Output path: optional destination; defaults to `projects/<name>`.
- Plugins: one or more plugin identifiers.
- `-EnablePmcro`: optional first-party PMCR-O capability; adds the `pmcro-loop` plugin and a clean `.pmcro/` runtime-state scaffold.

## Workflow

1. Validate the project identifier and destination.
2. Build a generation plan before writing anything.
3. Refuse to overwrite non-empty destinations unless explicitly allowed.
4. Generate repository guidance, local `.agents`, marketplace manifests,
   plugins, skill package boundaries, and evaluation contracts.
5. Render tokens only from the supplied project manifest.
6. Validate JSON, required paths, flat support directories, and manifest sync.
7. Report every generated root and plugin.

## Template boundary

Project templates live directly in `assets/` with destination-oriented filenames.
The template engine owns rendering; this skill owns the project-generation
contract. Individual skill templates remain reusable by `create-skill`.

## Safety and validation

Generation must fail closed for existing user content. Never delete or rename
existing project files. Run `scripts/generate-project-flat.ps1 -WhatIf` when reviewing
a new configuration, then run `scripts/validate-project.ps1` after generation.

## References

- `references/project-schema.md` — manifest fields and invariants.
- `references/generation-model.md` — template ownership and generation order.

## Scripts

- `scripts/generate-project-flat.ps1` — deterministic whole-project generator.
- `scripts/validate-project.ps1` — deterministic generated-project validator.


