---
name: fix-and-verify
description: End-to-end workflow for closing a reported issue — investigate, fix, test, and review before calling it done.
steps:
  - kind: command
    ref: fix-issue
    args: <issue-number>
    does: Looks up the issue and produces an initial fix plus tests.
  - kind: agent
    ref: code-reviewer
    does: Reviews the diff for correctness, security, and maintainability.
    gate: Any finding without a concrete fix blocks the next step.
---

# fix-and-verify

Chains an explicit issue-fix command with a review agent and validation rather
than relying on implicit handoffs.

## Steps

1. **`/fix-issue <issue-number>`** — investigate the issue, implement the fix,
   and write or update tests.
2. **`code-reviewer` agent** — review the resulting diff. Any unresolved finding
   blocks completion; return to the fix step when necessary.
3. **Validation** — run the repository's applicable tests and report failures
   truthfully before declaring the issue complete.

Path-scoped rules apply automatically wherever their paths match; they are not
workflow steps because they are always-on constraints.
