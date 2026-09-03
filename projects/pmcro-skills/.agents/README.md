# .agents/

Spec/input directory consumed by this repo's own PMCR-O engine
(`../engine/PmcroEngine.psm1`, `../engine/run-cycle.ps1`) and by an
agent reading these files as instructions — not auto-discovered by
Claude Code's native `.claude/skills/` loader.

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

The core execution loop remains Orchestrator → Planner → Maker → Checker →
Reflector. Trailkeeper is an adjacent continuity role, not a sixth phase and
not a second orchestrator.

Trailkeeper preserves cognitive trail history, lifecycle transitions, evidence
provenance, and cross-cycle continuity. Reflector still owns cycle disposition,
next-seed decisions, and queue follow-ups. Checker still owns independent
validation.

`agents-memory/` stores durable role-specific working knowledge. Trails remain
the historical evidence source; memory must retain provenance to the trails it
interprets and must never silently replace sealed history.

This repo's `.pmcro/` (queue, session-state, trails, constraints) is
self-contained — it does not read or write any sibling repo's state.
