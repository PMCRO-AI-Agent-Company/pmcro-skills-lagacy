# Queue item schema

A fully-scoped work item written to `.pmcro/queue.jsonl` by
`Add-PmcroQueueItem` (`scripts/enqueue.ps1`). Distinct from an intake
item (`Add-PmcroIntake`, `status: intake`) — see `orchestrate/SKILL.md`'s
Intake scan step and `pmcro:foundation -> seed-intent-contract.md`: an
intake item is a raw, unclassified message; a queue item already has a
clear `seed_intent` a cycle can act on.

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| `id` | yes | `task-<slug>`. Must be unique across the queue — `Add-PmcroQueueItem` refuses a duplicate rather than overwriting. |
| `priority` | yes | `0`-`4`, see Priority legend below. Enforced by `Add-PmcroQueueItem` (`[ValidateRange(0,4)]`) — an out-of-range value throws rather than being silently written. |
| `domain` | no | e.g. `cto`, `pmcro-governance`. `$null` if the item isn't domain-scoped. |
| `status` | yes | Always `open` on creation. `Add-PmcroQueueItem` sets this; it is not a caller-supplied parameter — later transitions (`claimed`, `done`, `blocked`) are `queue-claim`'s and `reflect-and-seed`'s job, not enqueue's. |
| `seed_intent` | yes | Clear statement of what the next cycle should accomplish. |
| `blocked_by` | yes | Array of item ids this item is blocked on. Empty array if none. |
| `created_by` | yes | `human` \| `reflector` \| `ceo` \| `cos`. |
| `created_at` | yes | ISO-8601 UTC, set automatically by `Add-PmcroQueueItem` — not a caller-supplied parameter. |

## Priority legend

| Priority | Meaning |
|----------|---------|
| 0 | Safety / stop-the-line |
| 1 | CEO / CoS directed |
| 2 | Domain critical path |
| 3 | Normal |
| 4 | Backlog / opportunistic |

## Example

```json
{
  "id": "task-git-lifecycle-plugin",
  "priority": 3,
  "domain": "pmcro-governance",
  "status": "open",
  "seed_intent": "Wrap git commit/push in a documented, tested script.",
  "blocked_by": [],
  "created_by": "human",
  "created_at": "2026-09-03T18:06:24Z"
}
```
