# Agents Skill Directory

Hierarchical template for project-level and global **Agents** configuration.

This repository is a ready-to-copy tree that mirrors the structure used by the **Agents Skill Directory Explorer** (MAUI app).

## Project root layout

```
your-project/
├── AGENTS.md                 # Project instructions (committed)
├── .mcp.json                 # Project-scoped MCP servers (committed)
├── .worktreeinclude          # Gitignored files to copy into worktrees (committed)
└── .agents/
    ├── settings.json         # Permissions, hooks, model (committed)
    ├── settings.local.json   # Personal overrides (gitignored)
    ├── rules/                # Path-scoped instruction files
    │   ├── testing.md
    │   └── api-design.md
    ├── skills/               # Reusable skills (folder + SKILL.md)
    │   └── security-review/
    │       ├── SKILL.md
    │       └── checklist.md
    ├── commands/             # Single-file /slash commands
    │   └── fix-issue.md
    ├── output-styles/        # Shared output styles (optional)
    ├── agents/               # Subagents with isolated context
    │   └── code-reviewer.md
    ├── workflows/            # Dynamic multi-agent workflows
    └── agents-memory/        # Subagent persistent memory (autogen)
        └── <agent-name>/
            └── MEMORY.md
```

## Global (`~/`) layout

```
~/
├── .agents.json              # App state, personal MCP servers (local)
└── .agents/
    ├── AGENTS.md             # Personal preferences (local)
    ├── settings.json         # Default settings for all projects (local)
    ├── keybindings.json
    ├── themes/
    ├── projects/             # Auto-memory per project (autogen)
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    │   └── teaching.md
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

## Badge legend

| Badge        | Meaning                                      |
|--------------|----------------------------------------------|
| committed    | Tracked in git, shared with the team         |
| gitignored   | Present in the tree but ignored by git       |
| local        | Never committed (user-only)                  |
| autogen      | Written/maintained by Agents automatically   |

## Quick start

1. Copy the contents of `template/project/` into your repository root.
2. Commit the files marked **committed**.
3. Add `**/.agents/settings.local.json` to `.gitignore` (or rely on the global excludes file).
4. Customize `AGENTS.md`, `rules/`, and `skills/` for your stack.

## Related

- Source data model used by the Directory Explorer UI lives in `explorer-data.json`.
- Example skill, rules, command, and subagent are included under `template/project/.agents/`.
