---
name: fix-and-verify
description: >
  End-to-end workflow for closing out a reported issue — investigate,
  fix, test, and security-review before calling it done.
steps:
  - kind: command
    ref: fix-issue
    args: <issue-number>
    does: Looks up the issue and produces an initial fix + tests.
  - kind: agent
    ref: code-reviewer
    does: Reviews the diff for correctness, security, maintainability.
    gate: Any finding without a concrete fix blocks the next step.
  - kind: plugin-skill
    ref: security-review
    plugin: security-review
    condition: Diff touches src/api/** or anything auth-related.
    does: Explicit security pass beyond code-reviewer's general check.
---

# fix-and-verify

Chains a command, an agent, and a plugin skill into one pass, instead
of running each in isolation and hoping the handoffs happen.

## Steps

1. **`/fix-issue <issue-number>`** — pulls the issue via `gh issue
   view`, traces root cause, implements a fix, writes/updates tests.
2. **`code-reviewer` agent** — reviews the resulting diff. Any finding
   without a concrete fix blocks moving on; go back to step 1.
3. **`security-review` skill** (only if the diff touches `src/api/**`
   or anything auth-related) — explicit injection/auth/secrets pass,
   since `code-reviewer`'s security check is general-purpose, not a
   dedicated audit.

Path-scoped rules (`../rules/api-design.md`, `../rules/testing.md`)
apply automatically wherever they match — they aren't listed as a
step here because they aren't invoked, they're just always-on while
the matching files are being touched.

## Convention this settles

```yaml
---
name: <workflow-name>
description: One-paragraph summary of what this closes out.
steps:
  - kind: command | agent | plugin-skill
    ref: <name matching the file/plugin it points to>
    args: <optional, for commands>
    plugin: <required if kind is plugin-skill>
    condition: <optional — when this step applies>
    gate: <optional — what blocks moving past this step>
    does: One line, what this step actually does.
---
```

Body is prose walking through the same steps with enough detail to
run the workflow without re-deriving it from the frontmatter alone.
