# Trail: cycle-20260903-191546-task-reconcile-project-vs-projects-topology

trail_id: cycle-20260903-191546-task-reconcile-project-vs-projects-topology
task_id: task-reconcile-project-vs-projects-topology
domain: pmcro-governance
priority: 2
opened: 2026-09-03
run_id: (investigation/filing only -- no mutation performed this cycle)
checkpoint_ref: (none)
trail_sealed: true

## Seed intent

Human, dictated: "yeah but projects actually suppose to be deleted and
Should they go within the root?" -- a direct challenge to the repo's own
directory structure, prompted by the prior cycle's discovery that
`Find-PmcroRoot` only works when invoked from at or below
`projects/pmcro-skills/`.

## OrchestratorFrame

Did not assume the human meant the already-closed `task-repo-cleanup`
(confirmed via `git grep` -- that task was narrowly about one candidate
folder, `_pmcro-duplicate-backup-20260902`, which never existed anywhere
in the filesystem or git history; closed no-action-needed). Investigated
the actual current structure instead:

- `LAYOUTS.md` (repo root) is the documented source of truth. Its
  "Project (`project/` -> repo root)" section describes `project/`
  (singular, at true repo root) as an intentional template/example of
  what a *consumer* repo's own root should contain when adopting these
  conventions.
- Confirmed `project/.pmcro/` is a frozen single-cycle illustrative
  fixture (`task-understand-pmcro-framework`, dated 2026-09-02, `status:
  done`, `session-state.md` idle since) -- untouched since commit
  `f3d3d62`. Not stale cruft; a deliberate, static example.
- `git log --diff-filter=A -- project/` traced its creation to commit
  `9964a45` ("Restructure agent-skills to plugin-catalog convention...
  add `.agents/`, `.claude-plugin/`, `AGENTS.md`, `eng/`, `project/`,
  `tests/`; remove legacy flat `template/` layout").
- `git log --diff-filter=A -- projects/` traced `projects/pmcro-skills/`
  (plural, confusingly same-named as the outer repo) to a *different*
  commit, `7fbbbbc` ("Implement PMCR-O Clean Architecture CQRS slice") --
  a separate lineage from the documented `project/` template.
- Read `projects/pmcro-skills/CONTEXT.md` in full. It states
  `colony-laws.md` "is intentionally kept at repository root" and
  describes `P:\agent-skills\.claude-plugin\marketplace.json` as living
  "at the agent-skills monorepo root" with `plugins/pmcro-loop/` as "a
  top-level monorepo plugin, sibling to `agentskills` and
  `agent-design-patterns`" under `P:\agent-skills\`. None of this matches
  current reality: there is no `P:\agent-skills` path on this machine;
  `plugins/pmcro-loop/` and everything else CONTEXT.md attributes to
  `P:\agent-skills\` actually lives directly under this same repo,
  `P:\source\pmcro-skills\`. CONTEXT.md was written describing an earlier
  topology -- `projects/pmcro-skills/` as a sub-project nested inside a
  separate, larger `P:\agent-skills` monorepo -- that has since been
  consolidated/renamed without CONTEXT.md being updated to match.

This confirms the human's instinct with real evidence: the nesting isn't
simply how things were always meant to be, and it isn't simply a stray
folder either -- it's a genuine unresolved leftover from an earlier,
now-defunct monorepo split, and the repo's own governing doc (CONTEXT.md)
is actively describing a topology that no longer exists.

## MakeFrame

No files moved or deleted this cycle -- deliberately. Filed
`task-reconcile-project-vs-projects-topology` (priority 2, higher than
this session's other filed items, reflecting that this is foundational --
CONTEXT.md is one of the two docs `INSTRUCTIONS.md` itself says to read
first) scoping: (a) pin down exactly when/how the two repos were
consolidated, rather than leaving that inferred; (b) get explicit human
TYPE1 approval, per `colony-laws.md`'s own approval protocol, before
migrating `projects/pmcro-skills/`'s live content up to true repo root
OR alternatively just correcting CONTEXT.md's stale claims to describe
the nesting as intentional and permanent -- both are legitimate outcomes,
not pre-deciding which; (c) explicit instruction not to touch `project/`
(singular) -- it's unrelated, deliberate template content; (d) risk
notes for whoever executes this: live `.pmcro/` state must not be lost
mid-move, the real .NET solution under `src/` has project references
that would need updating, and other scripts/docs likely hardcode
`projects/pmcro-skills/` path prefixes the way
`capability-gap-and-composition.md` was already found to (and fixed)
earlier this session.

## CheckFrame
verdict: pass

- Every structural claim in the filed seed_intent is traced to a
  specific piece of evidence (a `LAYOUTS.md` section, a commit hash, a
  file's actual content, a `git grep` result) rather than asserted from
  inference alone.
- Did not conflate this with `task-pmcro-loop-nested-supersession`
  (already `done` -- the narrower orphaned-duplicate-plugin question)
  or `task-repo-cleanup` (already `done` -- an unrelated stray-folder
  check) -- checked both before concluding this was a genuinely new,
  unaddressed finding rather than re-filing settled work.
- `queue.jsonl`: 41 -> 42 lines, new item verified as valid JSON.
- Scratch driver script (`run-enqueue-repo-topology.ps1`) removed
  post-run.

## Reflection
outcome: done
next_seed_intent: captured in full inside the filed queue item. This is
the largest-blast-radius, highest-priority open item filed this session
-- explicitly requires human TYPE1 approval before any file moves, per
this repo's own governance, and should not be claimed and executed
casually alongside smaller backlog items.
