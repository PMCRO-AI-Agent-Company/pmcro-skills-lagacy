# Colony Queue Schema

Single shared backlog for the entire colony. **Do not** create per-C-suite queues.

## Priority scale

| Priority | Meaning |
|----------|---------|
| 0 | Safety / stop-the-line (Checker hard fail, security) |
| 1 | CEO / Chief-of-Staff directed |
| 2 | Domain critical path |
| 3 | Normal |
| 4 | Backlog / opportunistic |

## Item fields

| Field | Required | Notes |
|-------|----------|-------|
| id | yes | Unique, e.g. `task-<slug>` |
| priority | yes | 0–4 |
| domain | no | `cto`, `cfo`, `ceo`, … — scopes C-suite skill |
| status | yes | `open` | `claimed` | `done` | `blocked` |
| seed_intent | yes | What the next cycle should accomplish |
| blocked_by | no | Array of task ids |
| created_by | yes | `reflector` | `ceo` | `cos` | `human` |
| created_at | yes | ISO-8601 |
| claimed_at | no | Set on claim |
| claimed_by | no | Usually `orchestrator` |

## Example line

```json
{"id":"task-bootstrap-pmcro","priority":2,"domain":null,"status":"open","seed_intent":"Verify .pmcro/ layout and run one dry-run cycle","blocked_by":[],"created_by":"human","created_at":"2026-09-02T14:00:00Z"}
```
