# Trail: cycle-20260903-142439-task-capability-gap-composition-learning

trail_id: cycle-20260903-142439-task-capability-gap-composition-learning
task_id: task-capability-gap-composition-learning
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: task-capability-gap-composition-learning
checkpoint_ref: (none — this cycle completed in one uninterrupted session;
no recovery was needed and none was simulated against the live queue)

## Seed intent
Formalize partial capability discovery, composition of existing
capabilities to cover a gap, explicit gap recording when no composition
suffices, and promotion of a proven composition into a first-class
capability. (Re-enqueued item; originally proposed in a prior session
that was interrupted before it persisted to queue.jsonl, reconstructed
from that interrupted session's own summary rather than independently
re-specified — flagged in the queue item itself.) Human authorization:
literal instruction "continue" (five times now) following the Reflector's
own recommendation, in cycle
cycle-20260903-141005-task-trail-as-product-evolution's trail, to claim
this item next.

## OrchestratorFrame
Claimed task-capability-gap-composition-learning (priority 3, the last
unblocked backlog item without a human-decision label). Re-read
`discover-capabilities/SKILL.md` (Resolution contract), the underlying
`discover-capabilities.ps1`/`resolve-capability.ps1` scripts, and
`plan-frame/SKILL.md`'s existing reference to discovery, to confirm the
actual gap before designing anything.

