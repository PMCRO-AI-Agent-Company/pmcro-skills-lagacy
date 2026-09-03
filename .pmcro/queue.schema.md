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
| status | yes | `intake` | `open` | `claimed` | `done` | `blocked` |
| seed_intent | yes | What the next cycle should accomplish. While `status: intake`, this holds the raw unclassified message instead. |
| blocked_by | no | Array of task ids |
| created_by | yes | `reflector` | `ceo` | `cos` | `human` | `agent` | `external` | `system` |
| created_at | yes | ISO-8601 |
| claimed_at | no | Set on claim |
| claimed_by | no | Usually `orchestrator` |
| lease_owner | no | Set on claim when a live Run is attached; `<role>@<runtime-instance-id>` |
| lease_expires_at | no | Short TTL from last heartbeat; see `pmcro:foundation` -> `run-recovery-lease.md` |
| heartbeat_at | no | Refreshed while the Run is actively worked |
| checkpoint_ref | no | Path to the Run's checkpoint file, e.g. `.pmcro/checkpoints/task-<slug>.md` |
| messy_seed | no | `true` while `status: intake` — marks `seed_intent` as the unclassified raw message, not yet a canonical Seed Intent |
| messy_seed_text | no | Set on resolution (`Resolve-PmcroIntake`); the original raw message, preserved verbatim for provenance regardless of disposition |
| resolution_note | no | Set on resolution for `informational` / `split` dispositions; why no further work follows directly from this item |
| derived_from_intake | no | On an item created by a `split` resolution: the `id` of the intake item it was derived from |

A claimed item with a past `lease_expires_at` (or no heartbeat) is a recoverable Run: apply Recovery before touching it, do not reclaim/retry blindly.

An item with `status: intake` is a message durably captured by `/send-message` but not yet classified by Orchestrator (see `pmcro:foundation` -> `seed-intent-contract.md`). Resolve it (`enqueued` | `informational` | `split`, via `Resolve-PmcroIntake`) before claiming other work — never leave it to be silently skipped.

## Example line

```json
{"id":"task-bootstrap-pmcro","priority":2,"domain":null,"status":"open","seed_intent":"Verify .pmcro/ layout and run one dry-run cycle","blocked_by":[],"created_by":"human","created_at":"2026-09-02T14:00:00Z"}
```

## Example intake line (unresolved)

```json
{"id":"task-intake-20260903-140000000","priority":2,"domain":null,"status":"intake","seed_intent":"can someone look at why the nightly job keeps failing","messy_seed":true,"blocked_by":[],"created_by":"human","created_at":"2026-09-03T14:00:00Z"}
```
