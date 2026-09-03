# Earned Knowledge: constraint-20260903-175440-adhoc-tool-use-must-be-scripted

constraint_id: constraint-20260903-175440-adhoc-tool-use-must-be-scripted
kind: constraint
scope: any cycle exercising an external CLI/API (gh, and by the same
  reasoning any future wrapped tool) that already has, or plausibly
  should have, a home under a plugin's skills/*/scripts/
status: superseded
superseded_by: rule-policy-20260903-182600-external-tool-use-must-be-scripted
created_at: 2026-09-03T17:54:40Z

## Statement
When a cycle needs a capability an external CLI provides (e.g. `gh repo
view`, `gh api ...`), that capability should be exercised through an
implemented, live-tested script under the relevant plugin's
`skills/*/scripts/` (with its use documented in that skill's SKILL.md),
not typed inline ad hoc — even for read-only recon. If no such script
exists yet, write and live-test one before or in place of the ad hoc
call, rather than after the fact. This mirrors `create-skill`'s
Repository Contract for a skill's own packaged functionality, extended
here to cover ad hoc use of an *external* tool mid-task.

## Evidence (source trails)
- cycle-20260903-175440-task-pmcro-runtime-collision-and-governance
