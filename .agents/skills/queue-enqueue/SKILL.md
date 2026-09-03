---
name: queue-enqueue
description: Append one fully-scoped work item to this repo's own colony priority queue. Used by Reflector (follow-ups) or humans handing off an already-scoped task. Invoke as /pmcro-skills:queue-enqueue.
---

# Queue Enqueue

## Invocation

```text
/pmcro-skills:queue-enqueue
```

## Target
`.pmcro/queue.jsonl` — this repo's own queue only, one line per JSON
object, append-only. Never rewrite the whole file by hand to add an
item; `Add-PmcroQueueItem` already does an atomic read-modify-write and
checks for a duplicate id first.

## Rules
- One queue for this repo only.
- Reflector may enqueue the natural next step after a successful cycle.
- Do not open a private inbox that replaces this backlog.
- Never enqueue into another repo's queue.
- Never invent a `status` other than `open` on creation.

## Implementation
Appending an item is implemented deterministically (no model call) in
`../../../engine/PmcroEngine.psm1` (`Add-PmcroQueueItem`), invoked via
`../../../engine/enqueue.ps1 -PmcroRoot <path to .pmcro> -Id <task-slug>
-SeedIntent <text> [-Priority <0-4>] [-Domain <name>] [-CreatedBy
<human|reflector>] [-BlockedBy <id[]>]`. The script refuses a duplicate
id and an out-of-range priority rather than writing either silently. See
`../queue-claim/SKILL.md`'s own Implementation section for the matching
claim-side mechanic, and `references/queue-item-schema.md` for the full
field reference and priority legend.
