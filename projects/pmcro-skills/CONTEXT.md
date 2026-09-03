# CONTEXT.md — pmcro-skills

Meta-governance skill repo for PMCR-O. The repository owns colony laws,
trail conventions, agent contracts, persistent role memory, loop mechanics,
and cross-repo governance references.

## Architecture

- `.pmcro/` — authoritative runtime governance and execution continuity.
- `.agents/agents/` — agent identity and operating contracts.
- `.agents/agents-memory/<agent>/MEMORY.md` — persistent, advisory role memory.
- `.agents/skills/` — reusable procedural mechanics.
- `.agents/commands/` — explicit human/agent entry points.
- `plugins/pmcro-loop/` — one cohesive lifecycle plugin.
- `engine/` — deterministic queue/trail allocation runtime; never performs reasoning.

## Runtime state

`.pmcro/queue.jsonl` is the single shared backlog. `.pmcro/session-state.md`
is the cross-session continuity pointer. `.pmcro/trails/` contains sealed
historical evidence. `.pmcro/constraints/` contains earned constraints
promoted through the governed reflection process.

## Role topology

Orchestrator, Planner, Maker, Checker, and Reflector form the strict
Plan → Make → Check → Reflect lifecycle. Trailkeeper preserves historical
continuity and provenance without becoming a sixth lifecycle phase.
Memorykeeper retrieves bounded advisory context and is not a lifecycle phase.

## Memory separation

Identity answers who an agent is. Persistent memory records what that role has
learned and may be stale. `.pmcro/` records what the colony currently treats
as authoritative. Memory never rewrites trails, silently becomes law, or
substitutes for current evidence.

## Governance

`colony-laws.md` remains the authoritative cross-repo law. It is intentionally
kept at repository root rather than duplicated into runtime constraints.
`docs/architecture-governance.md` governs structural reconciliation and
validation evidence. Legacy split role-plugin packages (5 separate
`pmcro-{role}` plugins) are archived under `docs/legacy/role-plugins/`.

## Plugin registration (monorepo-wide)

The live marketplace manifest is `P:\agent-skills\.claude-plugin\marketplace.json`
at the **agent-skills monorepo root**, not inside this project. This project's
own `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`
are stale local copies and are not what Claude Code actually reads.

The canonical `pmcro-loop` lifecycle plugin (7 skills: `orchestrate`,
`plan-frame`, `make-frame`, `check-frame`, `reflect-and-seed`, `queue-claim`,
`queue-enqueue`) lives at `P:\agent-skills\plugins\pmcro-loop\` — a top-level
monorepo plugin, sibling to `agentskills` and `agent-design-patterns` — and is
registered there, not under `projects/pmcro-skills/plugins/`.

`projects/pmcro-skills/plugins/pmcro-loop/` (role-named skills:
`orchestrator-role`, `planner-role`, `maker-role`, `checker-role`,
`reflector-role`) is an **orphaned duplicate**, not referenced by the live
marketplace.json. It overlaps with the TYPE1-gated `task-repo-cleanup` queue
item and should not be assumed current without checking that item's
resolution first.
