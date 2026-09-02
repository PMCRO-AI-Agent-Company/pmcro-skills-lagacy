# Subagents

Subagents are markdown files under `agents/` with frontmatter such as `name`, `description`, and optional tool restrictions.

Template: `../assets/templates/agent.md.template`.

Validate required frontmatter and never claim a tool is available unless the runtime actually exposes it.