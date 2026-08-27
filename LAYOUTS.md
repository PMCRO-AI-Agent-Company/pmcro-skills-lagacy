# Layout reference — project vs global

## Project layout (`template/project/` → repo root)

```
your-project/
├── AGENTS.md                 # committed — project instructions
├── .mcp.json                 # committed — team MCP servers
├── .worktreeinclude          # committed — gitignored files to copy into worktrees
└── .agents/
    ├── settings.json         # committed — permissions, hooks, model
    ├── settings.local.json   # gitignored — personal overrides
    ├── rules/                # committed — path-scoped rules
    │   ├── testing.md
    │   └── api-design.md
    ├── skills/               # committed — reusable skills
    │   └── security-review/
    │       ├── SKILL.md
    │       └── checklist.md
    ├── commands/             # committed — /slash commands
    │   └── fix-issue.md
    ├── output-styles/        # optional shared styles
    ├── agents/               # subagents
    │   └── code-reviewer.md
    ├── workflows/            # dynamic workflows
    └── agents-memory/        # autogen subagent memory
```

Install:

```bash
./scripts/install-template.sh /path/to/your-project
```

## Global layout (`template/global/` → `~/`)

```
~/
├── .agents.json              # local — app state, personal MCP
└── .agents/
    ├── AGENTS.md             # local — personal preferences
    ├── settings.json         # local — defaults for all projects
    ├── keybindings.json
    ├── themes/
    ├── projects/             # autogen auto-memory per project
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    │   └── teaching.md
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

Install:

```bash
./scripts/install-template.sh . --global
```

## Relation to pmcro-skills

`pmcro-skills` is the **catalog** of MAF skills (`catalog/.../skills/<name>/`).

Consuming projects pull those skills into:

```text
ProjectName/.agents/skills/     ← file-based MAF source (this layout)
```

This repo defines that **consumer** tree (`.agents/`), not the catalog itself.
