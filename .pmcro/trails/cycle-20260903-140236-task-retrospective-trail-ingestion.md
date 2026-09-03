# Trail: cycle-20260903-140236-task-retrospective-trail-ingestion

trail_id: cycle-20260903-140236-task-retrospective-trail-ingestion
task_id: task-retrospective-trail-ingestion
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: task-retrospective-trail-ingestion
checkpoint_ref: (none — this cycle completed in one uninterrupted session;
no recovery was needed and none was simulated against the live queue)

## Seed intent
Reconstruct PMCR-O Trails from historical/third-party LLM exports (prior
chat transcripts, non-PMCR-O agent sessions) so pre-colony work becomes
accountable, queryable Trail history rather than being lost outside the
framework. (Re-enqueued item; originally proposed in a prior session that
was interrupted before it persisted to queue.jsonl, reconstructed from
that interrupted session's own summary rather than independently
re-specified — flagged in the queue item itself.) Human authorization:
literal instruction "continue" (twice) following approval of the
engine-wiring cycle and the Reflector's own recommendation, in the prior
cycle's trail, to claim this item next; the Reflector's separate
recommendation to pause for a human checkpoint before a third consecutive
autonomous cycle was surfaced to the human and the human's "continue"
stands as the decision on that question.

## OrchestratorFrame
Claimed task-retrospective-trail-ingestion (priority 3, highest eligible
open item, unblocked, no human-decision label). Read `trail-format.md`,
`accountability-and-trails.md`, `trail-as-product.md`,
`knowledge-promotion.md` before planning, to ground the reconstruction
mechanism in this repo's own existing trail vocabulary rather than
inventing a parallel one.

Confirmed the actual gap this closes, distinct from (but related to) the
last two cycles' ingress/Run durability work: those cycles made *live,
ongoing* work durable against interruption. This item is about *already
lost or never-captured* history — a prior chat transcript, a non-PMCR-O
agent session's output, or (the concrete example already in this
session's own history) an earlier interrupted session's own continuity
summary — becoming queryable Trail history after the fact, rather than
remaining informally described in a human's paste or a queue item's
freeform notes.

Out of scope, left untouched per standing instruction and prior
disposition: task-csproj-version-pin-disposition,
task-pmcro-tmp-disposition, task-project-pmcro-stale-diff-disposition (3
open human-decision items), the stale
`P:\source\pmcro-skills\.git\index.lock`.

## PlanFrame (Planner)
Decided the smallest coherent change: a reconstructed trail must be
structurally distinguishable from a native live trail (so it can never be
mistaken for independently-verified live evidence) and must carry an
explicit evidenced-vs-inferred discipline, but otherwise reuses this
repo's existing Class A trail shape and role-Frame vocabulary rather than
inventing new machinery.

- Extend `PmcroEngine.psm1` (additive only): `New-PmcroRetrospectiveTrail`
  — file-mechanics only (allocates a skeleton), does not read or interpret
  any export, does not touch `queue.jsonl` (a retrospective trail
  documents a Run that is already over; there is nothing live to claim or
  recover). Distinguished from `New-PmcroTrail` by: `retro-<timestamp>-
  <slug>` naming (never `cycle-`, so it cannot collide with or be mistaken
  for a queue-driven cycle trail); no `run_id`/`checkpoint_ref`; a
  mandatory `source_export`/`reconstruction_basis` header; and Frame
  placeholders that say `INSUFFICIENT SOURCE EVIDENCE unless overwritten`
  rather than `PENDING` — a closed historical export will never produce
  more content later the way a live in-progress cycle's `PENDING` Frame
  will.
- Add 1 new deterministic script mirroring the established thin-wrapper
  pattern: `new-retrospective-trail.ps1`.
- Add `retrospective-trail-reconstruction.md` under
  `foundation/references/`: what qualifies as a source export, the
  evidenced/inferred/never-fabricated discipline, the step-by-step
  procedure, and its relationship to `knowledge-promotion.md` (evidence
  strength is capped, not equal to native-trail evidence) and
  `trail-as-product.md` (a Trail Product's provenance must declare when
  its source trail was reconstructed rather than native).
