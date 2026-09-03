# Earned Knowledge: rule-policy-20260903-182600-external-tool-use-must-be-scripted

constraint_id: rule-policy-20260903-182600-external-tool-use-must-be-scripted
kind: rule-policy
scope: any cycle exercising an external CLI, package manager, or test
  framework capability that already has, or plausibly should have, a
  home under a plugin's skills/*/scripts/ -- widened from
  constraint-20260903-175440's gh-only scope
status: active
superseded_by:
created_at: 2026-09-03T18:26:00Z

## Statement
When a cycle needs a capability an external tool provides (a CLI like
`gh`, a VCS operation like `git commit`, a package/module install like
`Install-Module Pester`), that capability should be exercised through an
implemented, live-tested script under the relevant plugin's
`skills/*/scripts/` (with its use documented in that skill's SKILL.md),
not typed inline ad hoc -- even for a "quick check." If no such script
exists yet, write and live-test one before or in place of the ad hoc
call, rather than after the fact.

## Evidence (source trails)
- cycle-20260903-175440-task-pmcro-runtime-collision-and-governance
  (gh: `gh repo view`/`gh api` typed inline while investigating
  pmcro-runtime; fixed by building github-skills/pr-lifecycle's
  inspect-repo.ps1)
- cycle-20260903-181500-task-execution-law-and-runtime-handoff (git:
  raw `git commit`/`git push` run inline against pmcro-skills' own
  main branch, twice, before being named)
- cycle-20260903-183000-task-fix-queue-enqueue-and-siblings (Pester:
  `Install-Module Pester`/`Invoke-Pester` about to be run inline mid-task
  to verify a fix, caught before execution; fixed by building
  pester-skills/setup-pester + run-tests)

Three independent instances across three different tools in one session
is the recurrence bar `knowledge-promotion.md` sets for promoting past a
single-instance provisional constraint -- this record supersedes
`constraint-20260903-175440-adhoc-tool-use-must-be-scripted.md`
(status set to `superseded`, `superseded_by` pointing here) per the
schema's own scope-discipline rule: widening scope is a new record, not
an edit in place.
