# Trail: cycle-20260903-033000-task-agents-commands-scaffold

trail_id: cycle-20260903-033000-task-agents-commands-scaffold
task_id: task-agents-commands-scaffold
domain:
priority: 2
opened: 2026-09-03
engine_generated: false

## Seed intent
Create three commands under .agents/commands/: (1) seed-intent.md -- captures a NEW raw intent, enqueues it (created_by: human), dispatches to Planner; (2) run-queue.md -- runs queued items by invoking the existing deterministic engine/run-cycle.ps1 -PmcroRoot .pmcro (claim + trail skeleton) then continuing as Orchestrator through Plan/Make/Check/Reflect; accepts an optional cycle_count arg (or 'until queue empty') to auto-advance multiple cycles without a human confirming between each -- TYPE1 mutations inside any cycle still individually require human approval regardless of auto-run mode, and cycle_count must default to a small sane cap (not unbounded) since each cycle is real billed model usage, not free; (3) create-skill.md (renamed from createskill per human correction) -- invokes/wraps the existing .agents/skills/create-skill/SKILL.md mechanic, not a duplicate.

## PlanFrame (Planner)
No existing repo convention dictates a command-file format (`.agents/README.md`
states these are read by an agent as instructions, not auto-discovered as
native slash commands). Assumption: adopt YAML frontmatter (`name`,
`description`) matching this repo's own `SKILL.md` convention, plus a
Purpose/Args/Steps/Validation body. Acceptance criteria:
1. `.agents/commands/seed-intent.md` — enqueues a NEW raw intent
   (`created_by: human`, honest priority) before any action, then hands
   off to `orchestrate` for Planner dispatch; never acts on the intent
   directly.
2. `.agents/commands/run-queue.md` — wraps `engine/run-cycle.ps1` for the
   deterministic claim/trail step, then continues as Orchestrator through
   Plan/Make/Check/Reflect; supports `cycle_count` (small default cap,
   not unbounded) or `until_queue_empty`; states plainly that TYPE1
   mutations remain individually gated inside every cycle regardless of
   auto-run mode.
3. `.agents/commands/create-skill.md` — thin wrapper delegating to the
   existing `.agents/skills/create-skill/SKILL.md` mechanic; must not
   duplicate its scaffolding logic; filename corrected to hyphenated
   `create-skill` per human's explicit correction (not `createskill`).

## MakeFrame (Maker)
Created three files under `.agents/commands/` (directory previously held
only `.gitkeep`, confirmed via `list_directory` before writing — no prior
`createskill.md` existed to rename/delete):
1. `seed-intent.md` — enqueue-then-dispatch, explicit anti-bypass step.
2. `run-queue.md` — `cycle_count` defaults to 1 (not unbounded);
   `until_queue_empty` still internally capped; explicit TYPE1
   gate-preservation statement; stop condition mirrors
   `reflect-and-seed`'s priority-0 rule.
3. `create-skill.md` — delegates fully to the existing mechanic; carries
   forward its own "When Not to Use" boundary (small behavioral
   corrections go to direct edits, as was correctly done earlier this
   session for the retry-path-policy cycle).

## CheckFrame (Checker)
Independently re-read all three files post-write via
`read_multiple_files` (not trusting the write-tool echo). Verified: all
3 files present, no stray `createskill.md`, relative path in
`run-queue.md` (`../../engine/run-cycle.ps1`) resolves correctly from
`.agents/commands/` to repo-root `engine/`, no hardcoded drive-letter or
absolute paths (W-PORTABILITY-001 clean), each frontmatter has both
`name` and `description` stating what/when.
verdict: pass
findings: none
blockers: none
recommendation: accept

## Reflection (Reflector)
Cycle accepted. Queue item `task-agents-commands-scaffold` set to `done`.
No new earned constraint — command-file format was a stated Planner
assumption (documented above) rather than a recurring failure pattern;
promoting it as a durable colony constraint is premature until another
command is authored and the convention either holds or needs revision.
Next seed: backlog still open (6 items: task-marketplace-registration,
task-plugin-path-validation [still blocked on this + marketplace],
task-repo-cleanup [TYPE1], task-agent-memory-design,
task-dispatch-contract-design, task-restore-governance-docs,
task-align-workflows-aspire-structure [TYPE1-spirit]). No priority-0
condition. Recommend next claim: `task-marketplace-registration`
(priority 2, unblocked) — `task-plugin-path-validation` remains blocked
until that lands too.
Lessons for future Planners: when no in-repo convention exists for a new
artifact type, state the assumption explicitly in the PlanFrame itself
(not just in the Maker's head) so Checker can verify against a stated
criterion rather than an implicit one.

trail_sealed: true
