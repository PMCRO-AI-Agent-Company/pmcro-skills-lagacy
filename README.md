# agent-skills

Personal scaffold + plugin marketplace for AI coding agents, structured
after [`dotnet/skills`](https://github.com/dotnet/skills).

## Layout

| Path | What it is |
|---|---|
| `.claude-plugin/marketplace.json` | Marketplace manifest — lists every installable plugin |
| `.agents/skills/` | Tooling for authoring *this repo* (e.g. `agent-skill`, which scaffolds new skills). Not distributed. |
| `global/.agents/` | Template for a **machine-wide** `~/.agents` config (PMCRO agents: planner/maker/checker/reflector, global preferences) |
| `project/.agents/` | Template for a **per-project** `.agents` overlay (project-specific agents, rules, commands) |
| `project/plugins/` | Installable plugins — see `project/plugins/README.md` |
| `tests/<plugin-or-skill>/eval.yaml` | Evals, one per skill, mirroring `dotnet/skills`' top-level `tests/` tree |
| `eng/eval-quality/` | Structural quality gate that runs against every skill/plugin/eval |

## Why two template trees (`global/` vs `project/`)?

They answer different questions and should stay separate rather than merge:

- `global/` — "what should *every* project I touch inherit from me?"
  (my planner/maker/checker/reflector agents, my style preferences).
  Lives at `~/.agents` on a machine, independent of any repo.
- `project/` — "what does *this specific* project need?" (its rules,
  its plugins, its commands). Lives inside a project's own `.agents/`.

**Open question raised during the last structure review:** does `global/`
need to be a folder you hand-maintain and copy from, or could `project/`
scaffold it on demand (an `agent-skill`-style bootstrap skill that writes
`~/.agents` from a template the first time it's needed)? Left as-is for
now — no rename or deletion — but if you build that bootstrap skill later,
`global/` becomes its template *input* rather than something synced by
hand, which is a cleaner mental model than maintaining two parallel trees
forever. Worth revisiting once there's a second global-config consumer to
justify the tooling.

## Installing a plugin

```
/plugin marketplace add <path-to-this-repo>
/plugin install security-review@agent-skills
```

## Contributing a new skill or plugin

See `/.agents/skills/agent-skill/SKILL.md`. Quality bar and eval gate:

```bash
python eng/eval-quality/check_eval_quality.py
```
