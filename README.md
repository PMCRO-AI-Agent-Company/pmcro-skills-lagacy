# Agents Skill Directory

Hierarchical template for project-level and global **Agents** configuration.

Repo: copy-ready `.agents/` layouts + install scripts. Matches the **Agents Skill Directory Explorer** tree (AGENTS.md, skills, rules, commands, agents, workflows).

## Layouts

| Layout | Path | Install target |
|--------|------|----------------|
| **Project** | `template/project/` | Repository root |
| **Global** | `template/global/` | User home (`~/`) |

See [LAYOUTS.md](LAYOUTS.md) for the full tree diagrams.

## Quick install

```bash
# Project layout into current directory
./scripts/install-template.sh .

# Project + global (~/.agents)
./scripts/install-template.sh . --global

# Windows
./scripts/install-template.ps1 -Target . -Global
```

## Project tree (after install)

```
your-project/
├── AGENTS.md
├── .mcp.json
├── .worktreeinclude
└── .agents/
    ├── settings.json
    ├── settings.local.json      # gitignored
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

## Badge legend

| Badge | Meaning |
|-------|--------|
| committed | Tracked in git, shared with the team |
| gitignored | Present but ignored (e.g. settings.local.json) |
| local | Never committed (user home) |
| autogen | Written by Agents (memory) |

## Relation to pmcro-skills

- **pmcro-skills** — MAF skill *catalog* (`catalog/.../skills/`)
- **This repo** — *consumer* layout (`ProjectName/.agents/`) that those skills install into

## Skill entrypoint

See [SKILL.md](SKILL.md) for agent-facing instructions.
