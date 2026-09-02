---
name: security-review
description: Reviews code changes for security vulnerabilities, authentication gaps, and injection risks
disable-model-invocation: true
argument-hint: <branch-or-path>
---

## Diff to review

!`git diff $ARGUMENTS`

Audit the changes above for:

1. Injection vulnerabilities (SQL, XSS, command)
2. Authentication and authorization gaps
3. Hardcoded secrets or credentials

Report findings with severity ratings and remediation steps.

## Automation

Before the manual pass, run the hardcoded-secret pre-check (resolve
`$SKILL_DIR` as the directory containing this file):

```powershell
pwsh "$SKILL_DIR/scripts/scan-secrets.ps1" $ARGUMENTS
```

Treat its output as leads to confirm, not a final verdict — it only
catches obviously-shaped secrets by regex, not logic-level auth or
injection issues, and it can both miss real secrets and flag
non-secrets.

## Output template`r`n`r`nUse `assets/templates/security-review-report.md.template` as the baseline structure when producing a reusable review report. Keep evidence tied to the reviewed diff and do not treat the template as a substitute for analysis.`r`n`r`n## References

- [references/checklist.md](references/checklist.md) — full review checklist
