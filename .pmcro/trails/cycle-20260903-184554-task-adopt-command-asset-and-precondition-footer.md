# Trail: cycle-20260903-184554-task-adopt-command-asset-and-precondition-footer

trail_id: cycle-20260903-184554-task-adopt-command-asset-and-precondition-footer
task_id: task-adopt-command-asset-and-precondition-footer
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: (filing only -- no build performed this cycle)
checkpoint_ref: (none)
trail_sealed: true

## Seed intent

Human instruction: "wait be cause I may need the idea that theres somthing
ai call "skill command" that ghas command in the skill look in
https://github.com/PMCRO-AI-Agent-Company/pmcro-skills_archive.git and tell
me is that type skill structre bettert" -- investigate the archived sibling
repo's skill structure and assess whether it's better than the live
convention.

## OrchestratorFrame

Used `inspect-repo.ps1 -File` (this session's own just-built extension,
see cycle-20260903-151348-task-github-skills-plugin) against
`PMCRO-AI-Agent-Company/pmcro-skills_archive` rather than reaching for `gh
api` ad hoc. Read the archive's `skill-creator`/`create-skill` skill and a
sample command-bearing skill in full.

Findings:
- Asset naming convention: `<type>.<qualifier>.asset.md`.
- A "command surface" on a skill = three coordinated assets:
  `command.<name>.asset.md` (formal spec: Purpose / Invocation /
  Parameters table / Result Contract / Related Schema), `run.<name>
  .asset.md` (accept-path implementation), `reject.<name>.asset.md`
  (explicit refusal-path implementation).
- Every skill, command-bearing or not, ends with two mandatory footer
  sections: `## L-PLUGIN-ISOLATION Precondition` (refuse and escalate if
  no active Binding Envelope / open PMCR-O cycle exists) and `## PMCRO
  Output Law` (must return a structured envelope --
  frame_id/trail_id/workflow_id/action/state_transition/
  required_evidence/next_gate/halt_reason -- schema-validated against
  `output-contract.schema.json`, never bare prose).

Assessment given to the human: not a wholesale "better structure" --
selectively worth adopting. The run/reject/command-asset triad is a real,
mechanically-checkable improvement (a skill can currently claim behavior
in prose that nothing actually implements; this pattern makes that
checkable). The precondition footer is also worth adopting on its own
merits -- if `skill-structure.md` already required it, several of this
session's own ad hoc-execution slips (raw `git commit`, mid-build
`.csproj` edits, ad hoc `Install-Module`/`Invoke-Pester`) would have been
structurally harder to fall into by accident, independent of the archive
comparison. The full structured Output Contract envelope
(state_transition/required_evidence/next_gate/halt_reason,
schema-validated) was NOT recommended for adoption as-is: it presumes
runtime machinery (Binding Envelope, `L-EVIDENCE`, `L-CHECKER-GATE`, a
JSON-schema validator wired into the loop) this repo does not have, and
the archive repo's own state suggests this may have been more
scaffolded-as-intent than mechanically enforced end-to-end there either.

Offered to file as a queued item or build now. Human's first reply ("yes")
was ambiguous between the two; disambiguated via AskUserQuestion --
**answer: "File it as a queued item (recommended)."**

## MakeFrame

Filed `task-adopt-command-asset-and-precondition-footer` via the real
`enqueue.ps1` (`plugins/pmcro-loop/scripts/enqueue.ps1`, the same
`Add-PmcroQueueItem`-backed script built and tested earlier this session
for the queue-enqueue skill fix) rather than hand-writing JSONL --
deliberately consistent with this session's own newly-active
`rule-policy-20260903-182600-external-tool-use-must-be-scripted.md`.
`queue.jsonl` now has 37 lines; new item confirmed appended via
`Get-Content -Tail 1`, `status: open`, `blocked_by: []`.

No skill-structure.md or check-skill-shape.ps1 changes made this cycle --
scoped as filing only, per the human's chosen answer.

## CheckFrame
verdict: pass

- `queue.jsonl` line count went 36 -> 37; tail line parses as valid JSON
  with the expected `id`, `priority: 3`, `domain: pmcro-governance`,
  `status: open`, `created_by: human`, `created_at` populated.
- No duplicate id (script's own `Add-PmcroQueueItem` duplicate-id guard
  would have thrown otherwise; it did not throw).
- Scratch driver script (`run-enqueue-command-pattern.ps1`, repo root)
  removed post-run -- not part of any tracked directory convention.

## Reflection
outcome: done
next_seed_intent: (captured in the filed queue item's own seed_intent,
not duplicated here). Scope for whoever claims
`task-adopt-command-asset-and-precondition-footer`: extend
`skill-structure.md`'s Required baseline with the run/reject/
command-asset triad and the precondition-footer requirement; extend
`check-skill-shape.ps1` to validate both mechanically; apply the pattern
to `approve-operation` as a worked example (already has genuine TYPE1
approve/deny/needs-human-approval semantics); live-test via
`pester-skills/run-tests`, not just parse.