Confirmed: `discover-capabilities` already does real partial/fuzzy
matching (scored resolution against manifest name, description, skill
names, declared artifacts) — so "partial capability discovery" per se was
already substantially covered, not a genuine gap. The real gap was
downstream of that: step 5 of the Resolution contract ("If no provider is
installed, report unresolved capability rather than inventing one") has
nowhere concrete to write that report, and nothing in the existing
mechanism ever considers composing 2+ partial matches together before
concluding a need is unmet. `capability-registry.json` was re-confirmed
out of scope (auto-generated discovery index, untouched).

Out of scope, left untouched: task-csproj-version-pin-disposition,
task-pmcro-tmp-disposition, task-project-pmcro-stale-diff-disposition (3
open human-decision items), the stale
`P:\source\pmcro-skills\.git\index.lock`, `capability-registry.json`,
`discover-capabilities.ps1`/`resolve-capability.ps1` (existing, working
mechanics — extended by cross-reference only, not modified).

## PlanFrame (Planner)
Decided the smallest coherent change: two deterministic allocators
mirroring the established `New-Pmcro*` shape (file mechanics only, hard
evidentiary rules enforced, no reasoning), a procedural reference doc
tying discovery -> composition -> gap-recording -> promotion together,
two schema docs, cross-references from the two existing docs that already
gesture at this gap, and — as with cycle 4 — actually exercising the new
mechanism against this session's own real material rather than stopping
at "the mechanism exists."

- `New-PmcroCapabilityComposition` (`PmcroEngine.psm1`): writes a record
  under `.pmcro/compositions/composition-<timestamp>-<slug>.md` when 2+
  existing capabilities used together cover a need no single installed
  provider covers alone. Hard rules enforced deterministically: at least
  2 parts in `-ComposedOf` (a single capability is not a composition) and
  at least 1 evidence trail. `proven` is derived automatically from the
  evidence trail count (>=2 independent trails) rather than accepted as a
  caller-asserted boolean — directly reusing cycle 4's `evidence_class`
  pattern (a record's declared strength can never exceed what its cited
  evidence actually supports) for a new field shape.
- `New-PmcroCapabilityGap` (`PmcroEngine.psm1`): writes a record under
  `.pmcro/capability-gaps/gap-<timestamp>-<slug>.md` when neither a
  provider nor a composition covers a need. Hard rule enforced
  deterministically: `-CompositionConsidered` must be non-empty — a gap
  record can never be written without first explaining why composition
  was tried and rejected, so gap-recording cannot become a shortcut
  around the composition step the seed intent itself orders first.
- 2 new thin-wrapper scripts: `new-capability-composition.ps1`,
  `new-capability-gap.ps1`.
- New reference doc `capability-gap-and-composition.md`: the 6-step
  procedure (discover -> prefer exact match -> consider composition ->
  record composition -> record gap only if composition doesn't suffice ->
  treat an open gap as a lead on reconnect, not noise to re-derive), plus
  the promotion path into a first-class capability, reusing cycle 4's
  `skill-candidate` constraint + `/createskill` path rather than inventing
  a parallel one.
- 2 new schema docs: `compositions.schema.md`, `capability-gaps.schema.md`,
  mirroring `constraints.schema.md`/`products.schema.md`'s format.
- Cross-reference from `discover-capabilities/SKILL.md`'s Resolution
  contract step 5 (now points at the concrete mechanism instead of
  dead-ending at "report unresolved capability") and from
  `knowledge-promotion.md` (ties composition/gap into the existing
  skill-candidate pipeline).
- **Dogfood the mechanism this cycle**: this session's own history
  supplies clean, real material — the `git diff --ignore-all-space
  --stat` scope-check technique is a genuine composition (plain `git
  diff`/`git status` alone produce whole-repo false positives on this
  CRLF checkout, as directly reconfirmed during this cycle's own
  CheckFrame below; no single flag or tool alone solves it) that has now
  been independently exercised across 4 prior cycles' trails — clearing
  `proven`'s >=2-trail bar honestly. Write one real
  `New-PmcroCapabilityComposition` record for it, then promote it the
  documented way with one real `skill-candidate` `New-PmcroConstraint`
  record citing the composition (not yet `/createskill` — scaffolding an
  actual skill is a separate, larger judgment call left for a future
  cycle, not manufactured here just to complete the pipeline
  end-to-end).
- Deliberately NOT fabricated: a `New-PmcroCapabilityGap` example. No
  genuine unresolved capability need arose during this session to record
  honestly — see Reflection.
- Deliberately NOT built: any mechanism that auto-detects or evaluates
  whether a composition "actually works," or auto-promotes a `proven`
  composition into a skill — both stay Reflector/model/human judgment,
  same boundary drawn for every other classification decision in this
  engine and explicitly reaffirmed in the new reference doc's "What this
  deliberately does not do" section.

TYPE1 approval: additive-only engine/doc changes, no destructive operation
in scope — same approval class as the prior four cycles, continued under
the human's repeated "continue" instruction and the Reflector's own
next_seed_intent recommendation. Scope: `plugins/pmcro-loop/engine/`,
`plugins/pmcro-loop/scripts/`,
`plugins/pmcro/skills/foundation/references/capability-gap-and-composition.md`
(new), `plugins/pmcro/skills/foundation/references/knowledge-promotion.md`,
`projects/pmcro-skills/.agents/skills/discover-capabilities/SKILL.md`,
`projects/pmcro-skills/.pmcro/compositions.schema.md`,
`projects/pmcro-skills/.pmcro/capability-gaps.schema.md`, and the two
dogfooded records under `.pmcro/compositions/` and `.pmcro/constraints/`.

## MakeFrame (Maker)
Reused the isolated fixture from the prior four cycles (PowerShell 7.4.6,
own scratch git repo) and iterated `New-PmcroCapabilityComposition`/
`New-PmcroCapabilityGap` there until all Checker scenarios below passed,
before applying identical verified content to the live repo.

Live changes (all additive/backward-compatible):
- `plugins/pmcro-loop/engine/PmcroEngine.psm1` — added
  `New-PmcroCapabilityComposition`, `New-PmcroCapabilityGap`; updated
  `Export-ModuleMember`.
- `plugins/pmcro-loop/scripts/new-capability-composition.ps1`,
  `new-capability-gap.ps1` — new, mirror the existing thin-wrapper
  pattern.
- `plugins/pmcro/skills/foundation/references/capability-gap-and-composition.md`
  — new procedural reference doc.
- `projects/pmcro-skills/.pmcro/compositions.schema.md`,
  `capability-gaps.schema.md` — new, mirror `constraints.schema.md`/
  `products.schema.md`'s format.
- `projects/pmcro-skills/.agents/skills/discover-capabilities/SKILL.md` —
  Resolution contract step 5 extended with the composition-then-gap
  pointer and a reminder to check `.pmcro/capability-gaps/` before
  re-searching.
- `plugins/pmcro/skills/foundation/references/knowledge-promotion.md` —
  one paragraph tying capability composition/gap into the existing
  skill-candidate promotion path.

Dogfooded records, written live via the actual PowerShell functions
(Windows PowerShell 5.1, confirmed compatible) rather than hand-authored:
- `.pmcro/compositions/composition-20260903-092309-crlf-safe-scope-check.md`
  — `status: candidate`, `proven: true` (correctly derived, not
  hand-typed — 4 evidence trails cited), `-ComposedOf` lists `git diff`,
  `--ignore-all-space`, `--stat`, and the manual awareness that plain
  `git status`/`git diff` are unreliable here; evidence:
  `cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine`,
  `cycle-20260903-125025-task-seed-intent-queue-ingress`,
  `cycle-20260903-140236-task-retrospective-trail-ingestion`,
  `cycle-20260903-141005-task-trail-as-product-evolution`.
- `.pmcro/constraints/skill-candidate-20260903-092347-crlf-safe-scope-check.md`
  — `kind: skill-candidate`, `status: active`, citing the composition
  record above and the same 4 trails, per
  `capability-gap-and-composition.md`'s documented promotion path.

Not touched: `New-PmcroTrail`/`New-PmcroRetrospectiveTrail`/
`New-PmcroConstraint`/`New-PmcroTrailProduct` (unchanged), the composition
record's `status` (left `candidate` — `/createskill` was deliberately not
run this cycle, so `promoted` would misstate what actually happened),
`capability-registry.json`, `discover-capabilities.ps1`/
`resolve-capability.ps1`, `run-cycle.ps1`, `queue.jsonl` mechanics
(compositions/gaps intentionally do not touch the queue, same as
constraints/products), any `.csproj`, `.pmcro-tmp/`, `project/.pmcro/`,
or the stale `.git/index.lock`.

