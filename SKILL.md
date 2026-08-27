---
name: agents-skill-directory
description: >
  Scaffold or explain the Agents project configuration tree
  (AGENTS.md, .agents/rules, skills, commands, agents, workflows).
  Use when the user wants a standard Agents layout, path-scoped rules,
  reusable skills, slash commands, or subagents.
user-invokable: true
---

# Agents Skill Directory

This skill provides a complete, copy-ready directory tree for Agents configuration.

## When to use

- Bootstrapping a new repo with `AGENTS.md` + `.agents/`
- Adding path-scoped rules, skills, commands, or subagents
- Aligning a team on shared permissions, hooks, and MCP servers

## Project tree (copy from `template/project/`)

```
your-project/
├── AGENTS.md
├── .mcp.json
├── .worktreeinclude
└── .agents/
    ├── settings.json
    ├── settings.local.json      # gitignored
    ├── rules/
    │   ├── testing.md
    │   └── api-design.md
    ├── skills/
    │   └── security-review/
    │       ├── SKILL.md
    │       └── checklist.md
    ├── commands/
    │   └── fix-issue.md
    ├── output-styles/
    ├── agents/
    │   └── code-reviewer.md
    ├── workflows/
    └── agents-memory/
```

## Global tree (copy from `template/global/` into `~/`)

```
~/
├── .agents.json
└── .agents/
    ├── AGENTS.md
    ├── settings.json
    ├── keybindings.json
    ├── themes/
    ├── projects/                # autogen memory
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    │   └── teaching.md
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

## Badges

- **committed** — share with the team via git
- **gitignored** — local overrides (e.g. `settings.local.json`)
- **local** — never committed (user home)
- **autogen** — written by Agents (memory files)

## How to apply

1. Copy `template/project/*` into the repository root.
2. Commit everything except `settings.local.json` and autogen folders.
3. Customize `AGENTS.md`, rules, and skills for the stack.
4. Optionally copy `template/global/*` into the user home for personal defaults.
