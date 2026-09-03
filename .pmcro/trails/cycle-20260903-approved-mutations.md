# Trail: cycle-20260903-approved-mutations

trail_id: cycle-20260903-approved-mutations
task_id: task-pmcro-loop-nested-supersession, task-marketplace-manifest-sync-21-entries, task-pmcro-root-discovery
domain: pmcro-governance
priority: 2
opened: 2026-09-03

## Seed intent
Human gave "full approval" in direct response to a message naming four
specific gated items: (1) nested supersession, (2) marketplace sync,
(3) task-repo-cleanup reconciliation, (4) PROJECT_ROOT discovery. This
trail covers items 1, 2, 4 (executed) and item 3 (investigated, NOT closed
— see Reflection).

## MakeFrame (Maker)
1. **Nested supersession**: `git rm -r projects/pmcro-skills/plugins/pmcro-loop`
   (21 tracked files across 5 role-skill folders + plugin.json). Confirmed
   via CHECK in cycle-20260903-governance-merge that every unique item in
   that tree was already migrated to canonical plugins/pmcro-loop; the one
   engine duplicate was already known to be a one-blank-line diff. Git-
   tracked and clean before removal, so recoverable via
   `git checkout HEAD -- projects/pmcro-skills/plugins/pmcro-loop` if ever
   needed.
2. **Marketplace sync**: replaced `plugins[]` array in both
   `.agents/plugins/marketplace.json` and `.cursor-plugin/marketplace.json`
   with the 21-entry array from `.claude-plugin/marketplace.json` (adds the
   16 `dotnet-*` entries), preserving each file's own name/owner/interface
   header.
3. **PROJECT_ROOT discovery**: added
   `plugins/pmcro-loop/engine/resolve-pmcro-root.ps1` (`Find-PmcroRoot`,
   upward search for `.pmcro`, throws rather than defaulting). Made
   `run-cycle.ps1`'s `-PmcroRoot` optional; falls back to `Find-PmcroRoot`
   when omitted. No existing call site broken (parameter was previously
   Mandatory; now optional with an explicit fallback path).
4. **task-repo-cleanup investigation**: searched `git log --all` for any
   trace of `_pmcro-duplicate-backup-20260902` (add or otherwise) — none
   found, in any branch. No `.gitignore` entry for it either. Searched all
   sealed trails for the string "duplicate-backup" — the only hit is the
   seed_intent text of task-repo-cleanup itself; no trail records the
   folder being created or removed. Confirmed (again) it is absent from
   disk today.

## CheckFrame (Checker)
Verdict: **pass** for items 1–3; item 4 is evidence-gathering only (no
mutation), verdict n/a.

- `git status --short` post-mutation shows exactly: 21 `D` lines under the
  nested pmcro-loop path, 2 `M` marketplace files, 1 `M` run-cycle.ps1,
  1 new untracked resolve-pmcro-root.ps1. No unexpected file touched.
- Marketplace diff check: both synced files now contain all 21 plugin
  entries in the same order as `.claude-plugin/marketplace.json`; each
  file's own top-level `name`/`owner`/`interface` block is untouched
  (verified by inspecting the unmodified prefix before the edit region).
- run-cycle.ps1: `-PmcroRoot` changed from `[Parameter(Mandatory)]` to a
  plain optional param with an explicit fallback call to `Find-PmcroRoot`;
  existing callers that pass `-PmcroRoot` explicitly are unaffected.
- Nested deletion: used `git rm`, not a raw filesystem delete, so the
  index and working tree stay consistent and the change is a normal,
  revertible git operation pending commit.

## Reflection (Reflector)
- task-pmcro-loop-nested-supersession -> done.
- task-marketplace-manifest-sync-21-entries -> done.
- task-pmcro-root-discovery -> done.
- **task-repo-cleanup: NOT closed.** Evidence found is purely negative
  (folder absent, no git history, no gitignore rule, no trail record of an
  actual removal). That is consistent with either "a real cleanup already
  happened outside git tracking" or "the folder never existed and the
  original seed intent was already moot." I cannot distinguish those from
  the filesystem/git alone, and the human explicitly warned against closing
  on absence alone. Left as `claimed`; recommend the human simply confirm
  by memory whether they manually removed that folder, so this can close
  on real evidence rather than an inference.
- Nothing committed or pushed — these are working-tree/staged changes only.

trail_sealed: true
