# Trail: cycle-20260902-221343-task-retry-path-policy

trail_id: cycle-20260902-221343-task-retry-path-policy
task_id: task-retry-path-policy
domain: 
priority: 2
opened: 2026-09-02
engine_generated: true

## Seed intent
Formalize that phase order is strictly Orchestrator -> Planner -> Maker -> Checker -> Reflector with no shortcuts or jumping around, including on failure: a CheckFrame fail must NOT loop directly back to Maker or Planner mid-cycle. Instead Checker reports fail -> Reflector converts the failure into a new seed intent (with failure context/RetryContext) -> cycle closes -> Orchestrator dispatches the NEXT cycle fresh to Planner. Update check-frame/SKILL.md ('Do not implement fixes -- Maker's job on a retry cycle' needs this clarified), reflect-and-seed/SKILL.md, and orchestrate/SKILL.md to state this explicitly; cross-reference from checker-role and reflector-role charters.

## PlanFrame (Planner)
Acceptance criteria:
1. `orchestrate/SKILL.md` must state a CheckFrame fail does not loop back mid-cycle to Maker/Planner — routes through Reflector into a fresh next-cycle dispatch.
2. `check-frame/SKILL.md`'s "Do not implement fixes" line must be clarified: fail hands off to Reflector, not directly back to Maker within the same cycle.
3. `reflect-and-seed/SKILL.md` must document converting a Checker fail into a new seed intent with RetryContext, closing (not reopening) the current cycle.
4. `checker-role` and `reflector-role` charters must cross-reference this retry-path policy.

## MakeFrame (Maker)
Edited 5 files via targeted find/replace (no scaffolding tool used — these
are behavioral corrections to existing skills, not new skills; per
`create-skill/SKILL.md`'s own "When Not to Use," direct edits were correct):
1. `.agents/skills/check-frame/SKILL.md` — added "Failure routing" section.
2. `.agents/skills/reflect-and-seed/SKILL.md` — added "Failure / retry path" section.
3. `.agents/skills/orchestrate/SKILL.md` — added "Failure path (strict phase order)" section.
4. `plugins/pmcro-checker/skills/checker-role/SKILL.md` — added cross-reference bullet under role contract.
5. `plugins/pmcro-reflector/skills/reflector-role/SKILL.md` — added cross-reference bullet under role contract.

## CheckFrame (Checker)
Independently re-read all 5 files post-edit. All 4 acceptance criteria
confirmed present and internally consistent; cross-references resolve to
the correct sibling skill sections; frontmatter (name/description)
untouched on all files; no TYPE1 mutation occurred (pure documentation
edits, no deletions).
verdict: pass
findings: none
blockers: none
recommendation: accept

## Reflection (Reflector)
Cycle accepted. Queue item `task-retry-path-policy` set to `done`.
No new earned-constraint file warranted — this cycle codified an
already-decided human policy into docs rather than surfacing a new
recurring failure pattern from observed runs.
Next seed: inspected queue for open backlog (7 open items remain:
task-agents-commands-scaffold, task-marketplace-registration,
task-plugin-path-validation, task-repo-cleanup [TYPE1],
task-agent-memory-design, task-dispatch-contract-design,
task-restore-governance-docs, task-align-workflows-aspire-structure
[TYPE1-spirit]) — backlog is not empty, so Orchestrator should claim the
next open item on the next cycle rather than idle. No priority-0
stop-the-line condition present.
Lessons for future Planners: when a PlanFrame targets only prose/doc
edits to existing SKILL.md files, do not route through create-skill —
its own "When Not to Use" section already says so; use direct edit_block
changes and note it explicitly in the MakeFrame to avoid tool confusion
mid-cycle (this happened once this cycle and was caught before executing).

trail_sealed: true