# security-review

Reviews code changes for security vulnerabilities, authentication gaps, and
injection risks.

## When to use this plugin

- Auditing a diff, branch, or path before merging
- Checking for injection vulnerabilities, auth gaps, or hardcoded secrets

## Skills

| Skill | Description |
|---|---|
| `security-review` | Reviews the given branch or path against the security checklist. |

## Structure

```text
security-review/
├── plugin.json
├── .claude-plugin/plugin.json
├── .codex-plugin/plugin.json
├── version.json
└── skills/
    └── security-review/
        ├── SKILL.md
        ├── assets/
        │   └── templates/
        ├── references/
        │   └── checklist.md
        └── scripts/
            └── scan-secrets.ps1
```

The plugin manifest is the distribution boundary. The skill contains its
runtime instructions and supporting material; evaluations live under the
repository-level `tests/<plugin>/<skill-name>/` tree.
