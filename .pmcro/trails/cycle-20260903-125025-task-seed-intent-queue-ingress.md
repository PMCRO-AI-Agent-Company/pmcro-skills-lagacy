# Trail: cycle-20260903-125025-task-seed-intent-queue-ingress

trail_id: cycle-20260903-125025-task-seed-intent-queue-ingress
task_id: task-seed-intent-queue-ingress
domain: pmcro-governance
priority: 2
opened: 2026-09-03
run_id: task-seed-intent-queue-ingress
checkpoint_ref: (none — this cycle completed in one uninterrupted session;
no recovery was needed and none was simulated against the live queue)

## Seed intent
/pmcro:intent-refinement make the message queue the durable handoff
boundary for actionable canonical Seed Intents, so generated work
survives chat/UI interruption and can be resumed through Run/Checkpoint/
Recovery semantics. (Reflector-produced next_seed_intent from trail
cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine, now
unblocked since that task is done.) Human authorization for continuing to
this next queued Seed Intent: literal instruction "continue" following
approval of the engine-wiring cycle.

## OrchestratorFrame
Claimed task-seed-intent-queue-ingress (priority 2, the highest eligible
open item, unblocked). Read the item's own seed_intent text plus
`seed-intent-contract.md`, `intent-lifecycle.md`,
`intent-refinement/SKILL.md`, and `.agents/commands/seed-intent.md` before
planning, to establish the actual boundary between two ingress
mechanisms that share overlapping vocabulary:
- `/send-message` — file-based ingress into the colony's single shared
  queue (`.pmcro/queue.jsonl`), owned by this repo's PMCR-O engine.
- `/seed-intent` — a separate, already-durable typed governance API/MCP
  path (`AgentSkills.Workflows.*` Domain/Application/Infrastructure/Mcp
  bounded context), explicitly out of scope: `seed-intent.md` itself
  forbids hand-editing `queue.jsonl`/`session-state.md`/trails from that
  path, and colony-laws' "one shared queue" rule means the fix belongs on
  the `/send-message` side, not by merging the two paths.

Confirmed the actual gap this closes: this session's own investigation
(recorded in the prior cycle's trail) found that a previous interrupted
session claimed to have enqueued 4 new queue items via chat and only 1
had actually persisted before the session was lost — messages were being
held in reasoning/chat state, not written durably, until classification
finished. `run-recovery-lease.md`'s Run/Checkpoint/Lease machinery (just
wired into the engine last cycle) already solves this for a claimed
queue item; nothing equivalent existed for a message that arrives before
it becomes a queue item at all.

Out of scope, left untouched per standing instruction and prior
disposition: task-csproj-version-pin-disposition,
task-pmcro-tmp-disposition, task-project-pmcro-stale-diff-disposition (3
open human-decision items), the stale
`P:\source\pmcro-skills\.git\index.lock`, and the `/seed-intent` typed
API/MCP path itself.

## PlanFrame (Planner)
Decided the smallest coherent change: treat "message received" as its own
durable state, symmetric to "Run claimed" — persist the raw message to
`queue.jsonl` as a new `status: intake` item *before* any classification
reasoning, then let Orchestrator resolve it afterward. No new store: same
pattern as Run using the queue item itself as record, applied one step
earlier in the lifecycle.

- Extend `PmcroEngine.psm1` (additive only): `Add-PmcroIntake` (durably
  persist, no model call), `Find-PmcroUnresolvedIntake` (mirrors
  `Find-PmcroRecoverableRuns` — evidence-gathering only, does not
  classify), `Resolve-PmcroIntake` (rewrites the item in place for exactly
  one of three Orchestrator-decided dispositions: `enqueued` |
  `informational` | `split`; always preserves the original message
  verbatim in `messy_seed_text`).
- Extend `run-cycle.ps1` with a Step -1 scan, ordered *before* the
  existing Step 0 recovery scan: refuse to claim new work while any
  `status: intake` item is unresolved, surface the raw message, STOP
  without classifying it (classification needs a model, same boundary the
  engine already respects for recovery and for Plan/Make/Check/Reflect).
- Add 2 new deterministic scripts mirroring `heartbeat.ps1`'s pattern:
  `intake-message.ps1`, `resolve-intake.ps1`.
- Rewrite `.agents/commands/send-message.md`'s Steps to make durable
  persistence step 1 (unconditional, even for messages that will turn out
  informational), add a "Reconnect" section, and clarify the relationship
  to `/seed-intent`.
- Cross-reference from `seed-intent-contract.md`, `queue.schema.md`
  (document `status: intake` and the new fields), `session-bootstrap.md`
  (new step 3.4, ordered before the existing step 3.5 lease-recovery
  step), and `orchestrate/SKILL.md` (new Algorithm step -1 and updated
  Implementation section).
- Explicitly scoped out: the `/seed-intent` typed API/MCP path, the 3
  human-decision queue items, any unrelated repo cleanup.

