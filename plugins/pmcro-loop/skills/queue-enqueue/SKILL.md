---
name: queue-enqueue
description: Append one or more work items to the single colony priority queue. Used by Reflector (follow-ups), Chief-of-Staff / CEO (directed work), or humans.
---

# Queue Enqueue

## Target
`.pmcro/queue.jsonl` (append-only preferred; rewrite if you must update status of existing ids).

## Item schema (minimal)
```json
{
  "id": "task-<uuid-or-slug>",
  "priority": 3,
  "domain": "cto",
  "status": "open",
  "seed_intent": "Clear statement of what the next cycle should accomplish",
  "blocked_by": [],
  "created_by": "reflector|ceo|human|cos",
  "created_at": "2026-09-02T14:00:00Z"
}
```

## Priority legend
| Priority | Meaning |
|----------|---------|
| 0 | Safety / stop-the-line |
| 1 | CEO / CoS directed |
| 2 | Domain critical path |
| 3 | Normal |
| 4 | Backlog / opportunistic |

## Rules
- One colony queue only. Tag `domain` so the right C-suite skill can scope the cycle.
- Reflector may enqueue the natural next step after a successful cycle.
- Do not open a private inbox that replaces this backlog.
