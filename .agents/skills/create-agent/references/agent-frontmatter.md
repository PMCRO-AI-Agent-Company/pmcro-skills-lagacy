# Agent Frontmatter Reference

Required fields:

- `name`: lowercase hyphenated identifier matching the filename.
- `description`: responsibility plus explicit dispatch conditions.
- `tools`: optional minimal allow-list.

The body is a role prompt, not a procedural skill. Keep it concise and
finish with a concrete output contract.

Project agents live under `project/.agents/agents/` and use one flat
Markdown file per persona.

Before creating a persona, check the project's current-personas list
and extend an existing fit instead of creating a duplicate.
