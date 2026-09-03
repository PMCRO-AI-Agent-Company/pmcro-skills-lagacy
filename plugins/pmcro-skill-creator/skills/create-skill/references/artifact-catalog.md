# Agent artifact catalog

This catalog is derived from the AgentSkills directory-tree inventory. It distinguishes authored artifacts from runtime-generated state.

| Artifact | Template | Reference | Script support |
|---|---|---|---|
| AGENTS.md | yes | agents-md.md | validate |
| .mcp.json | yes | mcp-json.md | validate |
| .worktreeinclude | yes | worktreeinclude.md | validate |
| settings.json | yes | settings.md | validate |
| settings.local.json | yes | settings.md | validate |
| rules/*.md | yes | rules.md | scaffold/validate |
| skills/*/SKILL.md | yes | skill-structure.md | scaffold/validate |
| commands/*.md | yes | commands.md | scaffold/validate |
| output-styles/*.md | yes | output-styles.md | validate |
| agents/*.md | yes | agents.md | scaffold/validate |
| workflows/* | conditional | workflows.md | validate when supported |
| themes/*.json | yes | themes.md | validate |
| agents-memory/*/MEMORY.md | example only | memory.md | runtime-generated |
| projects/*/memory/* | example only | memory.md | runtime-generated |

Templates are complete-file starting points. Runtime-generated files must not be represented as manually authored implementations.