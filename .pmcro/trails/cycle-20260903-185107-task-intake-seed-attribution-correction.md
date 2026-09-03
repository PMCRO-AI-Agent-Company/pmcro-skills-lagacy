# Trail: cycle-20260903-185107-task-intake-seed-attribution-correction

trail_id: cycle-20260903-185107-task-intake-seed-attribution-correction
task_id: task-intake-20260903-135107390
domain: pmcro-governance
priority: 2
opened: 2026-09-03
run_id: (intake/resolve bookkeeping only -- no build performed this cycle)
checkpoint_ref: (none)
trail_sealed: true

## Seed intent

Human correction, dictated (voice-to-text, preserved verbatim as
messy_seed_text of the intake item this trail covers): pointed out that
several queue items filed earlier this session carried `created_by:
"human"` with the seed_intent field itself holding lightly-paraphrased
raw dictation ("Human instruction: ..."), and that this is exactly the
distinction `seed-intent-contract.md` already draws and this session had
not been honoring: a human message is Messy Seed Intent (preserve
exactly, however imprecise), and the canonical Seed Intent is the
Reflector/Orchestrator-refined product derived from it. Also granted
standing autonomy: "autonomous do as you recommend."

## OrchestratorFrame

Read `seed-intent-contract.md`
(`plugins/pmcro/skills/foundation/references/`) in full before acting --
confirmed the intake/resolve pipeline described (`Add-PmcroIntake` ->
`Resolve-PmcroIntake`, `intake-message.ps1`/`resolve-intake.ps1`) is
exactly the mechanism this correction was describing, already built this
session (task-seed-intent-queue-ingress) but not used for the items the
human flagged.

Confirmed the violation directly: `task-git-lifecycle-plugin`,
`task-desktop-commander-plugin`, `task-anthropic-agent-design-pattern-
mapping` (hand-written JSONL, pre-dating `enqueue.ps1`) and, worse,
`task-adopt-command-asset-and-precondition-footer` /
`task-save-pmcroqueue-reformats-whole-file` (filed via `enqueue.ps1`
itself, earlier this same session) all used
`Add-PmcroQueueItem`/`enqueue.ps1` directly with raw-paraphrased text as
`-SeedIntent` -- exactly the case `Add-PmcroQueueItem`'s own doc comment
warns against ("For a raw, not-yet-classified message use Add-PmcroIntake
instead"). Doc-comment discipline alone was not sufficient; this agent
did not follow it either.

## MakeFrame

Dogfooded the correct mechanism against the human's own message that
raised it:
1. `intake-message.ps1` persisted the raw dictated message verbatim as
   `task-intake-20260903-135107390`, `status: intake`, before any
   classification.
2. `resolve-intake.ps1` classified disposition `enqueued` (a real,
   actionable governance-process defect with concrete audit+fix scope --
   not merely informational) and supplied a `RefinedSeedIntent` naming
   the 5 non-compliant items, the concrete audit/fix scope, and a
   recommendation to strengthen `enqueue.ps1` beyond doc-comment-only
   discipline. `messy_seed_text` preserved automatically by
   `Resolve-PmcroIntake`.
3. Self-caught defect: a bash-style quote-escaping fragment
   (`'"'"'`) leaked into the `RefinedSeedIntent` here-string, garbling
   one clause ("human'"'"'s original wording"). Caught before sealing
   this trail (still live Make-phase work, not yet committed) --
   corrected via `Get-PmcroQueue`/`Save-PmcroQueue` (the engine's own
   load/save functions, not raw text splicing) rather than left in the
   record. Distinguished from the "resolve next cycle" law: that law
   covers Checker-caught *functional* errors in already-sealed/committed
   work; this was an in-progress Make-phase typo caught before Check, the
   normal place to fix it.

No retroactive edits made to the 5 already-filed non-compliant items --
that audit+fix is the scope handed to whoever claims
`task-intake-20260903-135107390` next, consistent with "resolving it is
the next cycle's job, not a patch mid-cycle" (this session's own colony
law, added earlier today).

## CheckFrame
verdict: pass

- `queue.jsonl`: 39 lines, every line parses as valid JSON (verified via
  `ConvertFrom-Json` over every line individually, not just the tail).
- Resolved item confirmed: `status: open`, `messy_seed_text` present and
  matches the human's dictated text verbatim, `seed_intent` is the
  refined product (not the raw message), garbled clause corrected and
  re-verified by reading the field back after the fix.
- Scratch driver scripts (`run-intake-seed-correction.ps1`,
  `run-resolve-seed-correction.ps1`, `run-fix-garbled-seed-intent.ps1`,
  `run-verify-queue.ps1`) removed post-run -- not part of any tracked
  directory convention.

## Reflection
outcome: done
next_seed_intent: captured in full inside the resolved queue item
(`task-intake-20260903-135107390`) itself -- not duplicated here. Summary
for a human skimming trails: audit and correct the 5 items named above
(preserve their existing text as provenance, replace/accompany with a
properly refined seed_intent); consider hardening `enqueue.ps1` so it
rejects seed_intent text that reads as unedited raw dictation rather than
relying on a doc comment; going forward, all raw human input routes
through `intake-message.ps1` -> `resolve-intake.ps1`, never straight into
`enqueue.ps1`.

Standing note: human granted autonomy this cycle ("autonomous do as you
recommend"). Applied here by proceeding through intake/resolve, the
typo self-correction, and this trail/commit without pausing to ask --
while still keeping the existing "execute inside a dispatched cycle,
resolve findings next cycle rather than ad hoc" law intact, since the two
are not in tension: autonomy changes whether Claude asks before acting,
not whether the colony's own process discipline still applies.
