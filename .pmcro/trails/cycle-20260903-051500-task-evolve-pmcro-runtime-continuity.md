# Trail: cycle-20260903-051500-task-evolve-pmcro-runtime-continuity

trail_id: cycle-20260903-051500-task-evolve-pmcro-runtime-continuity
task_id: task-evolve-pmcro-runtime-continuity
domain: pmcro-governance
priority: 2
opened: 2026-09-03

## Seed intent
Evolve PMCR-O for durable runtime continuity and interruption recovery:
model Run, Checkpoint, Recovery, and Lease/heartbeat semantics; make
session bootstrap capable of discovering/recovering an interrupted Run;
never blindly retry an interrupted operation without inspecting actual
state first; preserve Messy Seed provenance and Reflector ownership of
next Seed Intent; distinguish live Run continuity from Trail history;
preserve approval boundaries across interruption/recovery.

## OrchestratorFrame
Claimed `task-evolve-pmcro-runtime-continuity` (priority 2, highest
eligible open item per queue-claim protocol). Confirmed via git status
that `plugins/pmcro/scripts/` was untouched at start and must remain so
this cycle (locked). Confirmed the two lower-priority disposition items
(`task-csproj-version-pin-disposition`, `task-pmcro-tmp-disposition`)
require a human decision and were left open, untouched.

## PlanFrame (Planner)
Read `foundation/SKILL.md`, `session-bootstrap.md`,
`accountability-and-trails.md`, `trail-frame-schema.md`,
`approvals.schema.md`, `queue.schema.md`. Confirmed no existing
Run/Checkpoint/Lease concept anywhere in the foundation. Decided the
smallest coherent change: reuse the claimed queue item as Run identity
(no new registry); add optional lease/heartbeat/checkpoint fields to
queue items; add a single new foundation reference,
`run-recovery-lease.md`, defining Checkpoint format and the mandatory
inspect-before-retry Recovery procedure; wire one new bootstrap step and
optional Frame fields (`run_id`, `checkpoint_ref`, `recovery_decision`)
into the existing session-bootstrap and trail-frame contracts. Explicitly
scoped out: touching `plugins/pmcro/scripts/` (locked) and the two
open human-decision items.

## MakeFrame (Maker)
Investigation only, changes purely additive/documentary:
- Added `plugins/pmcro/skills/foundation/references/run-recovery-lease.md`
  (Run, Checkpoint, Recovery invariant, Lease/heartbeat, approval-boundary
  preservation, Run-vs-Trail relationship, knowledge-promotion hook).
- `foundation/SKILL.md`: added one contract-family bullet.
- `session-bootstrap.md`: added step 3.5 (discover/recover a stale-lease
  Run before anything else).
- `trail-frame-schema.md`: added optional `run_id`/`checkpoint_ref`/
  `recovery_decision` fields to the Frame schema.
- `queue.schema.md`: added optional `lease_owner`/`lease_expires_at`/
  `heartbeat_at`/`checkpoint_ref` fields plus the recoverable-item rule.
No new skill was created; no runtime script was written or modified.

## CheckFrame (Checker)
verdict: pass (design/documentation scope only)
Independently verified via `git status`/`git diff` rather than trusting
the Maker's self-report:
- `plugins/pmcro/scripts/` does not appear in the modified/untracked
  list — locked directory confirmed untouched.
- The 3 pre-existing `.csproj` diffs and `.pmcro-tmp/` are unchanged and
  were not touched this cycle.
- All schema/contract edits are additive-only (new optional fields, one
  new bullet, one new numbered step, one new reference file); no
  existing required field, role boundary, or approval rule was altered
  or weakened. `git diff` on each changed file confirms this.
- The inspect-before-retry invariant is stated unconditionally in
  `run-recovery-lease.md` ("never retried blindly") and cross-referenced
  from `session-bootstrap.md` step 3.5.
- The approval-boundary section explicitly forbids inferring or
  extending a TYPE1 approval from a stale/interrupted Run and defers to
  the unchanged `approvals.schema.md` enforcement rules.
findings:
- Discovered, incidentally, that `project/.pmcro/queue.jsonl` and
  `project/.pmcro/session-state.md` (the separate, stale duplicate
  `.pmcro` tree at `project/`, not this repo's live
  `projects/pmcro-skills/.pmcro/`) carry small (2-line) uncommitted
  diffs pre-dating this cycle. Not caused by this cycle. Out of scope
  here; flagged for the Reflector.
blockers: none

## Reflection (Reflector)
Outcome: complete for this cycle's scope (contract design, no runtime
wiring). Run/Checkpoint/Recovery/Lease semantics are now defined and
integrated into the existing foundation, session-bootstrap, queue, and
trail-frame contracts without a new skill, a parallel state store, or
any change to `plugins/pmcro/scripts/`.
Lesson: the colony's existing claimed-queue-item is sufficient as a Run
identity; the durable-continuity gap was a missing *contract*, not a
missing subsystem.
Not yet done (deliberately out of scope, needs a fresh Seed): the
`pmcro-loop` engine (`plugins/pmcro/scripts/`, locked this cycle) does
not yet write/refresh `lease_owner`/`heartbeat_at`/`checkpoint_ref`, and
no skill yet performs the Recovery inspection procedurally — today it is
a documented contract a Planner/Orchestrator must apply by hand.

next_seed_intent: "Wire the run-recovery-lease.md contract into the
pmcro-loop engine: have Claim-PmcroTask write lease_owner/heartbeat_at/
lease_expires_at/checkpoint_ref on claim, add a heartbeat refresh during
active work, and add a recovery-check step to run-cycle.ps1 that applies
the inspect-before-retry procedure to any stale-lease claimed item before
resuming it. Requires human approval to modify plugins/pmcro/scripts/
(currently locked)."

Also carried forward, unresolved, not created by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- the small pre-existing diff in project/.pmcro/ noted above (new,
  low-priority, human decision: revert or intentional)

trail_sealed: true
