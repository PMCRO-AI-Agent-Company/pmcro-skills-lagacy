# Layouts — aligned with Agents Directory Explorer

Source of truth for consumer trees: Project + Global explorer nodes.

## Skill folder rule (always)

```
skills/<skill-name>/
├── SKILL.md
├── scripts/          # ALWAYS (.gitkeep if empty)
├── references/       # ALWAYS (.gitkeep if empty)
└── assets/           # ALWAYS (.gitkeep if empty)
```

Optional supporting files (e.g. `checklist.md`) sit beside `SKILL.md`.

---

## Project (`project/` → repo root)

```
your-project/
├── AGENTS.md                         # committed
├── .mcp.json                         # committed
├── .worktreeinclude                  # committed
└── .agents/
    ├── settings.json                 # committed
    ├── settings.local.json           # gitignored
    ├── rules/
    │   ├── testing.md
    │   └── api-design.md
    ├── skills/
    │   └── <skill-name>/
    │       ├── SKILL.md
    │       ├── checklist.md
    │       ├── scripts/
    │       ├── references/
    │       └── assets/
    ├── commands/
    │   └── fix-issue.md
    ├── output-styles/
    ├── agents/
    │   └── code-reviewer.md
    ├── workflows/
    └── agents-memory/
```

---

## Global (`~/.agents`)

```
~/
├── .agents.json
└── .agents/
    ├── AGENTS.md
    ├── settings.json
    ├── keybindings.json
    ├── themes/
    ├── projects/
    ├── rules/
    ├── skills/
    ├── commands/
    ├── output-styles/
    ├── agents/
    ├── workflows/
    └── agents-memory/
```

---

## Generator → domain product

`agent-skills` (marketplace) generates domain marketplaces (e.g. **dotnet-skills**) using the same triple-manifest + always `scripts/`/`references/`/`assets/` skill shape as github.com/dotnet/skills.

