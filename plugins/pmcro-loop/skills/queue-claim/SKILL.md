---
name: queue-claim
description: Claim the highest-priority eligible open item from the single colony queue (.pmcro/queue.jsonl) and install it as the current seed in session-state. Use when Orchestrator is idle.
---

# Queue Claim

## Source of truth
`.pmcro/queue.jsonl` — one line per JSON object.

## Eligibility
- `status` == `"open"`
- Not blocked (`blocked_by` empty or all resolved)
- Optional domain filter if Orchestrator is running under a domain seat

## Selection
Sort by `priority` ascending (0 highest), then by `created_at` ascending. Take the first eligible item.

## Recovery scan (before claiming)
Before selecting a new item, scan claimed items for a stale lease
(`lease_expires_at` passed, or a claimed item with no `heartbeat_at` at
all) per `pmcro:foundation -> run-recovery-lease.md`. If any exist, do
**not** claim new work: apply Recovery (inspect actual state, classify
resume|compensate|retry) to the stale Run first. This is the same rule
`../../engine/run-cycle.ps1` enforces deterministically before it will
claim.

## Claim protocol
1. Read queue.jsonl.
2. Select item.
3. Set item `status` = `"claimed"`, record `claimed_at`, `claimed_by` = `"orchestrator"`.
4. Establish the Run (see `run-recovery-lease.md`): set `lease_owner`
   (`orchestrator@<runtime-instance-id>`), `heartbeat_at` (now),
   `lease_expires_at` (now + TTL, default 30m), and `checkpoint_ref`
   (`.pmcro/checkpoints/<item.id>.md`); write an initial checkpoint there
   (`phase: orchestrator`, `last_completed_step: claimed`).
5. Rewrite queue.jsonl (atomic preferred).
6. Write seed into `.pmcro/session-state.md`:
   - `status: active`
   - `seed_intent: <item.seed_intent>`
   - `task_id: <item.id>`
   - `domain: <item.domain or null>`
   - `priority: <item.priority>`

## Empty queue
Leave session-state `status: idle` and report "colony queue empty".

## Do not
- Create a second queue per C-suite seat.
- Change priority on claim.

## Implementation
The claim protocol above is implemented deterministically (no model call)
in `../../engine/PmcroEngine.psm1` (`Claim-PmcroTask`), invoked via
`../../engine/run-cycle.ps1 -PmcroRoot <path to .pmcro>`. An agent may
run the script directly instead of hand-executing this protocol; the
script and this document must stay in sync.
