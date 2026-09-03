# CONTEXT.md — pmcro-skills

Meta-governance skill repo for PMCR-O. The repository owns colony laws,
trail conventions, agent contracts, persistent role memory, loop mechanics,
and cross-repo governance references.

As of 2026-09-03, this content and the `.pmcro/` runtime state it
describes live at the **true repo root** (`P:\source\pmcro-skills`) — not
under a nested `projects/pmcro-skills/` subfolder, and not under any
separate `P:\agent-skills` path. Those were consolidated into this repo
in a single migration; see `.pmcro/repo-topology.md` for the authoritative
current directory map and `.pmcro/trails/` for the migration's sealed
trail. Any reference elsewhere in this repo to `projects/pmcro-skills/`
or `P:\agent-skills` predates that consolidation and describes a topology
that no longer exists.

## Architecture

- `.pmcro/` — authoritative runtime governance and execution continuity.
- `.agents/agents/` — agent identity and operating contracts.
- `.agents/agents-memory/<agent>/MEMORY.md` — persistent, advisory role memory.
- `.agents/skills/` — reusable procedural mechanics, namespaced `/pmcro-skills:<name>`.
- `.agents/commands/` — explicit human/agent entry points.
- `plugins/pmcro-loop/` — one cohesive lifecycle plugin.
- `plugins/pmcro/` — semantic model, lifecycle, and packaging/projection capabilities.
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

`laws.md` remains the authoritative cross-repo law. It lives at this
repo's true root (not duplicated into runtime constraints). `AGENTS.md` at
the true root carries both the marketplace-wide repository conventions and
(in its "PMCR-O project conventions" section) this project's own operating
rules — the split exists because those conventions predate the consolidation
and were merged rather than discarded. `docs/architecture-governance.md`
governs structural reconciliation and validation evidence. Legacy split
role-plugin packages (5 separate `pmcro-{role}` plugins) are archived under
`docs/legacy/role-plugins/`.

## Plugin registration

The live marketplace manifest is `.claude-plugin/marketplace.json` at this
repo's true root — registered marketplace name `agent-skills`. `.agents/plugins/marketplace.json`
and `.cursor-plugin/marketplace.json` are kept as synchronized copies per this
repo's multi-runtime plugin-manifest convention (see `AGENTS.md`'s
Conventions section) — keep them in sync when the canonical one changes,
don't treat them as independently authoritative.

The `pmcro-loop` lifecycle plugin (skills: `orchestrate`, `plan-frame`,
`make-frame`, `check-frame`, `reflect-and-seed`, `queue-claim`,
`queue-enqueue`) lives at `plugins/pmcro-loop/`, a top-level plugin sibling
to `plugins/pmcro-skill-creator` and `plugins/agent-design-patterns`, and is
registered in the marketplace manifests above. There is no longer a nested
`projects/pmcro-skills/plugins/pmcro-loop/` duplicate — the orphaned
role-named copy that once existed there (`orchestrator-role`,
`planner-role`, `maker-role`, `checker-role`, `reflector-role`) was already
removed before this consolidation and does not need separate cleanup.
