---
name: template-engine
description: Renders the canonical Agent Skills project templates into a new repository without overwriting user content. Use for project initialization, template discovery, deterministic rendering, and generation-plan inspection.
license: MIT
---

# Template Engine

The template engine is the generation layer beneath `create-project`.
It treats a project as an instance of a reusable Agent Skills template.

## Responsibilities

1. Discover canonical templates relative to this skill.
2. Resolve project tokens from a validated manifest.
3. Produce a deterministic file plan before writing.
4. Render text templates without executing template content.
5. Reject unknown tokens and unsafe output paths.
6. Validate generated manifests and structure.

## Token Contract

Supported tokens are `{{PROJECT_NAME}}`, `{{DISPLAY_NAME}}`,
`{{DESCRIPTION}}`, `{{PLUGIN_NAME}}`, and `{{PLUGIN_DESCRIPTION}}`.
Unknown tokens are errors. Values are data, never executable code.

## Invariants

- No absolute paths are emitted by templates.
- No generated path may escape the output root.
- Existing non-empty destinations are never overwritten by default.
- Marketplace plugin sources use `./plugins/<name>`.
- Every generated plugin has `plugin.json`, `version.json`, and `skills/`.

## References

- `references/template-contract.md` — rendering rules and invariants.
- `../create-project/references/project-schema.md` — project manifest.

## Scripts

- `scripts/render-template.ps1` — deterministic single-file renderer.

