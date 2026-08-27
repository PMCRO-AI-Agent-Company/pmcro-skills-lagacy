# .agents/

**This is the spec/input directory for the PMCRO runtime — it is not
read by Claude Code's native skill loader.** Claude Code only
auto-discovers skills from `.claude/skills/`; this repo intentionally
uses `.agents/` instead because it's being turned into its own PMCRO
runtime, which will define its own parsing rules for everything below.

Until the runtime exists, treat every file here as a **specification
to be consumed later**, not something any tool currently executes
automatically.

## Layout

| Directory | Purpose |
|---|---|
| `agents/` | Subagent persona definitions |
| `agents-memory/` | Per-agent persistent memory (empty scaffold today) |
| `commands/` | Slash-command definitions |
| `output-styles/` | Output/response style presets (empty scaffold today) |
| `rules/` | Path-scoped conventions, auto-applied when matching files are touched |
| `skills/` | Agent Skills (`SKILL.md` + support files), one folder per skill |
| `workflows/` | Multi-step orchestrated workflows (empty scaffold today) |

`settings.json` / `settings.local.json` — tool permissions and hooks
config; `.local.json` is the personal/gitignored override.

See each subdirectory's own `README.md` for details on what belongs
in it.
