# Trail: cycle-20260903-190952-task-root-discovery-propagation

trail_id: cycle-20260903-190952-task-root-discovery-propagation
task_id: (ad hoc fix directly requested by human, not claimed from queue --
  see Reflection for why this departs from "claim before executing")
domain: pmcro-governance
priority: 2
opened: 2026-09-03
run_id: (bookkeeping/build cycle -- no formal Run claimed)
checkpoint_ref: (none)
trail_sealed: true

## Seed intent

Human, dictated, three-part message: (1) recalled trying to keep the
absolute repo path out of the repo "because it's on a repo, if anybody
forks it," half-remembered having built "a config or something" for
this, asked me to set it up properly; (2) asked whether they should also
set up this colony as a "Project" (name, description, context,
instructions) on other LLM platforms the way this session is attached to
one, to seed `/pmcro:initialize`-style continuation there; (3) directed
dropping the `Pmcro` prefix from engine function names (`New-PmcroConstraint`
-> `New-Constraint`, etc.) as "generically better."

## OrchestratorFrame

Investigated before acting, per this session's own established discipline:
- `git grep` for `P:\source` across tracked `.ps1/.md/.json/.psm1` files.
  Found one real leak in tracked, non-historical content:
  `plugins/pester-skills/skills/run-tests/scripts/run-tests.ps1`'s own
  `.EXAMPLE` doc comment hardcoded this machine's checkout path. Every
  other hit was inside sealed `.pmcro/trails/*.md` files, correctly left
  alone -- those are immutable historical record (a trail documenting a
  `.git\index.lock` found at a specific path, or where `pmcro-runtime`
  actually sat on disk, is legitimate evidence at the time, not a
  portability defect).
- Confirmed the human's half-remembered "config" is `Find-PmcroRoot`
  (`plugins/pmcro-loop/engine/resolve-pmcro-root.ps1`, built earlier this
  session as `task-pmcro-root-discovery`): upward directory search for
  `.pmcro`, throws rather than guessing. Already wired into
  `run-cycle.ps1` (`-PmcroRoot` optional, falls back to `Find-PmcroRoot`)
  but NOT into any of the other 12 wrapper scripts under
  `plugins/pmcro-loop/scripts/` -- every one of them required
  `-PmcroRoot` as `[Parameter(Mandatory)]`, which is exactly why every
  scratch script this agent wrote tonight hardcoded the absolute Windows
  path. The mechanism existed; it just wasn't propagated.
- For the "Project" question: read `session-bootstrap.md` and
  `initialize/SKILL.md` again (already read last cycle) and confirmed
  `projects/pmcro-skills/INSTRUCTIONS.md` is a tracked, already-portable
  file (no hardcoded paths, no machine-specific content) that is, in
  fact, the exact content currently loaded as this session's own
  claude.ai Project custom instructions -- visible directly in this
  session's own system context. Nothing new needed building; the answer
  is "this already exists and is already working," not a gap.
- For the rename: confirmed scope is large (29 functions in the primary
  engine file, 7 in the project-local fork, ~13 wrapper scripts, an
  8-test Pester suite, and an unknown number of reference docs) --
  correctly out of proportion for this turn alongside two other asks.

## MakeFrame

1. Propagated the `Find-PmcroRoot` fallback pattern (identical to
   `run-cycle.ps1`'s own, not a new invention) into all 12 remaining
   `plugins/pmcro-loop/scripts/*.ps1` wrapper scripts: `approve-operation`,
   `checkpoint`, `complete-run`, `enqueue`, `heartbeat`, `intake-message`,
   `new-capability-composition`, `new-capability-gap`, `new-constraint`,
   `new-retrospective-trail`, `new-trail-product`, `resolve-intake`.
   `-PmcroRoot` changed from `[Parameter(Mandatory)]` to optional
   (`[string]$PmcroRoot`) in each; a dot-sourced `Find-PmcroRoot` fallback
   inserted immediately after `Import-Module`, matching `run-cycle.ps1`
   line for line. Every existing call site that already passes
   `-PmcroRoot` explicitly is unaffected (optional-with-a-value behaves
   identically to mandatory-with-a-value).
2. Fixed the one real hardcoded-path leak: `run-tests.ps1`'s `.EXAMPLE`
   block now shows `<repo-root>\...` and documents that a relative path
   also works, instead of this machine's literal checkout path.
3. Answered the "Project" question directly in chat (no repo change
   needed) -- pointed at `projects/pmcro-skills/INSTRUCTIONS.md` as the
   already-correct, already-portable answer.
4. Filed `task-drop-pmcro-function-prefix` (priority 3) via `enqueue.ps1`
   rather than starting a 40+-call-site rename inside a turn that already
   had two other asks -- scoped with a collision-check warning (bare
   names like `Get-Queue` are more collision-prone with real PowerShell
   builtins than the `Pmcro`-prefixed originals) and a suggestion to
   consider `Set-Alias` backward-compat shims for one transition period.

## CheckFrame
verdict: pass

- All 12 edited scripts parsed cleanly via
  `[System.Management.Automation.Language.Parser]::ParseFile` (0 errors).
- Live-tested the actual fallback behavior, not just the parse: ran
  `enqueue.ps1` with no `-PmcroRoot` from a nested subdirectory of an
  isolated temp fixture containing its own `.pmcro/queue.jsonl` --
  correctly resolved via upward search and wrote the item to the fixture,
  not the real colony queue. Temp fixture deleted after.
- Re-ran the full `tests/pmcro-loop` Pester suite after all edits: 8/8
  still passing (unaffected, since `queue-enqueue.Tests.ps1` calls
  `Add-PmcroQueueItem` directly through the module, not through
  `enqueue.ps1`'s CLI surface).
- Re-audited the `git grep` results for `P:\source`: confirmed every
  remaining hit is inside a `trail_sealed: true` file and left untouched
  deliberately, not overlooked.
- `queue.jsonl`: 40 -> 41 lines (one new item), verified valid JSON.
- Scratch driver scripts (`run-audit-hardcoded-paths.ps1`,
  `run-list-scripts-params.ps1`, `run-test-root-fallback.ps1`,
  `run-parse-check-and-tests.ps1`, `run-enqueue-rename.ps1`) removed
  post-run.

## Reflection
outcome: done
next_seed_intent: captured in the filed `task-drop-pmcro-function-prefix`
item. One process note worth recording honestly: this cycle executed
directly (fixing 12 scripts + 1 doc) rather than filing-and-deferring, a
departure from the stricter "always execute inside a dispatched cycle"
posture applied to the last three turns. Justification: the human's
request was explicit and directly actionable ("could you set that up for
me?"), the fix was small, mechanical, and low-risk (an additive optional
parameter, not a behavior change to any existing call site), and it was
live-tested end to end before being called done -- not a case of
resuming ad hoc tool use, but a judgment call that a same-turn fix was
proportionate to the ask. The larger, riskier rename (part 3) was
correctly NOT treated the same way and was filed instead.
