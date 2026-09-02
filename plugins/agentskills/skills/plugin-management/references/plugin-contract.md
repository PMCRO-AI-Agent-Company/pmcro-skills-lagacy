# Plugin Contract

## Required

- `plugin.json`
- unique lowercase kebab-case plugin name
- `skills/` containing at least one skill
- every skill has `SKILL.md`

## Optional

- `agents/`
- `assets/`
- `references/`
- `scripts/`
- `.claude-plugin/plugin.json`
- `.codex-plugin/plugin.json`
- `version.json`

## Registration

Marketplace entries must point to the plugin directory and use the same
plugin identity as its manifest.

## Third-party provenance

External sources should retain source URL/repository, revision or version,
import timestamp, and validation result in the importing project's provenance
record.
