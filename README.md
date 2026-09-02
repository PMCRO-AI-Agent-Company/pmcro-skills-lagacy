# agent-skills

Personal Agent Skills tooling and plugin marketplace, structured after
the Agent Skills marketplace convention used by the reference project.

## Layout

| Path | What it is |
|---|---|
| `.claude-plugin/marketplace.json` | Marketplace manifest |
| `.agents/skills/` | Tooling for authoring and validating this repo; not distributed |
| `global/.agents/` | Template for machine-wide agent configuration |
| `project/.agents/` | Template for a per-project agent configuration layer |
| `project/plugins/` | Installable plugins and their skills |
| `tests/` | Structural/evaluation cases for skills and plugins |
| `eng/eval-quality/` | Structural quality gate |

## Development `.agents/`

The repository's own `.agents/` is session tooling, not the marketplace
product tree. It now includes the authoring skill, agent-creation skill,
evaluation harness, and session-resume pointer. Product skills remain
under `project/plugins/` and are not duplicated into this directory.

## Skill convention

A skill is a directory containing `SKILL.md`. Product skills should use
the default `assets/`, `references/`, and `scripts/` subfolders so support
material has a stable location even when initially empty. Session skills
may remain lean when they do not need those subfolders.

## Installing a plugin

Use the marketplace manifest for the supported plugin host. Keep mirrored
marketplace manifests synchronized whenever both are present.

## Contributing

Read `.agents/skills/agent-skill/SKILL.md` before creating a skill and
`.agents/skills/eval-harness/SKILL.md` before treating a modified skill as
validated.

Run:

```bash
python eng/eval-quality/check_eval_quality.py
```

Then validate any changed JSON manifests with the repository's current
validation mechanism. Do not assume an external CLI is installed.
