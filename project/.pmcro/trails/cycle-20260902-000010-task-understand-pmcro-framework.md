# Trail: cycle-20260902-000010-task-understand-pmcro-framework

trail_id: cycle-20260902-000010-task-understand-pmcro-framework
task_id: task-understand-pmcro-framework
domain: null
priority: 3
opened: 2026-09-02
engine_generated: false

## Seed intent
Read and build a working understanding of the PMCR-O framework as implemented
in P:/agent-skills (marketplace structure, pmcro-loop plugin: agents, skills,
deterministic engine; colony queue/trail/constraint mechanics) and produce a
durable framework-understanding artifact.

## PlanFrame (Planner)

goal: Build and document an accurate, disk-verified understanding of the
PMCR-O framework as implemented in P:/agent-skills.

steps:
1. (Orchestrator) Enumerate marketplace + plugin manifests.
2. (Maker) Read pmcro-loop agents/*.md, skills/*/SKILL.md, engine/*.
3. (Maker) Read colony state: session-state.md, queue.jsonl, queue.schema.md,
   constraints/.
4. (Maker) Survey sibling plugins (agentskills, agentskills-template-engine,
   agent-design-patterns) structurally for context.
5. (Maker) Read project-level conventions (repo AGENTS.md, project/AGENTS.md,
   project/.mcp.json, LAYOUTS.md).
6. (Checker) Cross-check the implemented trail schema here against the
   GUID-folder + per-phase-JSONL + disposition.json schema on file from prior
   sessions (a different project) and flag any mismatch explicitly.
7. (Reflector) Produce the framework-understanding artifact and seal the trail.

acceptance_criteria:
- All 5 pmcro-loop agent role files and 7 skill files accounted for.
- Deterministic-engine vs LLM-reasoning boundary correctly characterized
  (PmcroEngine.psm1 / run-cycle.ps1 make zero model calls).
- Colony queue/session-state/trail conventions characterized from files
  actually read on disk, not assumed from memory.
- Any discrepancy between this repo's trail schema and other stated
  conventions is explicitly surfaced, not silently reconciled.
- Cycle closes with a trail sealed per *this repo's own* engine convention.

constraints:
- Do not fabricate framework details absent from the files.
- Do not silently overwrite queue.jsonl/session-state.md history.
- Follow this repo's own trail convention (single sealed .md, not
  GUID+JSONL) since that is what is actually implemented here.
- Never invent queue priority.

risks:
- P:/agent-skills (marketplace repo) and the separate pmcro-runtime /
  pmcro-agent-system (.NET runtime) repo may have diverging trail
  conventions; risk of conflating the two.
- agentskills, agent-design-patterns, and agentskills-template-engine
  plugins were surveyed structurally only, not read skill-by-skill.

domain: null

## MakeFrame (Maker)

artifacts:
- Read in full: plugins/pmcro-loop/agents/{orchestrator,planner,maker,checker,
  reflector}.md; plugins/pmcro-loop/skills/{orchestrate,plan-frame,make-frame,
  check-frame,reflect-and-seed,queue-claim,queue-enqueue}/SKILL.md;
  plugins/pmcro-loop/engine/PmcroEngine.psm1; engine/run-cycle.ps1;
  plugins/pmcro-loop/plugin.json + version.json + .claude-plugin/plugin.json.
- Read: .claude-plugin/marketplace.json, AGENTS.md, LAYOUTS.md,
  project/AGENTS.md, project/.mcp.json, project/.pmcro/{session-state.md,
  queue.jsonl,queue.schema.md}.
- Surveyed directory structure (depth 2-3) of plugins/agentskills,
  plugins/agentskills-template-engine, plugins/agent-design-patterns,
  .agents/, tests/, _tmp_existing_pmcro_runtime/.

findings:
- Marketplace = "agent-skills", 4 plugins: agentskills, agentskills-
  template-engine, agent-design-patterns, pmcro-loop.
- pmcro-loop v0.1.0 is the canonical PMCR-O loop: 5 agent personas
  (Orchestrator/Planner/Maker/Checker/Reflector), 7 skills (orchestrate,
  queue-claim, queue-enqueue, plan-frame, make-frame, check-frame,
  reflect-and-seed), one PowerShell engine module.
- Engine (PmcroEngine.psm1 + run-cycle.ps1) is explicitly non-LLM: it only
  does session-state read/write, queue read/write/claim, and trail-skeleton
  allocation. It writes PENDING placeholders for Plan/Make/Check/Reflect and
  literally stops ("STOP: Plan/Make/Check/Reflect require model reasoning").
  This is a clean, deliberate split between deterministic file mechanics and
  LLM reasoning.
- Trail convention actually implemented here: ONE markdown file per cycle at
  .pmcro/trails/cycle-<yyyyMMdd-HHmmss>-<task_id>.md, with '## PlanFrame' /
  '## MakeFrame' / '## CheckFrame' / '## Reflection' sections and a
  trail_sealed: true|false flag. This is NOT a GUID folder with per-phase
  JSONL files + disposition.json.
- DISCREPANCY FLAGGED: my prior session memory records the sealed-trail
  standard as "GUID folder + per-phase JSONL + disposition.json" — that
  matches a different, separate project (pmcro-agent-system / pmcro-runtime,
  the .NET/MAF runtime under C:\...\ShawnDelaineBellazanLoop and Z:\). It
  does not match what plugins/pmcro-loop/engine actually implements in THIS
  repo (P:/agent-skills). Both are legitimate but distinct trail schemas for
  two different PMCR-O implementations; they should not be conflated.
- Colony queue is a single shared backlog at .pmcro/queue.jsonl (schema:
  id/priority/domain/status/seed_intent/blocked_by/created_by/created_at,
  optional claimed_at/claimed_by). Priority 0-4, ascending = higher priority.
  Orchestrator never invents priority; only reflector/CEO/CoS/human set it.
- session-state.md is flat key:value markdown (status, seed_intent, task_id,
  domain, priority, last_cycle_id, notes) — the single source of truth for
  whether the Orchestrator is idle or active.
- .pmcro/constraints/ is empty (.gitkeep only) — no earned constraints yet
  recorded in this repo instance.
- Repo-level AGENTS.md frames this whole repo as "an Agent Skills plugin
  marketplace plus reusable project and repository-authoring templates" —
  i.e. pmcro-loop is one of several installable capability plugins, not the
  whole repo's purpose.
- project/ is a generated project template (LAYOUTS.md is the source of
  truth for the project/.agents/ and skill-folder shape); project/.pmcro/ is
  the live colony state for whatever project is instantiated from this
  template — in this case it's being used directly as the working colony.
- _tmp_existing_pmcro_runtime/ is a working copy of the separate .NET
  runtime repo (architecture/, capabilities/, contracts/, policies/,
  registry/, skills/) staged inside this repo, presumably for cherry-picking
  per the "old prototype, don't replace canonical repo" note on file.

status: success

## CheckFrame (Checker)

verdict: pass

criterion-by-criterion:
- All 5 agent files + 7 skill files accounted for: PASS — all 5 agent .md
  files and 7 skill dirs listed under plugins/pmcro-loop were opened and
  read in full (not sampled).
- Deterministic/LLM boundary correctly characterized: PASS — verified
  directly from PmcroEngine.psm1 doc comments and run-cycle.ps1's explicit
  STOP/exit before any Plan/Make/Check/Reflect content.
- Colony conventions from disk, not memory: PASS — session-state.md,
  queue.jsonl, queue.schema.md all read verbatim before this trail asserted
  anything about them.
- Discrepancy explicitly surfaced: PASS — the GUID+JSONL vs single-.md
  trail schema mismatch is called out by name in MakeFrame above, not
  quietly reconciled or averaged into one description.
- Trail sealed per this repo's own convention: PENDING until Reflector
  writes trail_sealed: true below (this Checker does not seal trails).

findings: none blocking.
blockers: none.
minor: agentskills / agent-design-patterns / agentskills-template-engine
  plugins were only surveyed at directory-listing depth, not read
  skill-by-skill — acceptable for this seed intent (framework, i.e.
  pmcro-loop, understanding) but flagged as a real gap if a future seed
  needs those plugins' internals.

recommendation: accept

## Reflection (Reflector)

outcome: Cycle succeeded. Framework understanding artifact produced (see
MakeFrame findings above; summarized for the human in-chat).

earned_constraints:
- Wrote .pmcro/constraints/ec-trail-schema-scope.md (proposed) — this
  repo's trail schema (single sealed .md) is distinct from the
  pmcro-agent-system/.NET runtime's GUID+JSONL schema; don't conflate them.

queue_item: task-understand-pmcro-framework -> status: done

next_seed: none — no follow-up work item is implied by a pure
  understanding/documentation task. Session returns to idle.

lessons_for_future_planners:
- This repo's colony queue was empty and session-state idle at cycle start;
  this cycle's seed came from direct human handoff (permitted per
  orchestrate's "or a human hands off an intent"), and was enqueued first
  (created_by: human) before being claimed, so the queue remains the single
  source of truth rather than bypassing it.
- .pmcro/constraints/ was empty before this cycle; ec-trail-schema-scope.md
  is the first earned constraint recorded in this repo instance.

trail_sealed: true
disposition: ACCEPT
