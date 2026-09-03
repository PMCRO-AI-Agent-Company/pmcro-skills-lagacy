# Trail: cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine

trail_id: cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine
task_id: task-wire-run-lease-into-pmcro-loop-engine
domain: pmcro-governance
priority: 2
opened: 2026-09-03
run_id: task-wire-run-lease-into-pmcro-loop-engine
checkpoint_ref: (none — this cycle completed in one uninterrupted session; no
recovery was needed and none was simulated against the live queue)

## Seed intent (human-approved, verbatim requirement set)
/pmcro wire Run, checkpoint, lease, heartbeat, and recovery semantics into
the pmcro-loop engine. Use the run-recovery-lease.md foundation contract
as the authoritative semantic source. Required behavior:
1. A claimed queue task establishes/references one durable Run identity.
2. Run state recoverable independently of the chat/UI session.
3. Execution creates/updates a durable checkpoint at appropriate boundaries.
4. Active Run ownership uses a deterministic lease/heartbeat mechanism.
5. A runtime reconnect can discover interrupted or expired Runs.
6. Recovery inspects actual repository/system state before deciding
   resume/compensate/retry.
7. The runtime never blindly repeats an operation merely because the prior
   process/UI disappeared.
8. Existing approval requirements remain authoritative across interruption
   and recovery; missing/expired approval is never inferred.
9. Trail/Frame records capture Run identity, checkpoint transitions,
   interruption/recovery decisions, evidence, and final disposition.
10. Reflector ownership of the next Seed Intent remains unchanged.
11. Preserve existing queue compatibility; additive schema/runtime evolution.
12. No coupling of Run state to a particular frontend, chat provider, or LLM.
13. Test an interruption scenario where an operation may have completed
    before the UI/process disappeared.
14. Verify stale lease recovery and prevention of simultaneous ownership.
15. Verify ordinary successful executions still converge normally.
16. Do not touch unrelated pre-existing .csproj/.pmcro-tmp/project/.pmcro
    changes.
17. No unrelated cleanup.

