---
name: eval-harness
description: Runs a golden-case regression check against a target skill and hands the transcript to the eval grader for scoring. Use when testing a skill against golden/expected cases or before treating a modified skill as validated. Do not use for manifest-only linting.
---

# Eval Harness Workflow

### 1. Locate the target skill and its golden cases
Golden cases live at `references/cases.md` inside this skill for
fallback checks, or at `plugins/<plugin>/skills/<skillId>/references/
eval-cases.md` when a skill defines its own (preferred).

### 2. Run the target skill's script(s)
Execute the skill's documented `scripts/*` against a scratch target
outside the repo. Capture the exact command, full stdout/stderr, and
a recursive directory listing of the resulting output.

### 3. Compare against golden cases
For each case, compare the captured evidence with the expected
shape/content and record pass/fail.

### 4. Hand off to the evaluator
Pass the transcript and pass/fail notes to the repository's evaluation
agent using `references/rubric.md`. Do not self-grade; the harness
collects evidence.

### 5. Record result
If the run is worth preserving, record it in the repo's documented
repository-memory location rather than inventing a second state store.

### 6. Capability Integrity
Before declaring a target skill usable, verify that every path, command,
script, and operation claimed by its SKILL.md has a real implementation.
Missing functionality is a blocking failure; implement it before use.

## Pitfalls
- Reading a script is not an eval; actually run it against a scratch target.
- Never write eval output into the repository itself.

