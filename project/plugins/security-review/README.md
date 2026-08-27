# security-review

Reviews code changes for security vulnerabilities, authentication gaps, and
injection risks.

## When to use this plugin

- Auditing a diff, branch, or path before merging
- Checking for injection vulnerabilities, auth gaps, or hardcoded secrets

## Skills

| Skill | Description |
|---|---|
| `security-review` | Diffs the given branch/path and audits it against `checklist.md`. `disable-model-invocation: true` — invoked explicitly, not auto-triggered. |

## Structure

```
security-review/
├── plugin.json                    # canonical manifest
├── .claude-plugin/plugin.json     # Claude Code install manifest (mirrors plugin.json)
├── version.json
└── skills/
    └── security-review/
        ├── SKILL.md
        ├── checklist.md
        └── README.md
```