## CheckFrame (Checker)
verdict: pass

Independently exercised the fixture built during MakeFrame:
- **`New-PmcroCapabilityComposition` basic write**: full field set
  produced a file under `.pmcro/compositions/` with every header field
  and all four body sections (Need, Composed of, How it composes,
  Evidence) populated correctly.
- **`-ComposedOf` cardinality rejection**: a single-element array was
  rejected ("a single capability is not a composition"); an empty array
  was rejected by PowerShell's own mandatory-array binding.
- **No-evidence rejection**: an empty `-EvidenceTrailIds` array rejected
  the same way.
- **`proven` derivation**: 1 evidence trail -> `proven: false`; 2+ ->
  `proven: true`, verified against constructed fixture ids before ever
  computing it against this cycle's real trails.
- **`New-PmcroCapabilityGap` basic write**: full field set produced a
  correct file under `.pmcro/capability-gaps/`, including the
  `(none found)` fallback when `-PartialMatches` is omitted.
- **`-CompositionConsidered` required**: empty/whitespace-only value
  rejected with the documented message; this is the one hard rule new to
  this cycle and was checked explicitly since it is the mechanism's main
  safeguard against gap-recording bypassing composition.
- **No-evidence rejection (gap)**: same as composition's.
- **Invalid slug rejected** for both functions (space, uppercase).
- **`queue.jsonl` untouched**: byte-identical before/after repeated calls
  to both functions in the fixture.

**Defect found and fixed before reaching any live file** (documented in
full in this cycle's own working notes, summarized here): the first draft
of both new functions' heredoc body text used markdown-style single
backticks for inline code (e.g. `` `skill-candidate` ``, `` `resolved_by` ``).
PowerShell's `@" ... "@` double-quoted here-string treats a backtick as an
escape character even for markdown-style inline code — `` `r `` was
silently read as the carriage-return escape (consuming the letter),
and any other single backtick before an unrecognized escape letter was
silently dropped, with neither case producing an error. Confirmed via a
direct byte-level test in the fixture's PowerShell 7.4.6 interpreter
(converted a test string with `` `s ``, `` `r ``, `` `x ``, and a doubled
backtick to UTF-8 bytes and inspected them directly). Fixed by replacing
every such backtick with a single quote in both functions' body text
(matching `New-PmcroTrailProduct`'s existing convention of using no
backticks at all), then re-ran the fixture tests to confirm clean output.
Scope-checked the rest of the module: grepped for backtick patterns and
manually re-read all 6 heredoc bodies in the file (`New-PmcroTrail`,
`New-PmcroRetrospectiveTrail`, `New-PmcroConstraint`,
`New-PmcroTrailProduct`, and the two new functions) — only the two new
functions had this defect; the four earlier, already-live functions were
clean. This is the third distinct PowerShell-specific pitfall this
session's fixture-first discipline has caught before it reached a live
file (after the two array-unrolling bugs in cycles 1-2) — recorded as a
finding below rather than a fourth dogfooded constraint, since one
instance does not yet meet `knowledge-promotion.md`'s recurrence bar for
`active` status the way the array-unrolling pitfall did.

Also verified directly against the live repo:
- Windows PowerShell 5.1 ran both new functions without modification
  (module-import unapproved-verb warning aside, expected and already
  seen in every prior cycle); live dogfooded output read back in full
  and matches the fixture-verified (post-fix) shape exactly — no
  backtick corruption in either live file.
- `proven: true` on the live composition record is a legitimate,
  correctly-derived outcome: the `git diff --ignore-all-space --stat`
  technique really has been independently exercised across all 4 prior
  cycles' scope-checks this session, and re-running that exact technique
  as part of this cycle's own scope-check (below) reconfirmed the need it
  addresses is real, not asserted.
