# .agents/

Repository-local agent instruction, skill, command, memory, rule, and workflow
catalog. It is consumed by agents and by the deterministic mechanics under
`../engine/`; it is not itself a second PMCR-O workflow runtime.

Executable PMCR-O orchestration is owned by the runtime through the declarative
workflow substrate. This repository supplies the governance, contracts, and
mechanics that the runtime must honor.

## Layout

| Directory | Purpose |
|---|---|
| `agents/` | PMCR-O persona definitions: Orchestrator, Planner, Maker, Checker, Reflector, Trailkeeper |
| `agents-memory/` | Per-agent persistent working memory |
| `commands/` | Slash-command definitions |
| `output-styles/` | Output/response style presets |
| `rules/` | Path-scoped conventions, including TYPE1 approval |
| `skills/` | Reusable Agent Skills and PMCR-O cycle mechanics |
| `workflows/` | Multi-step orchestrated workflows |

## Lifecycle responsibility

The governed lifecycle remains Orchestrator → Planner → Maker → Checker →
Reflector → Seal. The runtime expresses this lifecycle through the declarative
workflow; this repository does not implement a competing orchestration loop.
Trailkeeper is an adjacent continuity role, not a sixth phase or second
orchestrator.

Trailkeeper preserves cognitive trail history, lifecycle transitions, evidence
provenance, and cross-cycle continuity. Reflector still owns cycle disposition,
next-seed decisions, and queue follow-ups. Checker still owns independent
validation.

`agents-memory/` stores durable role-specific working knowledge. Trails remain
the historical evidence source; memory must retain provenance to the trails it
interprets and must never silently replace sealed history.

This repo's `.pmcro/` (queue, session-state, trails, constraints) is
self-contained — it does not read or write any sibling repo's state.