TYPE1 approval: additive-only engine/doc changes, no destructive
operation in scope — same approval class as the prior cycle's
engine-wiring work, continued under the human's "continue" instruction
following that cycle's Reflector-produced next_seed_intent. Scope:
`plugins/pmcro-loop/engine/`, `plugins/pmcro-loop/scripts/`,
`plugins/pmcro-loop/skills/orchestrate/SKILL.md`,
`plugins/pmcro/skills/foundation/references/seed-intent-contract.md`,
`plugins/pmcro/skills/foundation/references/session-bootstrap.md`,
`.agents/commands/send-message.md`, `.pmcro/queue.schema.md`.

## MakeFrame (Maker)
Reused the isolated fixture from the prior cycle (own PowerShell 7.4.6,
own scratch git repo) and iterated `Add-PmcroIntake`/
`Find-PmcroUnresolvedIntake`/`Resolve-PmcroIntake`/the Step -1 scan there
until all Checker scenarios below passed, before applying identical
verified content to the live repo.

Live changes (all additive/backward-compatible):
- `plugins/pmcro-loop/engine/PmcroEngine.psm1` — added `Add-PmcroIntake`,
  `Find-PmcroUnresolvedIntake`, `Resolve-PmcroIntake`; updated
  `Export-ModuleMember`.
- `plugins/pmcro-loop/engine/run-cycle.ps1` — added the Step -1 unresolved
  intake scan, ordered before Step 0; updated `.DESCRIPTION`.
- `plugins/pmcro-loop/scripts/intake-message.ps1`,
  `resolve-intake.ps1` — new, mirror `heartbeat.ps1`'s thin-wrapper
  pattern.
- `plugins/pmcro-loop/skills/orchestrate/SKILL.md` — added Algorithm
  step -1 and updated the Implementation section.
- `plugins/pmcro/skills/foundation/references/seed-intent-contract.md` —
  added a "Durable capture at the message boundary" section.
- `plugins/pmcro/skills/foundation/references/session-bootstrap.md` —
  added step 3.4 (intake scan), ordered before the existing step 3.5
  (lease recovery).
- `.agents/commands/send-message.md` — rewrote Steps to lead with durable
  persistence; added "Reconnect" and expanded "Relationship to
  /seed-intent" sections.
- `.pmcro/queue.schema.md` — documented `status: intake` and the new
  `messy_seed`/`messy_seed_text`/`resolution_note`/`derived_from_intake`
  fields, plus an example intake line.

Not touched: `approve-operation.ps1`, `validate-skill.ps1`,
`resolve-pmcro-root.ps1`, `plan-frame`/`check-frame`/`queue-claim`/
`make-frame`/`reflect-and-seed` SKILL.md, `intent-refinement/SKILL.md`,
`.agents/commands/seed-intent.md`, any `.csproj`, `.pmcro-tmp/`,
`project/.pmcro/`, or the stale `.git/index.lock`.

## CheckFrame (Checker)
verdict: pass

Independently exercised the fixture built during MakeFrame end to end:
- **Durable capture before classification**: `Add-PmcroIntake` appended a
  `status: intake` item with the raw message in `seed_intent`,
  `messy_seed: true`, and no model call involved; verified the write
  landed in `queue.jsonl` even when the "session" stopped immediately
  after (no subsequent step required for the write to be durable).
- **Reconnect discovery of unresolved intake**: a fresh `run-cycle.ps1`
  invocation against a queue holding one unresolved intake item correctly
  refused to scan for recoverable Runs or claim other work, surfaced the
  raw message, and exited before Step 0 — confirming intake is checked
  strictly before Run recovery, matching the documented step 3.4-before-
  3.5 ordering.
- **All three resolution dispositions**: `Resolve-PmcroIntake` with
  `enqueued` correctly rewrote `status` to `open` and `seed_intent` to the
  refined text while moving the original into `messy_seed_text`;
  `informational` and `split` both correctly set `status: done` and wrote
  a `resolution_note`, with the original message preserved in
  `messy_seed_text` in every case. Confirmed `messy_seed` (the
  in-progress marker) is removed on resolution and does not leak into a
  resolved item.
- **Guard against resolving twice / resolving the wrong item**:
  `Resolve-PmcroIntake` threw when called against a `TaskId` not present
  in the queue, and threw when called against an item whose `status` was
  not `intake` (e.g., already resolved) — a double-resolve or a
  misdirected call cannot silently corrupt an unrelated item.
- **Ordinary convergence unaffected**: with no unresolved intake and no
  recoverable Run, `run-cycle.ps1` claimed a normal open item exactly as
  before this cycle's change — the new Step -1 scan is a no-op cost when
  the colony has nothing pending at the message boundary.
- **Interaction with Run recovery**: constructed a queue with both one
  unresolved intake item and one separately stale-leased claimed item;
  confirmed `run-cycle.ps1` surfaced only the intake item and stopped —
  correct, since resolving intake may itself be what produces the next
  claim, and conflating the two evidence sets in one STOP would blur the
  "inspect actual state before deciding" boundary each scan keeps
  separate.

