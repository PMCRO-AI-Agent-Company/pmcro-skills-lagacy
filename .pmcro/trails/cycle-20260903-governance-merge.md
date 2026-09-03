# Trail: cycle-20260903-governance-merge

trail_id: cycle-20260903-governance-merge
task_id: task-pmcro-loop-governance-merge
domain: pmcro-governance
priority: 2
opened: 2026-09-03

## Seed intent
Non-destructive merge (option C-2) of governance/role-contract material from
the nested projects/pmcro-skills/plugins/pmcro-loop role skills into the
canonical plugins/pmcro-loop, per human-approved plan. MAKE + CHECK only;
deletion of the nested tree explicitly withheld pending separate approval.

## PlanFrame (Planner)
Prior session's PLAN (line-by-line comparison of 5 nested role SKILL.md vs.
canonical agents/*.md + 7 lifecycle skills, 5 role-contract.md, 5
AGENTS.md.template, 5 validate-skill.ps1, PmcroEngine.psm1 diff) identified
11 migration items, mapped each to a canonical destination, and produced the
proposed directory tree, migration table, and creation/modification lists
approved by the human this session with two corrections: read all 5
AGENTS.md.template in full before drafting (done — all differ only in
role name/purpose/mechanic, no hidden content), and the creation count is 8
files, not 7.

## MakeFrame (Maker)
Created (8), all under plugins/pmcro-loop/:
- references/common-pitfalls.md — consolidated 6-row pitfall table (was 5x identical)
- references/role-boundaries.md — consolidated When-to-use/not matrix, all 5 roles
- scripts/validate-skill.ps1 — promoted from 5 byte-identical nested duplicates
- assets/AGENTS.md.{orchestrator,planner,maker,checker,reflector}.template (5)

Modified (9), additive-only (no existing section removed/restructured):
- agents/{orchestrator,planner,maker,checker,reflector}.md — one-line cross-ref
  to references/role-boundaries.md + common-pitfalls.md
- skills/plan-frame/SKILL.md — added Portability + Validation sections
- skills/make-frame/SKILL.md — added Write discipline & portability + Validation
- skills/check-frame/SKILL.md — added Failure routing + Validation; clarified
  "retry" recommendation means fresh next cycle, not same-cycle handback
- skills/reflect-and-seed/SKILL.md — added Failure/retry path + Validation

engine/PmcroEngine.psm1 (canonical) — unchanged, not touched.
Nested projects/pmcro-skills/plugins/pmcro-loop — unchanged, not touched
(verified present/untouched post-hoc: 5 role folders still intact).

## CheckFrame (Checker)
Verdict: **pass**.

- All 5 unique nested governance items preserved in canonical: common
  pitfalls (verbatim), role boundaries (verbatim, restructured per-role),
  the one true engine duplicate (PmcroEngine.psm1, one-blank-line diff)
  correctly left as superseded-not-copied, 5 distinct AGENTS.md templates
  preserved without truncation (read in full, confirmed distinct), and the
  4 role-specific invariants (planner path-portability, maker
  write-tool/portability, checker fail-routing, reflector fail/retry path)
  each landed in their correct canonical skill file.
- Engine-vs-doc conflict check: PmcroEngine.psm1 (canonical, read in full)
  implements only claim + linear trail-skeleton allocation — no code path
  exists for a mid-cycle Checker-to-Maker handback under either the old or
  new phrasing. Adopting the stricter "never loop back mid-cycle" wording
  is therefore a clarification of ambiguous prose, not a change to actual
  runtime behavior; no genuine engine/doc contradiction found.
- All 7 lifecycle capabilities (plan, make, check, reflect, orchestrate,
  queue-claim, queue-enqueue) remain available and unchanged in mechanic.
- No canonical skill now contradicts colony-laws.md or trail-format.md
  (neither file was touched; both remain at projects/pmcro-skills root,
  correctly left outside the plugin per PLAN item 10/11).
- Structural check: post-edit directory listing of plugins/pmcro-loop
  matches the proposed tree exactly (references/, scripts/, assets/ now
  populated; skills/*/{assets,references,scripts} untouched .gitkeep dirs).
- Git/path check: not run this cycle (no execute_command/git tool invoked);
  recommend a `git status` pass in projects/pmcro-skills before commit to
  confirm the change set matches this trail's 17 file list.
- Could not independently prove: whether other tooling references any of
  the 9 modified files by exact section name/anchor elsewhere in the repo
  (only additive sections were added, so risk is low but unverified).

## Reflection (Reflector)
- Queue item task-pmcro-loop-governance-merge -> done (this cycle's scope,
  non-destructive merge, is complete and CHECK-passed).
- task-repo-cleanup left untouched at status "claimed" — NOT marked done.
  Per explicit human correction this session, absence of a target directory
  is not sufficient evidence of a verified cleanup; that verification is
  separate, unperformed work and out of scope for this cycle.
- Follow-up enqueued: task-pmcro-loop-nested-supersession (priority 2, open,
  blocked_by this task) — carries the recommended-but-ungated next step
  (deciding the fate of the now-superseded nested role skills) so it isn't
  lost as prose. Not auto-claimed; requires separate human approval per the
  human's explicit "STOP before deletion" instruction.
- No earned constraint promoted this cycle — the engine/doc "retry" wording
  fix is a one-time doc clarification tied to a specific observed ambiguity,
  not yet a recurring pattern across cycles.
- session-state.md set to idle; no natural next seed claimed automatically,
  consistent with "auto-run stops only for priority-0" not applying here —
  this is a deliberate human-approval gate, not an idle-disposition default.
- No marketplace, commit, or push actions were taken.

trail_sealed: true
