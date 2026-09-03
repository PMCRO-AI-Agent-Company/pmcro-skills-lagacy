# Trail: cycle-20260903-035500-task-plugin-path-validation

trail_id: cycle-20260903-035500-task-plugin-path-validation
task_id: task-plugin-path-validation
domain:
priority: 3
opened: 2026-09-03
engine_generated: false

## Seed intent
Run directory/marketplace validation to confirm all plugin paths, marketplace entries, and command references resolve cleanly

## PlanFrame (Planner)
Three-part validation, each independently scriptable and re-runnable:
1. Root marketplace.json parses as valid JSON; every entry's `source`
   resolves to a real directory containing its own `plugin.json` (except
   the whole-project `pmcro-skills` entry, which has no plugin.json at
   its own root by design); each `plugin.json` itself parses.
2. Every plugin's internal relative references (`skills`, `agents`,
   `lspServers` fields in its `plugin.json`) resolve on disk.
3. The three new `.agents/commands/*.md` files' documented cross-refs
   (`run-queue.md` -> `engine/run-cycle.ps1`, `seed-intent.md` ->
   `orchestrate/SKILL.md`, `create-skill.md` -> `create-skill/SKILL.md`)
   resolve on disk.

## MakeFrame (Maker)
Wrote and ran three standalone PowerShell scripts (not inline one-liners,
for reliability) against the real filesystem, read results, then deleted
the scripts (temp artifacts, not deliverables):
1. Parsed marketplace.json, checked source+plugin.json for all 26
   entries -> 0 missing_source, 0 missing_plugin_json, 0 bad_plugin_json.
2. Iterated every plugin.json's skills/agents/lspServers arrays -> "ALL
   PLUGIN-INTERNAL REFS RESOLVE".
3. Checked the three command files' relative cross-refs -> "ALL COMMAND
   CROSS-REFS RESOLVE".

## CheckFrame (Checker)
Independently re-ran script 1's core check via a fresh separate
`start_process` call earlier in this session (ALL PATHS RESOLVE, 26
count) before this cycle formally opened; re-confirmed via this cycle's
own script output above, consistent both times. Reviewed script logic
itself for a checker-relevant edge case: the marketplace-registration
cycle's own root pmcro-skills entry has no plugin.json by design (it's a
whole-project registration, not a leaf plugin dir) -- explicitly excluded
from missing_plugin_json rather than silently passing, confirmed correct
by inspecting P:\agent-skills\projects\pmcro-skills\.claude-plugin\
plugin.json separately (skills/agents fields only, no plugin.json needed
at that exact source path since marketplace source points at the
project root which resolves fine as a directory).
verdict: pass
findings: none
blockers: none
recommendation: accept

## Reflection (Reflector)
Cycle accepted. Queue item `task-plugin-path-validation` set to `done`.
No earned constraint promoted -- validation passed cleanly on first run,
no recurring defect pattern observed to codify.
Next seed: remaining backlog is task-repo-cleanup [TYPE1, needs human
sign-off before any deletion], task-agent-memory-design,
task-dispatch-contract-design, task-restore-governance-docs,
task-align-workflows-aspire-structure [TYPE1-spirit, needs human
sign-off before file moves/CPM merge]. Of the three cleanly-executable
items (agent-memory-design, dispatch-contract-design,
restore-governance-docs), none blocks another, all priority 2. Human
requested "full autonomy continue" but also (this session) codified that
auto-run must use a small, non-unbounded cycle_count cap. Three cycles
run so far this "continue" instruction (marketplace-registration,
plugin-path-validation makes two since the retry-path-policy cycle
before it) -- stopping here to report back rather than silently running
an unbounded number of further cycles, consistent with the cap policy
just written into run-queue.md this same session. No priority-0
condition present; this is a self-imposed pause for the cap, not a stop
condition failure.
Lessons for future Planners: validation-only tasks are good candidates
for scripted, re-runnable checks rather than one-off manual inspection --
keep the scripts as temp artifacts (delete after use) unless the human
wants them retained as a permanent CI-style check.

trail_sealed: true
