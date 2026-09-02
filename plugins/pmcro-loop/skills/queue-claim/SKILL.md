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

## Claim protocol
1. Read queue.jsonl.
2. Select item.
3. Set item `status` = `"claimed"`, record `claimed_at`, `claimed_by` = `"orchestrator"`.
4. Rewrite queue.jsonl (atomic preferred).
5. Write seed into `.pmcro/session-state.md`:
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
