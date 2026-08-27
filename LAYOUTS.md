# DirectoryExplorer tree — fully implemented

Matches the Agents Skill Directory Explorer UI (Project + Global tabs).

## Project (`template/project/`)

```
your-project/
├── AGENTS.md                          # committed
├── .mcp.json                          # committed
├── .worktreeinclude                   # committed
└── .agents/
    ├── settings.json                  # committed
    ├── settings.local.json            # gitignored
    ├── rules/
    │   ├── testing.md                 # path-scoped
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
    └── agents-memory/                 # autogen
```

## Global (`template/global/` → `~/`)

```
~/
├── .agents.json                       # local
└── .agents/
    ├── AGENTS.md
    ├── settings.json
    ├── keybindings.json
    ├── themes/
    ├── projects/                      # autogen memory
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    │   └── teaching.md
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

```bash
./scripts/install-template.sh /path/to/app
./scripts/install-template.sh /path/to/app --global
```