Also verified directly against the live repo:
`git diff --ignore-all-space --stat` (the CRLF-safe form established last
cycle, since this environment's Linux bridge shell otherwise reports a
whole-repo false-positive diff against this Windows-native, CRLF-committed
repo) shows exactly this cycle's intended files
(`PmcroEngine.psm1`, `run-cycle.ps1`, `orchestrate/SKILL.md`,
`seed-intent-contract.md`, `session-bootstrap.md`, `send-message.md`,
`queue.schema.md`, plus `queue.jsonl`/`session-state.md` bookkeeping and
the two new untracked `scripts/*.ps1` files) alongside legitimate
uncommitted output already present before this cycle started: the prior
cycle's own changes (`queue-claim`/`make-frame`/`reflect-and-seed`
SKILL.md, `foundation/SKILL.md`, `trail-frame-schema.md`) and older
still-uncommitted work (the 3 `marketplace.json` files, `AGENTS.md`, the 3
flagged `.csproj` version-pin diffs). No file outside this cycle's
intended scope, and none of the 3 human-decision items, was touched.

blockers: none

findings:
1. `Add-PmcroIntake`'s `$queue += [pscustomobject]$item` threw
   `op_Addition` not found when the queue held exactly one existing item.
   Root cause: distinct from (but the same family as) the empty-array
   pitfall documented on `Find-PmcroRecoverableRuns` last cycle —
   `Get-PmcroQueue` unrolls a single-element array return into a bare
   object, which `+=` cannot append to. Fixed by wrapping the read as
   `$queue = @(Get-PmcroQueue -PmcroRoot $PmcroRoot)` at the call site,
   with an explanatory comment distinguishing the two cases so a future
   maintainer does not mistake this for the already-documented pitfall
   and skip wrapping it. Caught and fixed in the fixture before reaching
   any live file.
2. `intake-message.ps1` serialized an omitted `-Domain` as `"domain": ""`
   instead of the schema's expected `null`. Root cause: PowerShell
   coerces an unbound `$null` to empty string when a parameter is
   declared `[string]$Domain` with no default. Fixed by declaring it
   untyped (`$Domain = $null`) in both `Add-PmcroIntake` and
   `intake-message.ps1`, matching how `Get-PmcroQueue`/existing schema
   fields already serialize an absent optional field. Caught and fixed
   in the fixture before reaching any live file.

## Reflection (Reflector)
Outcome: complete. The message queue is now the durable handoff boundary
end to end: a message is persisted verbatim the instant `/send-message`
receives it (`Add-PmcroIntake`), survives a session interruption that
happens immediately after, and is discoverable and resolvable on
reconnect (`Find-PmcroUnresolvedIntake` / `Resolve-PmcroIntake`) with the
same "surface evidence, never silently skip, classification needs a
model" discipline `run-recovery-lease.md` established for Runs last
cycle. Combined with last cycle's work, both halves of the lifecycle this
task's own seed_intent named — "generated work survives chat/UI
interruption" and "can be resumed through Run/Checkpoint/Recovery
semantics" — are now actually implemented, not just documented, and the
specific failure this closes (a prior session's claimed 4-item enqueue
that only wrote 1) could not recur silently: the other 3 messages would
now show up as unresolved intake on the next reconnect instead of simply
being lost.

Lesson: the ingress-side and Run-side durability problems turned out to
be the same shape solved twice, not two different problems — "capture the
truth before reasoning about it, make the capture side-effect-free and
non-classifying, and force reconnect to surface (never silently skip)
anything left uncapped." Keeping `Resolve-PmcroIntake` from also deciding
the disposition (mirroring how the recovery scan never decides
resume/compensate/retry itself) was the one design choice worth being
deliberate about — it would have been easy to fold classification logic
into the resolve script for convenience, which would have quietly moved a
reasoning step into a "no LLM calls" file.

Scope check: `/seed-intent`'s typed API/MCP path was read for context
(`seed-intent.md`) but not modified — it already has its own durability
model and colony-laws' single-shared-queue rule means this fix belongs
only on the file-based `/send-message` side. Confirmed no drift: neither
path was merged into the other.

next_seed_intent: three priority-3 backlog items are now the highest
eligible open work, all unblocked and none carrying a human-decision
label: task-retrospective-trail-ingestion, task-trail-as-product-evolution,
task-capability-gap-composition-learning. Recommend
task-retrospective-trail-ingestion next — it continues directly from this
cycle's own theme (durable capture of work that would otherwise be lost
to session interruption, this time for historical/third-party transcripts
rather than live messages) and its own seed_intent explicitly names the
queue-drift incident these last two cycles have been closing the gap on.
Given the number of live-repo changes made across two consecutive
autonomous cycles, recommend a human checkpoint (review this trail plus
the prior cycle's) before an unattended session claims and runs a third
cycle on its own.

Carried forward, unresolved, not created or touched by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- task-project-pmcro-stale-diff-disposition (open, human decision)
- task-retrospective-trail-ingestion (open, backlog, priority 3)
- task-trail-as-product-evolution (open, backlog, priority 3)
- task-capability-gap-composition-learning (open, backlog, priority 3)
- stale .git/index.lock at repo root (not queued; human attention)

trail_sealed: true