- `git diff --ignore-all-space --stat` scoped to this cycle's 3 modified
  files (`PmcroEngine.psm1`, `discover-capabilities/SKILL.md`,
  `knowledge-promotion.md`) shows exactly the changes described in
  MakeFrame and nothing else. A full-repo `git status --porcelain` was
  also run and shows only this cycle's new files plus every
  already-known untracked/modified item from cycles 1-4 and earlier
  sessions — no unrelated file touched, no human-decision item touched.
  (The full-repo `git diff --stat` without path scoping was also run and,
  as expected and previously documented, produced ~26 files of
  CRLF/pre-existing noise — direct, current confirmation that the plain
  form is unreliable here and the path-scoped `--ignore-all-space` form
  is the one this colony should keep relying on.)

blockers: none

findings:
1. PowerShell `@" ... "@` here-string backtick-escape corruption
   (documented above) — caught and fixed in the fixture before reaching
   any live file. Not yet promoted to a constraint record (single
   occurrence this session); flagged here as a candidate for a future
   `provisional`-status constraint if it recurs.

## Reflection (Reflector)
Outcome: complete. Capability gap and composition now have a concrete,
deterministic path matching the queue/approvals/trail/constraint/product
mechanisms this colony already had. Discovery's own Resolution contract
no longer dead-ends at "report unresolved capability" with nowhere to
write that report — it now points at a real 6-step procedure, and a
future cycle facing a similar need can check `.pmcro/capability-gaps/`
for an open lead instead of re-searching from nothing. As with cycle 4,
this cycle didn't stop at "the mechanism exists": it produced one real,
honestly-`proven` composition record and promoted it the documented way
into a real `skill-candidate` constraint — both drawn from this session's
own genuine, repeated use of the CRLF-safe scope-check technique, not
manufactured examples.

Deliberately incomplete, by design rather than oversight: no
`New-PmcroCapabilityGap` record was written this cycle. No genuine
unresolved capability need actually arose during this session's five
cycles of work — inventing one to demonstrate the function would have
violated the same never-fabricate discipline this colony has held to
since `retrospective-trail-reconstruction.md`, and the function itself is
fixture-verified and ready for the first real gap that does arise.
Likewise, the dogfooded composition's `status` was left `candidate`, not
advanced to `promoted` — that requires actually scaffolding a skill via
`/createskill`, a separate, larger judgment call (is a `git diff
--ignore-all-space --stat` wrapper genuinely worth a first-class skill,
versus just a documented practice?) better made deliberately in a future
cycle than defaulted into here.

Lesson: the third PowerShell-specific defect this session (backtick
heredoc corruption) was caught by the same fixture-first discipline that
caught the first two — direct evidence the methodology generalizes across
different failure modes (array semantics, string escaping) rather than
having been tuned to catch only the first kind of bug found. Also: cycle
4's `evidence_class` derivation pattern generalized cleanly to a second,
differently-shaped field (`proven`, a boolean rather than a 3-way enum) on
the first attempt — a second confirmation that "derive strength from
evidence count/naming, never accept it as caller-asserted" is a durable
design idiom for this engine, not a one-off.

next_seed_intent: none recommended for autonomous continuation. With this
cycle closed, the re-enqueued backlog from the lost prior session is now
fully drained (task-seed-intent-queue-ingress,
task-retrospective-trail-ingestion, task-trail-as-product-evolution, and
this cycle's task-capability-gap-composition-learning have all closed
across cycles 1-5). The only remaining queue.jsonl items are the 3
explicitly human-decision-labeled items
(task-csproj-version-pin-disposition, task-pmcro-tmp-disposition,
task-project-pmcro-stale-diff-disposition) that every prior cycle's
Reflector has consistently declined to act on without a human decision,
plus the stale `.git/index.lock` (not a queue item). None of these are
appropriate to resolve under a bare "continue" — each genuinely requires
a human decision this colony cannot make for itself (revert-vs-commit a
version pin against an unconfirmed SDK-restore behavior; delete-vs-relocate
a script; confirm-vs-revert an unexplained small diff in a separate,
possibly-stale `.pmcro` tree). Recommend pausing here and surfacing these
3 items plus the stale lock to the human directly, rather than treating
"continue" as authorization to make disposition calls that were
explicitly reserved for a human across five straight cycles' trails.

Carried forward, unresolved, not created or touched by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- task-project-pmcro-stale-diff-disposition (open, human decision)
- stale .git/index.lock at repo root (not queued; human attention)

trail_sealed: true
