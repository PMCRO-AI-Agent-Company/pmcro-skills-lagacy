# agents/

Subagent persona definitions. Each file is a standalone persona the
PMCRO runtime can dispatch a task to — a name, description, allowed
tools, and system-style instructions for how that persona should
behave.

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

One Markdown file per persona, named after it (`code-reviewer.md` →
persona `code-reviewer`). Frontmatter fields in use:

| Field | Required | Notes |
|---|---|---|
| `name` | Yes | Matches the filename (minus `.md`) |
| `description` | Yes | What this persona is for and when to dispatch to it |
| `tools` | No | Comma-separated allow-list restricting what the persona can invoke |

Body is plain-prose instructions for how the persona should think and
respond.

## Current personas

- `code-reviewer.md` — reviews code for correctness, security, and
  maintainability.
- `repo-architect.md` — maintains this repo's own structure and
  conventions (`.agents/` layout, skill/plugin scaffolding, eval gate).
