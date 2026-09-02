---
name: create-custom-agent
description: Creates VS Code custom agent files for specialized AI personas with tools, instructions, and handoffs. Use when scaffolding a new custom agent or configuring agent-to-agent handoffs.
license: MIT
---

# Create Custom Agent

Create a focused custom-agent persona using the repository's agent conventions.

## When to Use

- Creating a new `.agent.md` persona.
- Defining tools, instructions, or handoffs for a specialized agent.
- Deciding whether a task needs a dedicated persona.

## When Not to Use

- Creating an Agent Skill (`SKILL.md`) — use `create-skill`.
- Editing an existing agent without changing its role — edit the agent directly.

## Inputs

- Agent name: lowercase, hyphenated identifier.
- Description: concise purpose and dispatch guidance.
- Tools: optional tool or tool-set allow-list.
- Handoffs: optional transitions to other agents.

## Workflow

1. Inspect existing agents and reuse a suitable persona when possible.
2. Create `agents/<agent-name>.agent.md` in the target agent surface.
3. Add YAML frontmatter with `name`, `description`, and optional `tools`/`handoffs`.
4. Write a concrete persona with role, responsibilities, boundaries, and completion criteria.
5. Validate the resulting frontmatter and referenced handoffs.

## References

- `references/agent-frontmatter.md` — frontmatter fields and examples.

## Assets

- `assets/agent.md.template` — starter custom-agent template.

## Scripts

- `scripts/scaffold-agent.ps1` — creates a new agent skeleton without overwriting existing files.
