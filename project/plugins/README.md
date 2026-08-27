# plugins/

Installable, distributable plugins — the packaging layer above
`../.agents/skills/`. Follows the same shape `dotnet/skills` uses:

```
plugins/<plugin-name>/
├── plugin.json                 # canonical manifest (name, version, description, skills[], agents[])
├── .claude-plugin/plugin.json  # Claude Code install manifest — mirrors plugin.json
├── version.json
├── README.md
└── skills/
    └── <skill-name>/
        ├── SKILL.md
        └── <support-file>.md   # flat layout, no scripts/references/assets
```

Every plugin listed here should also have an entry in the root
`.claude-plugin/marketplace.json`, and pass
`python eng/eval-quality/check_eval_quality.py`.

## When a skill belongs here vs. `.agents/skills/`

| Skill is... | Lives in |
|---|---|
| Meant to be installed/shared across projects | `plugins/<name>/skills/` (a plugin) |
| Specific to this one project, not distributed | `.agents/skills/` |
| A tool for authoring *this repo itself* | root `/.agents/skills/` |

See `/.agents/skills/agent-skill/SKILL.md` at the repo root for the full
decision guide and scaffolding steps.

## Current plugins

- `security-review/` — reviews a diff for security vulnerabilities,
  authentication gaps, and injection risks.
