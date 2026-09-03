# .agents/

Spec/input directory consumed by this repo's own PMCR-O engine
(`../engine/PmcroEngine.psm1`, `../engine/run-cycle.ps1`) and by an
agent reading these files as instructions — not auto-discovered by
Claude Code's native `.claude/skills/` loader.

## Layout

| Directory | Purpose |
|---|---|
| `agents/` | Orchestrator/Planner/Maker/Checker/Reflector persona definitions |
| `agents-memory/` | Per-agent persistent memory (empty scaffold today) |
| `commands/` | Slash-command definitions (empty scaffold today) |
| `output-styles/` | Output/response style presets (empty scaffold today) |
| `rules/` | Path-scoped conventions, mirrors `colony-laws.md` |
| `skills/` | PMCR-O cycle skills (orchestrate, queue-claim, queue-enqueue, plan/make/check-frame, reflect-and-seed) |
| `workflows/` | Multi-step orchestrated workflows (empty scaffold today) |

This repo's `.pmcro/` (queue, session-state, trails, constraints) is
self-contained — it does not read or write any sibling repo's state.
