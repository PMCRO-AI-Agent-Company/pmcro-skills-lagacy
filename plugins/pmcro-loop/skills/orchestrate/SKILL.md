---
name: orchestrate
description: Run one full PMCR-O cycle. Claims from the colony priority queue when session is idle, then plan → make → check → reflect. Use whenever the project should advance autonomously or a human hands off an intent.
---

# Orchestrate (PMCR-O)

## Preconditions
- `.pmcro/` exists (copy from `template/.pmcro/` if missing).
- Colony queue lives at `.pmcro/queue.jsonl` (single backlog for the whole colony).

## Algorithm
-1. **Intake scan** — before the recovery scan, check for a queue item with
    `status: intake` (a message durably captured by `/send-message` but
    never classified — `pmcro:foundation` -> `seed-intent-contract.md`).
    If found, do not proceed to recovery/claim/plan/make/check/reflect for
    other work; resolve every unresolved intake item first
    (`enqueued` | `informational` | `split`, via `Resolve-PmcroIntake`).
0. **Recovery scan** — check for a claimed queue item
   with a stale lease (`queue-claim`'s Recovery scan / `run-recovery-lease.md`).
   If found, do not proceed to claim/plan/make/check/reflect for new work;
   apply Recovery to the stale Run first.
1. **Read session-state** (`.pmcro/session-state.md`).
2. **If idle / no seed** → run `queue-claim`. If queue empty, stop and report idle.
3. **Plan** → load `plan-frame` with current seed + domain + earned constraints.
4. **Make** → load `make-frame` (or spawn Maker subagent) with PlanFrame.
5. **Check** → load `check-frame` with PlanFrame + Maker artifacts.
6. **Reflect** → load `reflect-and-seed`. Reflector closes the queue item and may enqueue follow-ups.
7. Write trail id into session-state. If Reflector left a new seed, the next cycle can start immediately or on heartbeat.

## Hard rules
- Orchestrator is the **only** role that dispatches.
- C-suite plugins supply **domain scope** (Owns / Does-not-own), never their own loop.
- Priority scale: 0 stop-the-line → 1 CEO/CoS → 2 domain critical → 3 normal → 4 backlog.
- Never invent priority; only CEO/CoS or Reflector policy may reorder.

## Outputs
- Updated `.pmcro/session-state.md`
- New trail under `.pmcro/trails/`
- Possibly updated `.pmcro/queue.jsonl` and `.pmcro/constraints/`

## Implementation
Steps -1-2 (intake scan, recovery scan, read state, claim if idle) and
trail allocation are deterministic and implemented in
`../../engine/PmcroEngine.psm1`, runnable via
`../../engine/run-cycle.ps1 -PmcroRoot <path to .pmcro>`. This script
performs no reasoning: it first checks for an unresolved `status: intake`
item (`Find-PmcroUnresolvedIntake`) and refuses to claim new work if one
exists, surfacing the raw message for classification; then checks for a
stale-lease claimed item (`Find-PmcroRecoverableRuns`) and refuses to claim
new work if one exists, surfacing checkpoint + git-status evidence instead
of guessing; otherwise it claims a task (writing `lease_owner`/
`heartbeat_at`/`lease_expires_at`/`checkpoint_ref` per
`run-recovery-lease.md`) and writes a trail skeleton with PlanFrame/
MakeFrame/CheckFrame/Reflection sections marked `PENDING`, then stops.
`../../scripts/intake-message.ps1` and `../../scripts/resolve-intake.ps1`
back `/send-message`'s durable capture and classification (see
`.agents/commands/send-message.md`); `../../scripts/heartbeat.ps1` and
`../../scripts/checkpoint.ps1` let an active role refresh the lease /
record a checkpoint mid-cycle; `../../scripts/complete-run.ps1` closes the
Run at terminal disposition (see `reflect-and-seed/SKILL.md`). Steps 3-6
(the actual Plan/Make/Check/Reflect content, intake classification, and
any resume/compensate/retry classification after a recovery scan) require
a model and are not automated by this script -- an agent must fill in the
PENDING sections and seal the trail (`trail_sealed: true`).
