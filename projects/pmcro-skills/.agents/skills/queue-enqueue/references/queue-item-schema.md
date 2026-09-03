# Queue item schema (this repo's own queue)

A fully-scoped work item written to this repo's own `.pmcro/queue.jsonl`
by `Add-PmcroQueueItem` (`../../../engine/enqueue.ps1`).

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| `id` | yes | `task-<slug>`. Must be unique across this repo's queue — `Add-PmcroQueueItem` refuses a duplicate rather than overwriting. |
| `priority` | yes | `0`-`4`, see Priority legend below. Enforced (`[ValidateRange(0,4)]`) — out of range throws rather than being silently written. |
| `domain` | no | `$null` if the item isn't domain-scoped. |
| `status` | yes | Always `open` on creation, set automatically — not a caller-supplied parameter. Later transitions (`claimed`, `done`) belong to `queue-claim`/`reflect-and-seed`. |
| `seed_intent` | yes | Clear statement of what the next cycle should accomplish. |
| `blocked_by` | yes | Array of item ids this item is blocked on. Empty array if none. |
| `created_by` | yes | `reflector` \| `human`. |
| `created_at` | yes | ISO-8601 UTC, set automatically. |

## Priority legend

| Priority | Meaning |
|----------|---------|
| 0 | Safety / stop-the-line |
| 1 | Directed (human/CoS-equivalent) |
| 2 | Domain critical path |
| 3 | Normal |
| 4 | Backlog / opportunistic |
