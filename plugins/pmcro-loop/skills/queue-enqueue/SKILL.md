---
name: queue-enqueue
description: Append one fully-scoped work item to the single colony priority queue. Used by Reflector (follow-ups), Chief-of-Staff / CEO (directed work), or humans handing off an already-scoped task. For a raw, not-yet-classified message use intake-message.ps1 instead.
---

# Queue Enqueue

## Target
`.pmcro/queue.jsonl` — one line per JSON object, append-only. Never
rewrite the whole file by hand to add an item; `Add-PmcroQueueItem`
already does an atomic read-modify-write and checks for a duplicate id
first.

## Rules
- One colony queue only. Tag `domain` so the right C-suite skill can scope the cycle.
- Reflector may enqueue the natural next step after a successful cycle.
- Do not open a private inbox that replaces this backlog.
- Never invent a `status` other than `open` on creation — later
  transitions (`claimed`, `done`, `blocked`) belong to `queue-claim` and
  `reflect-and-seed`, not to enqueue.

## Implementation
Appending an item is implemented deterministically (no model call) in
`../../engine/PmcroEngine.psm1` (`Add-PmcroQueueItem`), invoked via
`../../scripts/enqueue.ps1 -PmcroRoot <path to .pmcro> -Id <task-slug>
-SeedIntent <text> [-Priority <0-4>] [-Domain <name>] [-CreatedBy
<human|reflector|ceo|cos>] [-BlockedBy <id[]>]`. The script refuses a
duplicate id and an out-of-range priority rather than writing either
silently. An agent may run the script directly instead of
hand-constructing JSONL; the script and this document must stay in
sync. See `../queue-claim/SKILL.md`'s own Implementation section for the
matching claim-side mechanic, and `references/queue-item-schema.md` for
the full field reference and priority legend.
