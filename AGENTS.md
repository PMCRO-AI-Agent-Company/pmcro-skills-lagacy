# Repository instructions

This repo is an Agent Skills plugin marketplace plus reusable project and
repository-authoring templates. Treat marketplace manifests as registries
and generated project templates as the source for new instances.

**Before editing:**
1. Read this file and the relevant README.
2. Inspect the target plugin/skill structure before changing it.
3. Check git status and preserve unrelated user changes.

## Working on skills, plugins, and projects

Use `.agents/skills/create-skill/SKILL.md` for individual skill creation,
`.agents/skills/create-custom-agent/SKILL.md` for agent personas, and the installed
`plugins/agentskills/skills/create-project/SKILL.md` for whole-project generation.

Plugin skills use `SKILL.md` plus `assets/`, `references/`, and `scripts/` when
those support materials are required by the capability.

## Namespace distinction (short names collide, addresses do not)

Two different capability namespaces both expose skills named `create-skill` and
`create-custom-agent`. Discovery must never key on short skill name alone —
always resolve the full address:

- `.agents/skills/<name>` — session/repository tooling scoped to this repo's own
  agent workspace (e.g. `.agents/skills/create-skill`, `.agents/skills/create-custom-agent`).
  Not PMCR-O governed; no TYPE1 approval gating.
- `/pmcro-skills:<name>` — PMCR-O-governed marketplace capabilities from the
  `pmcro-skills` plugin (e.g. `/pmcro-skills:create-skill`, `/pmcro-skills:create-custom-agent`).
  Subject to the Orchestrator/approval model in `plugins/pmcro-loop`.

Same short name, different scope and governance. Resolve by full address before
treating two same-named skills as duplicates or interchangeable.

## Conventions

- Keep marketplace manifests synchronized.
- Keep plugin manifest copies synchronized according to the active convention.
- Never hardcode a machine-specific drive letter into committed content.
- Keep project templates separate from repository session tooling.
- Preserve existing architecture; make the smallest verified change.
- Generation must never silently overwrite user content.

## PMCR-O project conventions

The content below governed the standalone `projects/pmcro-skills/` colony
before its 2026-09-03 consolidation into this true repo root (see
`.pmcro/repo-topology.md`). It still describes how this repo runs its own
PMCR-O cycles now that the colony state lives at the true root.

### Architecture
- `.pmcro/` is runtime governance and authoritative execution state.
- `.agents/agents/` contains subagent identities and contracts.
- `.agents/agents-memory/<agent>/MEMORY.md` contains persistent agent working memory.
- `.pmcro/trails/` contains sealed historical execution evidence.
- `.pmcro/constraints/` contains earned authoritative constraints.

### Skill invocation
- The canonical public selector for every skill in `.agents/skills/` is `/pmcro-skills:<skill-name> [optional arguments]`.
- `<skill-name>` MUST match the skill directory and SKILL.md frontmatter `name`.
- Agents must use the namespaced selector when explicitly invoking a pmcro-skills skill; never use an unqualified `/skill-name` form.
- Cross-plugin skills retain their own namespace, e.g. `/pmcro-loop:<skill-name>`.
- See `.agents/references/invocation.md` for the complete invocation and resolution contract.

### Lifecycle
- Orchestrator dispatches one shared queue.
- Planner produces PlanFrame; Maker executes; Checker independently verifies; Reflector closes the cycle.
- Memorykeeper supplies advisory continuity context and is not a lifecycle phase.
- Trailkeeper preserves trail provenance and is not a second queue or decision-maker.

### Memory
- Each active agent has a dedicated memory container with `MEMORY.md` as its index.
- Memory is advisory and may be stale; current evidence and governance always win.
- Additional topic files may live beside `MEMORY.md` and are read on demand.
- Memory must never rewrite sealed trails or silently become colony law.

### Execution architecture
- This repository defines governance, contracts, skills, and state boundaries; it does not implement a second PMCR-O orchestration loop.
- PMCR-O execution is owned by the runtime through the declarative workflow substrate (MAF/Aspire/MCP/HIL).
- `engine/run-cycle.ps1` is deterministic queue/trail allocation support only; it never replaces the declarative workflow or performs reasoning.
- `.agents/workflows/` is the local workflow catalog/documentation boundary. Canonical executable declarative workflows belong to the runtime execution host.

### Commands
- Build/test: `dotnet test AgentSkills.slnx`
- Deterministic queue/trail support: `engine/run-cycle.ps1 -PmcroRoot .pmcro`

### Mutation
- TYPE1 mutations require explicit recorded human approval unless bounded autonomous authority already applies.
- Destructive deletion, secrets, security bypasses, and irreversible external actions require separate approval.
