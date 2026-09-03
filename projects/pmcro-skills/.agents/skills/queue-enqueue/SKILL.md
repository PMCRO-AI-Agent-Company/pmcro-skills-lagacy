---
name: queue-enqueue
description: Append one or more work items to this repo's own colony priority queue. Used by Reflector (follow-ups) or humans. Invoke as /pmcro-skills:queue-enqueue.
---

# Queue Enqueue

## Invocation

```text
/pmcro-skills:queue-enqueue
```

## Target
`.pmcro/queue.jsonl` (this repo's own — append-only preferred; rewrite if you must update status of existing ids).

## Item schema (minimal)
```json
{
  "id": "task-<uuid-or-slug>",
  "priority": 3,
  "domain": null,
  "status": "open",
  "seed_intent": "Clear statement of what the next cycle should accomplish",
  "blocked_by": [],
  "created_by": "reflector|human",
  "created_at": "2026-09-02T14:00:00Z"
}
```

## Priority legend
| Priority | Meaning |
|----------|---------|
| 0 | Safety / stop-the-line |
| 1 | Directed (human/CoS-equivalent) |
| 2 | Domain critical path |
| 3 | Normal |
| 4 | Backlog / opportunistic |

## Rules
- One queue for this repo only.
- Reflector may enqueue the natural next step after a successful cycle.
- Do not open a private inbox that replaces this backlog.
- Never enqueue into another repo's queue.