- Cross-reference from `accountability-and-trails.md`, `trail-as-product.md`,
  `knowledge-promotion.md`, `trail-format.md` (documents the `retro-`
  naming as a third, repo-specific derived shape), and
  `reflect-and-seed/SKILL.md` (step 1 now points to the retrospective path
  when the cycle's own work was reconstruction rather than a live Run).
- Deliberately NOT built: any mechanism that treats reconstruction as
  equivalent-strength evidence to a live Checker, or that lets
  reconstruction bypass the single shared queue for surfacing new
  follow-up work — both were explicit anti-goals from the seed intent's
  own framing ("accountable, queryable... rather than being lost", not
  "as authoritative as live work").

TYPE1 approval: additive-only reference-doc/engine changes, no destructive
operation in scope — same approval class as the prior two cycles,
continued under the human's repeated "continue" instruction and the
Reflector's own next_seed_intent recommendation. Scope:
`plugins/pmcro-loop/engine/`, `plugins/pmcro-loop/scripts/`,
`plugins/pmcro-loop/skills/reflect-and-seed/SKILL.md`,
`plugins/pmcro/skills/foundation/references/`,
`projects/pmcro-skills/trail-format.md`.

## MakeFrame (Maker)
Reused the isolated fixture from the prior two cycles (own PowerShell
7.4.6, own scratch git repo) and iterated `New-PmcroRetrospectiveTrail`
there until all Checker scenarios below passed, before applying identical
verified content to the live repo.

Live changes (all additive/backward-compatible):
- `plugins/pmcro-loop/engine/PmcroEngine.psm1` — added
  `New-PmcroRetrospectiveTrail`; updated `Export-ModuleMember`.
- `plugins/pmcro-loop/scripts/new-retrospective-trail.ps1` — new, mirrors
  the existing thin-wrapper scripts' pattern.
- `plugins/pmcro/skills/foundation/references/retrospective-trail-reconstruction.md`
  — new: source-export definition, evidenced/inferred/never-fabricated
  discipline, 6-step procedure, relationship to knowledge promotion and
  Trail Products, relationship to `trail-format.md`'s schema classes.
  Cites this session's own prior-cycle "reconstructed, not independently
  re-specified" queue-item annotations as a worked precedent.
- `plugins/pmcro/skills/foundation/references/accountability-and-trails.md`
  — added a "Retrospective trails" section pointing to the new reference.
- `plugins/pmcro/skills/foundation/references/trail-as-product.md` —
  added a note that a reconstructed source trail's weaker evidence must
  be declared as part of a Trail Product's provenance.
- `plugins/pmcro/skills/foundation/references/knowledge-promotion.md` —
  added a note capping evidence strength for reconstructed trails within
  the existing promotion-criteria paragraph.
- `projects/pmcro-skills/trail-format.md` — added a "Retrospective
  trails" section documenting the `retro-` naming as a third, repo-owned
  derived shape.
- `plugins/pmcro-loop/skills/reflect-and-seed/SKILL.md` — step 1 now
  references the retrospective path for a cycle whose own work was
  reconstruction rather than a live Run.

Not touched: `run-cycle.ps1`, `New-PmcroTrail` (existing live-cycle
allocator, unchanged), `queue.jsonl` schema/mechanics, `queue-enqueue`,
`orchestrate`/`plan-frame`/`make-frame`/`check-frame`/`queue-claim`
SKILL.md, any `.csproj`, `.pmcro-tmp/`, `project/.pmcro/`, or the stale
`.git/index.lock`.

## CheckFrame (Checker)
verdict: pass

Independently exercised the fixture built during MakeFrame:
- **Basic allocation**: `New-PmcroRetrospectiveTrail` with a full field
  set (`-Slug`, `-SourceExport`, `-ReconstructionBasis`,
  `-RelatedTaskId`) wrote a `retro-<timestamp>-<slug>.md` skeleton file
  under `.pmcro/trails/` with all header fields populated and every Frame
  section present.
- **Optional `-RelatedTaskId` omitted**: wrote `related_task_id:` empty
  rather than throwing — confirmed the field is genuinely optional, not
  silently required.
- **Invalid slug rejected**: a slug containing a space and uppercase
  characters (`"Bad Slug!"`) correctly threw before any file was written,
  preventing a retrospective trail filename that could collide with
  filesystem-unsafe characters or be misread as a live cycle id.
- **`queue.jsonl` untouched**: byte-identical before and after the call —
  confirmed a retrospective trail allocation never claims, modifies, or
  otherwise touches the queue, consistent with "documents PAST work, does
  not claim a Run."
- **No naming collision with live cycles**: the produced trail id never
  matches the `cycle-` prefix `New-PmcroTrail` uses, confirmed by pattern
  match on the returned path.
- **Repeated calls produce distinct files**: two calls one second apart
  (second-granularity timestamp) with different slugs produced two
  distinct files, neither overwriting the other.

Also verified directly against the live repo: fetched the live
`PmcroEngine.psm1` in full and compared it line-for-line against the
fixture-tested version applied via `edit_block` — identical.
`git diff --ignore-all-space --stat` scoped to this cycle's touched paths
(`plugins/pmcro-loop/engine/PmcroEngine.psm1`,
`plugins/pmcro/skills/foundation/references/`,
`plugins/pmcro-loop/skills/reflect-and-seed/`,
`projects/pmcro-skills/trail-format.md`) shows exactly the files listed
in MakeFrame plus the untouched files carried over from prior cycles
(`seed-intent-contract.md`, `session-bootstrap.md`, `trail-frame-schema.md`
from cycles 1-2). `git status --porcelain` confirms the 2 new files
(`new-retrospective-trail.ps1`,
`retrospective-trail-reconstruction.md`) are untracked additions and
nothing else in scope changed unexpectedly.

blockers: none

findings: none this cycle — no PowerShell-specific defect surfaced during
fixture testing (unlike cycles 1 and 2, which each found one). The
function's file-mechanics are close enough in shape to `New-PmcroTrail`
(already exercised twice live) that the established conventions —
`@()`-wrapping array returns, untyped params for fields that must
serialize as empty/null-like rather than coerced — were applied correctly
on the first pass this time.

## Reflection (Reflector)
Outcome: complete. Pre-colony work now has a defined, deterministic path
into this colony's accountable Trail history: allocate a
`retro-`-prefixed skeleton (file-mechanics only, no model call), then an
agent fills each Frame strictly from what the export evidences, marking
inferred content as such and leaving genuinely unrecoverable Frames
`INSUFFICIENT SOURCE EVIDENCE` rather than padded out. The mechanism
deliberately does not let a reconstructed trail masquerade as
independently-verified live evidence — CheckFrame verdicts are `reported`
unless this session itself re-verifies, and both `knowledge-promotion.md`
and `trail-as-product.md` now cap what a reconstructed trail alone can
justify.

Lesson: this cycle's own trail is itself now a small piece of evidence for
the mechanism it built — this session already reconstructed lost history
twice (the queue-drift repair in cycle
`cycle-20260903-123224-...`), informally, before this cycle existed to
formalize how. Naming that precedent explicitly in
`retrospective-trail-reconstruction.md` rather than treating the new
mechanism as a hypothetical is worth calling out: the smallest coherent
version of a new capability is often "write down the discipline the
colony already needed and used ad hoc," not something invented from
scratch.

next_seed_intent: two priority-3 backlog items remain, both unblocked and
neither carrying a human-decision label: task-trail-as-product-evolution,
task-capability-gap-composition-learning. Recommend
task-trail-as-product-evolution next — it now has a slightly stronger
foundation to build on, since this cycle's Trail-Product provenance note
(reconstructed vs. native evidence strength) is exactly the kind of
distinction a fuller Trail Product mechanism will need to carry forward.
As in the prior cycle's Reflection: given this is now three consecutive
autonomous cycles making live changes to the repo, a human checkpoint
before claiming a fourth remains the more conservative default, though
the human has twice now chosen to continue past that recommendation.

Carried forward, unresolved, not created or touched by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- task-project-pmcro-stale-diff-disposition (open, human decision)
- task-trail-as-product-evolution (open, backlog, priority 3)
- task-capability-gap-composition-learning (open, backlog, priority 3)
- stale .git/index.lock at repo root (not queued; human attention)

trail_sealed: true
