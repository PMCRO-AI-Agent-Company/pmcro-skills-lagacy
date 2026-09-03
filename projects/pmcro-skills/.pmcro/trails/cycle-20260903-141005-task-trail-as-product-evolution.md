# Trail: cycle-20260903-141005-task-trail-as-product-evolution

trail_id: cycle-20260903-141005-task-trail-as-product-evolution
task_id: task-trail-as-product-evolution
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: task-trail-as-product-evolution
checkpoint_ref: (none — this cycle completed in one uninterrupted session;
no recovery was needed and none was simulated against the live queue)

## Seed intent
Evolve validated Trails into reusable Trail Products: durable knowledge,
capabilities, and skill candidates the colony can reuse, building on the
existing trail-as-product.md and knowledge-promotion.md references.
(Re-enqueued item; originally proposed in a prior session that was
interrupted before it persisted to queue.jsonl, reconstructed from that
interrupted session's own summary rather than independently re-specified
— flagged in the queue item itself.) Human authorization: literal
instruction "continue" (three times now) following approval of the
engine-wiring cycle and the Reflector's own recommendation, in the prior
cycle's trail, to claim this item next.

## OrchestratorFrame
Claimed task-trail-as-product-evolution (priority 3, highest eligible open
item, unblocked, no human-decision label). Read `knowledge-promotion.md`
and `trail-as-product.md` in full (both already read in cycle 3, re-read
for this cycle's planning) plus `accountability-and-trails.md` and
`reflect-and-seed/SKILL.md`'s existing (freeform, unimplemented) reference
to writing under `.pmcro/constraints/`.

Confirmed the actual gap: both foundation docs describe the *shape* of
promotion and productization conceptually — a taxonomy
(constraint | rule-policy | strategy-preference | skill-candidate |
training-example | audit-record) and a lifecycle diagram
(experience -> trail -> validation -> product -> reuse) — but neither had
a concrete file schema or a deterministic mechanism, unlike `queue.jsonl`
(`queue.schema.md`), `approvals.jsonl` (`approvals.schema.md`), or trails
themselves (`New-PmcroTrail`). `reflect-and-seed/SKILL.md` action 2
already told a future Reflector to "write under `.pmcro/constraints/`"
with no shape to write to. `capability-registry.json` was inspected and
confirmed out of scope — it is an auto-generated plugin-discovery index
from a different, earlier task, not a place for proposed skill
candidates.

Out of scope, left untouched: task-csproj-version-pin-disposition,
task-pmcro-tmp-disposition, task-project-pmcro-stale-diff-disposition (3
open human-decision items), the stale
`P:\source\pmcro-skills\.git\index.lock`, `capability-registry.json`.

## PlanFrame (Planner)
Decided the smallest coherent change: two deterministic allocators
mirroring `New-PmcroRetrospectiveTrail`'s established shape (file
mechanics only, one hard evidentiary rule enforced, no reasoning), plus
their schema docs and cross-references — then actually use both on this
session's own validated trails, so the seed intent's own verb ("evolve...
into reusable Trail Products") is demonstrated, not just made possible.

- `New-PmcroConstraint` (`PmcroEngine.psm1`): writes an earned-knowledge
  record under `.pmcro/constraints/<kind>-<timestamp>-<slug>.md`. Hard
  rule enforced deterministically: at least one evidence trail id is
  required — an "earned" record with no evidence is a contradiction.
  Everything else (does the evidence actually justify this Kind/Statement,
  is the scope narrow enough) stays Reflector/model reasoning, same
  boundary drawn for every other classification decision in this engine.
- `New-PmcroTrailProduct` (`PmcroEngine.psm1`): writes a Trail Product
  manifest under `.pmcro/products/product-<timestamp>-<slug>.md`.
  `evidence_class` (native | reconstructed | mixed) is derived
  automatically from the source trail ids' own `cycle-`/`retro-` prefix
  convention (established in cycle 3) rather than accepted as a
  caller-asserted field — a direct payoff of that naming decision: a
  product's declared evidence strength cannot silently overstate what its
  actual sources support.
- 2 new thin-wrapper scripts: `new-constraint.ps1`, `new-trail-product.ps1`.
- 2 new schema docs: `constraints.schema.md`, `products.schema.md`,
  mirroring `queue.schema.md`'s format.
- Cross-reference from `knowledge-promotion.md`, `trail-as-product.md`,
  `reflect-and-seed/SKILL.md` action 2 (now points at the concrete
  mechanism instead of freeform "write under").
- **Dogfood the mechanism this cycle**: this session's own history already
  supplies clean material — the same array-return-unrolling PowerShell
  pitfall was independently rediscovered in both cycle 1 and cycle 2,
  which is exactly `knowledge-promotion.md`'s bar for `active` status
  ("Repeated, independently checked observations can justify stronger
  policy"), and cycles 1+2's Run/Recovery/Intake work is validated,
  reusable procedure exactly matching `trail-as-product.md`'s definition
  of a Trail Product. Write one of each for real rather than leaving the
  mechanism untested against real content.
- Deliberately NOT built: any mechanism that infers or asserts promotion
  judgment automatically (recurrence detection, auto-generated Statement
  text, auto-selected Kind) — `knowledge-promotion.md` explicitly says
  "do not treat every observation as a universal rule," and that judgment
  call stays with Reflector/model reasoning, never the deterministic
  engine.

TYPE1 approval: additive-only engine/doc changes, no destructive operation
in scope — same approval class as the prior three cycles, continued under
the human's repeated "continue" instruction and the Reflector's own
next_seed_intent recommendation. Scope: `plugins/pmcro-loop/engine/`,
`plugins/pmcro-loop/scripts/`,
`plugins/pmcro-loop/skills/reflect-and-seed/SKILL.md`,
`plugins/pmcro/skills/foundation/references/knowledge-promotion.md`,
`plugins/pmcro/skills/foundation/references/trail-as-product.md`,
`projects/pmcro-skills/.pmcro/constraints.schema.md`,
`projects/pmcro-skills/.pmcro/products.schema.md`, and the two dogfooded
records under `.pmcro/constraints/` and `.pmcro/products/`.

## MakeFrame (Maker)
Reused the isolated fixture from the prior three cycles (own PowerShell
7.4.6, own scratch git repo) and iterated `New-PmcroConstraint`/
`New-PmcroTrailProduct` there until all Checker scenarios below passed,
before applying identical verified content to the live repo.

Live changes (all additive/backward-compatible):
- `plugins/pmcro-loop/engine/PmcroEngine.psm1` — added `New-PmcroConstraint`,
  `New-PmcroTrailProduct`; updated `Export-ModuleMember`.
- `plugins/pmcro-loop/scripts/new-constraint.ps1`,
  `new-trail-product.ps1` — new, mirror the existing thin-wrapper pattern.
- `projects/pmcro-skills/.pmcro/constraints.schema.md`,
  `products.schema.md` — new, mirror `queue.schema.md`'s format.
- `plugins/pmcro/skills/foundation/references/knowledge-promotion.md` —
  one-line cross-reference to `New-PmcroConstraint` in the Skill synthesis
  section.
- `plugins/pmcro/skills/foundation/references/trail-as-product.md` —
  one-line cross-reference to `New-PmcroTrailProduct`, noting the
  automatic `evidence_class` derivation.
- `plugins/pmcro-loop/skills/reflect-and-seed/SKILL.md` — action 2
  rewritten to reference both new scripts/functions and their schema
  docs, replacing the prior freeform "write under `.pmcro/constraints/`."

Dogfooded records, written live via the actual PowerShell functions
(Windows PowerShell 5.1, confirmed compatible — no PowerShell 7-only
syntax was used in either function) rather than hand-authored:
- `.pmcro/constraints/constraint-20260903-090939-powershell-array-return-wrapping.md`
  — `kind: constraint`, `status: active` (recurrence across cycles 1 and
  2 justifies `active` per `knowledge-promotion.md`'s own bar, not left
  at `provisional`), evidence:
  `cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine`,
  `cycle-20260903-125025-task-seed-intent-queue-ingress`.
- `.pmcro/products/product-20260903-090953-file-based-run-recovery-and-intake-durability.md`
  — packages the same two trails' Run/Checkpoint/Lease/Heartbeat/Recovery
  + intake-durability work for reuse in another file-based PMCR-O
  implementation; `evidence_class` computed as `native` (both sources are
  `cycle-` trails) without being asserted.

Not touched: `New-PmcroTrail`/`New-PmcroRetrospectiveTrail` (unchanged),
`capability-registry.json`, `run-cycle.ps1`, `queue.jsonl` mechanics
(constraints/products intentionally do not touch the queue),
`orchestrate`/`plan-frame`/`make-frame`/`check-frame`/`queue-claim`/
`queue-enqueue` SKILL.md, any `.csproj`, `.pmcro-tmp/`, `project/.pmcro/`,
or the stale `.git/index.lock`.

## CheckFrame (Checker)
verdict: pass

Independently exercised the fixture built during MakeFrame:
- **`New-PmcroConstraint` basic write**: full field set produced a file
  under `.pmcro/constraints/` with every header field and both body
  sections (Statement, Evidence) populated correctly.
- **No-evidence rejection**: an empty `-EvidenceTrailIds` array was
  rejected by PowerShell's own mandatory-array binding before the
  function body's explicit check even ran (belt-and-suspenders — both
  layers refuse an unevidenced record).
- **Invalid slug / invalid Kind rejected**: a slug with a space and
  uppercase, and a `-Kind` value outside the `ValidateSet`, both threw
  before any file was written.
- **`New-PmcroTrailProduct` evidence_class derivation**: all-`cycle-`
  source ids → `native`; all-`retro-` source ids → `reconstructed`; one of
  each → `mixed`. All three verified against constructed fixture trail
  ids before ever computing it against this cycle's real, live source
  trails.
- **No-source-trail rejection**: an empty `-SourceTrailIds` array threw
  before any file was written.
- **`queue.jsonl` untouched**: byte-identical before and after both
  functions were called repeatedly in the fixture — neither claims,
  modifies, or otherwise reads the queue for anything but is a pure
  additive write elsewhere.

Also verified directly against the live repo:
- Confirmed Windows PowerShell 5.1 (the interpreter actually available on
  the live machine, distinct from the PowerShell 7.4.6 fixture) runs both
  new functions without modification — `Get-Verb`/module-import warning
  aside, no syntax error, and the live dogfooded output matches the
  fixture-verified shape exactly.
- Read back both dogfooded live files in full: `evidence_class: native`
  correctly computed (not hand-typed) for the Trail Product; the
  constraint's `Evidence` section lists exactly the two intended trail
  ids in order.
- `git diff --ignore-all-space --stat` scoped to this cycle's touched
  paths shows exactly the 4 modified files (`PmcroEngine.psm1`,
  `reflect-and-seed/SKILL.md`, `knowledge-promotion.md`,
  `trail-as-product.md`) named in MakeFrame — no unrelated file in that
  set. `git status --porcelain` confirms the 6 new untracked
  additions (2 scripts, 2 schema docs, 1 constraint file, the new
  `products/` directory) are exactly this cycle's own output.

blockers: none

findings: none this cycle — no new PowerShell-specific defect (the third
consecutive cycle to build a `New-Pmcro*` allocator on this established
pattern, and the third time the same `@()`/untyped-optional-param
conventions were applied correctly on the first pass). Cross-interpreter
note, not a defect: Windows PowerShell 5.1 (live) and PowerShell 7.4.6
(fixture) produced byte-for-byte identical output shape for both new
functions on the same inputs — worth keeping in mind for future engine
work, since this session's fixture-then-live methodology has so far only
verified PowerShell-7-authored code against a PowerShell-7 fixture, and
this cycle is the first direct confirmation that the live Windows
PowerShell 5.1 interpreter is not silently diverging.

## Reflection (Reflector)
Outcome: complete. Trail Products and earned-knowledge promotion now have
a concrete, deterministic path matching the queue/approvals/trail
mechanisms this colony already had — and, unlike the retrospective-trail
mechanism in cycle 3, this cycle didn't stop at "the mechanism exists,"
it produced one real constraint and one real Trail Product from this
session's own validated history. The `active`-status constraint
(array-return wrapping) is now a durable, evidence-backed record a future
cycle or a fresh session can read directly rather than re-deriving from
scratch or from chat memory; the Trail Product packages a genuinely
reusable procedure (file-based Run/Recovery/Intake durability) with
correctly-computed provenance for whichever consumer runtime picks it up.

Lesson: the automatic `evidence_class` derivation (cycle 3's `retro-`
naming decision paying off in cycle 4's product allocator) is the kind of
small design choice that compounds — a convention established for one
reason (never mistake a reconstructed trail for a live one) turned out to
also solve "how does a Trail Product's provenance stay honest" for free,
without adding a second piece of caller-supplied metadata that could
drift from the truth.

next_seed_intent: one priority-3 backlog item remains, unblocked, no
human-decision label: task-capability-gap-composition-learning
("Formalize partial capability discovery, composition of existing
capabilities to cover a gap, explicit gap recording when no composition
suffices, and promotion of a proven composition into a first-class
capability."). Recommend it next — after this cycle, "promotion of a
proven composition into a first-class capability" now has somewhere
concrete to land (`New-PmcroConstraint` with `kind: skill-candidate`, or
`New-PmcroTrailProduct`), so this item is better-grounded than it would
have been four cycles ago. Once it closes, the re-enqueued backlog from
the lost prior session will be fully drained and only the 3
human-decision items and the stale `.git/index.lock` will remain — worth
flagging to the human explicitly rather than silently continuing into
genuinely new, non-reconstructed territory without a fresh check-in.

Carried forward, unresolved, not created or touched by this cycle:
- task-csproj-version-pin-disposition (open, human decision)
- task-pmcro-tmp-disposition (open, human decision)
- task-project-pmcro-stale-diff-disposition (open, human decision)
- task-capability-gap-composition-learning (open, backlog, priority 3)
- stale .git/index.lock at repo root (not queued; human attention)

trail_sealed: true