## OrchestratorFrame
Claimed task-wire-run-lease-into-pmcro-loop-engine (priority 2, the only
non-human-decision open item). Confirmed via live queue.jsonl read that
this item was reflector-created from the prior cycle
(cycle-20260903-051500-task-evolve-pmcro-runtime-continuity) and not yet
touched. Inspected actual repository state before planning (colony-laws
"inspect before acting", applied to the colony's own queue): a claimed
"Done" summary from an earlier, separately-interrupted human session
described 4 new queue items; only 1
(task-seed-intent-queue-ingress) had actually persisted to
queue.jsonl. Treated the other 3 as lost, not completed, and reconstructed
them for re-enqueue this cycle rather than assuming the earlier claim was
accurate. Located the actual engine implementation: the queue item's own
text names "plugins/pmcro/scripts/" as locked, but that directory is
empty — the real deterministic engine lives at
plugins/pmcro-loop/engine/{PmcroEngine.psm1,run-cycle.ps1,resolve-pmcro-root.ps1}
and plugins/pmcro-loop/scripts/{approve-operation.ps1,validate-skill.ps1}.
The human's own approval message names "the pmcro-loop engine" explicitly,
which matches the real path, not the stale "plugins/pmcro/scripts/" label
in the queue item text — proceeded against the real path.

Also noted, out of scope for this cycle per explicit human instruction:
task-csproj-version-pin-disposition, task-pmcro-tmp-disposition,
task-project-pmcro-stale-diff-disposition (3 open human-decision items,
left untouched) and a stale P:\source\pmcro-skills\.git\index.lock found
during repo-state inspection (unrelated to this task, not queued, flagged
to the human directly).

## PlanFrame (Planner)
Read PmcroEngine.psm1, run-cycle.ps1, resolve-pmcro-root.ps1,
scripts/approve-operation.ps1, run-recovery-lease.md, session-bootstrap.md,
trail-frame-schema.md, queue.schema.md, approvals.schema.md, and the
queue-claim/orchestrate/plan-frame/make-frame/check-frame/queue-enqueue/
reflect-and-seed SKILL.md files. Decided the smallest coherent change:

- Extend PmcroEngine.psm1 (additive functions only, no signature changes
  to existing exports except Claim-PmcroTask gaining an optional
  -LeaseTtlMinutes parameter with a default): Get-PmcroRuntimeInstanceId,
  Update-PmcroLease, Test-PmcroLeaseStale, Find-PmcroRecoverableRuns,
  Get/Set/Remove-PmcroCheckpoint, Complete-PmcroRun. Claim-PmcroTask now
  also establishes the initial lease + checkpoint (Run = the claimed queue
  item itself, per run-recovery-lease.md -- no new store).
- Extend run-cycle.ps1 with a Step 0 recovery scan: refuse to claim new
  work while any claimed item has a stale lease; surface checkpoint +
  best-effort git-status evidence; STOP without classifying
  resume/compensate/retry (that stays a model/human decision, consistent
  with how the script already defers Plan/Make/Check/Reflect content).
- Add 3 new deterministic scripts mirroring approve-operation.ps1's
  pattern: heartbeat.ps1, checkpoint.ps1, complete-run.ps1, so a role can
  refresh a lease / record a checkpoint / close a Run without needing
  Claim-PmcroTask or hand-editing queue.jsonl.
- Cross-reference the new mechanics from queue-claim, orchestrate,
  make-frame, reflect-and-seed SKILL.md and from run-recovery-lease.md's
  new "Implementation" section, so both the engine path and the
  hand-executed-by-an-LLM path (which is how every real trail in this
  repo so far was actually produced) point at the same contract.
- Explicitly scoped out: touching approve-operation.ps1/validate-skill.ps1
  logic, the 3 human-decision queue items, and any unrelated repo cleanup.

TYPE1 approval: the human's message explicitly approved "the engine-wiring
task" and supplied this exact 17-point requirement set as "the next queued
Seed Intent" for "plugins/pmcro-loop engine" -- source=human, scope=
plugins/pmcro-loop/engine/, plugins/pmcro-loop/scripts/,
plugins/pmcro-loop/skills/*/SKILL.md,
plugins/pmcro/skills/foundation/references/run-recovery-lease.md. No
destructive operation was in scope (all changes additive).

## MakeFrame (Maker)
Before touching any live file, built and ran the changed engine in an
isolated fixture: downloaded PowerShell 7.4.6, created a scratch git repo
with a 2-item queue, and iterated PmcroEngine.psm1/run-cycle.ps1/the 3 new
scripts there until all Checker scenarios below passed. Only then applied
the identical, verified content to the live repo.

Live changes (all additive/backward-compatible):
- plugins/pmcro-loop/engine/PmcroEngine.psm1 -- added
  Get-PmcroRuntimeInstanceId, Update-PmcroLease, Test-PmcroLeaseStale,
  Find-PmcroRecoverableRuns, Get/Set/Remove-PmcroCheckpoint,
  Complete-PmcroRun, plus a shared key:value parser refactor (
  ConvertFrom/To-PmcroKeyValueText) used by both session-state.md and the
  new checkpoint files; Claim-PmcroTask now writes lease+checkpoint on
  claim.
- plugins/pmcro-loop/engine/run-cycle.ps1 -- added the Step 0 recovery
  scan described in PlanFrame; existing idle/claim/trail-skeleton
  behavior unchanged when no recoverable Run exists.
- plugins/pmcro-loop/scripts/heartbeat.ps1, checkpoint.ps1,
  complete-run.ps1 -- new, mirror approve-operation.ps1's thin-wrapper
  pattern.
- plugins/pmcro-loop/skills/queue-claim/SKILL.md -- added "Recovery scan"
  section and lease/checkpoint fields to the claim protocol.
- plugins/pmcro-loop/skills/orchestrate/SKILL.md -- added Algorithm step 0
  and updated the Implementation section.
- plugins/pmcro-loop/skills/make-frame/SKILL.md -- added "Checkpointing
  long-running work" section.
- plugins/pmcro-loop/skills/reflect-and-seed/SKILL.md -- action 3 now
  closes the Run (clear lease/checkpoint fields, delete checkpoint file)
  alongside setting the terminal queue status.
- plugins/pmcro/skills/foundation/references/run-recovery-lease.md --
  added an "Implementation" section cross-referencing the above.

Not touched: approve-operation.ps1, validate-skill.ps1, resolve-pmcro-root.ps1
(read only), plan-frame/check-frame/queue-enqueue SKILL.md, any .csproj,
.pmcro-tmp/, project/.pmcro/, or the stale .git/index.lock.

## CheckFrame (Checker)
verdict: pass
Independently exercised the fixture built during MakeFrame (not the
Maker's narrative) end to end:
- **Normal execution**: run-cycle.ps1 claimed task-alpha, wrote
  lease_owner/heartbeat_at/lease_expires_at/checkpoint_ref, wrote a
  checkpoint file and a trail skeleton; a second invocation correctly
  refused to also claim task-beta (status=active).
- **Interrupted execution / operation completed before UI disappeared**:
  simulated a checkpoint claiming "dotnet build (interrupted)" while
  backdating the lease, then independently produced external evidence
  (a committed marker file) that the build had, in fact, completed. A
  fresh run-cycle.ps1 invocation (simulated reconnect) surfaced both the
  checkpoint's claim and the contradicting git-status evidence (0 changed
  paths) side by side, without itself concluding anything -- exactly the
  inspect-before-retry invariant.
- **Reconnect/recovery discovery**: the same fresh invocation correctly
  found the stale-lease Run and refused to claim task-beta, leaving
  queue.jsonl and session-state.md untouched.
- **Lease expiration**: Test-PmcroLeaseStale/Find-PmcroRecoverableRuns
  correctly flagged the backdated lease and correctly stopped flagging it
  once refreshed.
- **Prevention of simultaneous ownership**: Update-PmcroLease threw when a
  second, different LeaseOwner tried to refresh an unexpired lease held by
  another owner, and left the queue record unchanged; the same call
  succeeded once the lease was allowed to go stale (the actual Recovery
  reclaim path).
- **Approval preservation**: Test-PmcroApproval returned false both before
  and immediately after the simulated reconnect/lease-reclaim -- the
  interruption/recovery sequence never caused an approval to be inferred;
  Save-PmcroApproval independently still refused an `approved` +
  `Destructive` record with no TrailId.
- **Trail continuity**: New-PmcroTrail's skeleton persisted unchanged
  through the interruption; the Reflector-equivalent close added a
  recovery narrative into the existing (not a new) trail file, then
  Complete-PmcroRun cleared lease/checkpoint while leaving the trail file
  itself intact and sealed.
- **Ordinary convergence after completion**: after Complete-PmcroRun and
  resetting session-state to idle, run-cycle.ps1 cleanly claimed
  task-beta with a fresh lease/checkpoint -- no residue from task-alpha's
  cycle blocked it.

Also verified directly against the live repo (not the fixture), with a
correction along the way: a first `git status --porcelain` run from the
Linux bridge device shell showed nearly every file in the repo as
modified. Inspected one clearly-untouched file's diff and confirmed this
was 100% a CRLF/LF false positive from running git in that Linux
environment against this Windows-native, CRLF-committed repo -- not a
real change (the earlier cycle's Checker likely ran its git verification
from an actual Windows shell, which would not show this). Re-ran with
`git diff --ignore-all-space --stat`, which resolves to exactly the
expected file set: this cycle's own changes (PmcroEngine.psm1,
run-cycle.ps1, the 4 SKILL.md edits, queue.jsonl, session-state.md, plus
the untracked new scripts/*.ps1) and legitimate uncommitted output from
the *prior* cycle (run-recovery-lease.md, foundation/SKILL.md,
session-bootstrap.md, trail-frame-schema.md, queue.schema.md) and older
still-uncommitted work (marketplace.json files, AGENTS.md). The 3
flagged .csproj diffs and .pmcro-tmp/ are present and unchanged by either
cycle, confirming task-csproj-version-pin-disposition/
task-pmcro-tmp-disposition remain exactly as the human left them for
decision. project/.pmcro/ (the stale duplicate tree) shows only its
already-flagged pre-existing 2-line diff, also untouched by this cycle.

blockers: none
findings: PmcroEngine.psm1's original Claim-PmcroTask pattern (`$open =
@($queue | Where-Object {...})`) already avoided PowerShell's
empty-array-return pitfall by wrapping at the call site; the new
Find-PmcroRecoverableRuns needed the same @() wrapping at every call site
(documented in a .NOTES block) -- without it, run-cycle.ps1 threw on `.Count`
against $null. Caught and fixed during fixture testing, before this ever
reached the live files. Second finding: `git status`/`git diff` run
against this repo from a Linux environment (this session's device-bridge
shell) produces a whole-repo false-positive diff from CRLF/LF handling;
`--ignore-all-space` (or running git from an actual Windows shell)
is required for a trustworthy scope check here. Worth a human decision on
whether to normalize with `.gitattributes` (`* text=auto`) at some point,
but that is a repo-hygiene change outside this cycle's scope -- not
queued as a task, just flagged.

## Reflection (Reflector)
Outcome: complete. Durable Run continuity is now operational, not just
documentary -- claiming, checkpointing, leasing/heartbeating, detecting an
interrupted Run on reconnect, and closing a Run are all implemented in
plugins/pmcro-loop/engine + scripts, exercised against 7 required
scenarios in an isolated fixture, and cross-referenced from every SKILL.md
that touches the queue or a live cycle.

Lesson: the two most important properties weren't the obvious ones
(writing timestamps) -- they were (a) the engine must gather evidence and
stop, never itself decide resume/compensate/retry, matching the same
"defers to a model" boundary the engine already drew for Plan/Make/Check/
Reflect; and (b) simultaneous-ownership prevention needed an explicit
"refuse to transfer an unexpired lease" check in Update-PmcroLease --
without it, "deterministic lease/heartbeat" would have been bookkeeping
with no actual mutual-exclusion guarantee.

Non-engine finding, not part of this task's scope: while reading
foundation/ references for context, found that
plugins/pmcro/skills/foundation/references/o-mode.md already formalizes
"Trail is pervasive, PMCR-O is selective" as O-Mode / Dynamic Resonance
(direct | PMCR-O | optimize | options | chain | tree | graph | ReAct
strategy selection, chosen by the Orchestrator from evidence). This
closely matches a human architecture discussion raised alongside this
cycle's approval. Not re-authored or duplicated here since it already
exists and already says essentially the same thing; flagged for the
human's direct awareness rather than queued as work.

Also not part of this task's scope, flagged directly rather than queued:
a stale P:\source\pmcro-skills\.git\index.lock was observed during repo
inspection. Left untouched (no destructive git operation without
approval); a human should check whether a git operation is genuinely
still running before removing it.

Queue repair performed this cycle (see OrchestratorFrame): re-added 3
architectural Seed Intents lost to a prior session's interruption
(task-retrospective-trail-ingestion, task-trail-as-product-evolution,
task-capability-gap-composition-learning), explicitly marked as
reconstructed rather than freshly human-specified.

next_seed_intent: "task-seed-intent-queue-ingress is now unblocked
(task-wire-run-lease-into-pmcro-loop-engine is done) and is priority 2,
the highest eligible open item -- claim and run it next: make the message
queue the durable handoff boundary for actionable canonical Seed Intents
per its existing seed_intent text, now that Run/Checkpoint/Recovery/Lease
semantics are actually operational underneath it."

Carried forward, unresolved, not created or touched by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- task-project-pmcro-stale-diff-disposition (open, human decision)
- task-retrospective-trail-ingestion (open, backlog, priority 3)
- task-trail-as-product-evolution (open, backlog, priority 3)
- task-capability-gap-composition-learning (open, backlog, priority 3)
- stale .git/index.lock at repo root (not queued; human attention)

trail_sealed: true
