# security-review/

Reviews code changes for security vulnerabilities, authentication
gaps, and injection risks.

Part of the `.agents/skills/` PMCRO runtime spec — see
`project/.agents/skills/README.md` for the structured skill-folder
convention this follows.

## Files

| File | Purpose |
|---|---|
| `SKILL.md` | Frontmatter (`description`, `disable-model-invocation`, `argument-hint`) + instructions. Diffs the given branch/path and audits it. |
| `scripts/scan-secrets.ps1` | Regex pre-check for obviously-shaped hardcoded secrets (AWS keys, API key assignments, private key headers, Slack/GitHub tokens, JWT-looking strings) in the diff's added lines. Leads to confirm, not a verdict. |
| `references/checklist.md` | Full review checklist (input validation, authentication) that `SKILL.md` links to rather than inlining. |

`disable-model-invocation: true` is set — this skill only runs when
explicitly invoked, not auto-triggered from conversation.
