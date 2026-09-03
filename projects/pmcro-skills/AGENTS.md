# PMCR-O Skills Project Conventions

## Architecture
- `.pmcro/` is runtime governance and authoritative execution state.
- `.agents/agents/` contains subagent identities and contracts.
- `.agents/agents-memory/<agent>/MEMORY.md` contains persistent agent working memory.
- `.pmcro/trails/` contains sealed historical execution evidence.
- `.pmcro/constraints/` contains earned authoritative constraints.

## Lifecycle
- Orchestrator dispatches one shared queue.
- Planner produces PlanFrame; Maker executes; Checker independently verifies; Reflector closes the cycle.
- Memorykeeper supplies advisory continuity context and is not a lifecycle phase.
- Trailkeeper preserves trail provenance and is not a second queue or decision-maker.

## Memory
- Each active agent has a dedicated memory container with `MEMORY.md` as its index.
- Memory is advisory and may be stale; current evidence and governance always win.
- Additional topic files may live beside `MEMORY.md` and are read on demand.
- Memory must never rewrite sealed trails or silently become colony law.

## Execution architecture
- This repository defines governance, contracts, skills, and state boundaries; it does not implement a second PMCR-O orchestration loop.
- PMCR-O execution is owned by the runtime through the declarative workflow substrate (MAF/Aspire/MCP/HIL).
- `engine/run-cycle.ps1` is deterministic queue/trail allocation support only; it never replaces the declarative workflow or performs reasoning.
- `.agents/workflows/` is the local workflow catalog/documentation boundary. Canonical executable declarative workflows belong to the runtime execution host.

## Commands
- Build/test: `dotnet test AgentSkills.slnx`
- Deterministic queue/trail support: `engine/run-cycle.ps1 -PmcroRoot .pmcro`

## Mutation
- TYPE1 mutations require explicit recorded human approval unless bounded autonomous authority already applies.
- Destructive deletion, secrets, security bypasses, and irreversible external actions require separate approval.