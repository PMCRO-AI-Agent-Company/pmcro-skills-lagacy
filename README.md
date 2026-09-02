# agent-skills

Personal Agent Skills repository and plugin marketplace, aligned with the
repository conventions used by `dotnet/skills`.

## Layout

```text
.
├── .agents/
│   ├── plugins/marketplace.json
│   └── skills/
│       ├── create-skill/
│       ├── create-agent/
│       ├── eval-harness/
│       └── session-resume/
├── .claude-plugin/marketplace.json
├── plugins/
│   └── security-review/
│       ├── plugin.json
│       ├── version.json
│       ├── .claude-plugin/plugin.json
│       ├── .codex-plugin/plugin.json
│       └── skills/security-review/
├── tests/
│   └── security-review/security-review/eval.yaml
└── eng/eval-quality/
```

## Authoring skills

`.agents/skills/` contains skills used to author and validate this repository.
`create-skill` is the canonical skill for creating and maintaining skills.
These authoring skills are not themselves marketplace plugins.

## Plugins

`plugins/<plugin>/` is the distributable boundary. Every plugin has a
`plugin.json`, a version manifest, and one or more skills under `skills/`.
The root `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`
point to these plugin directories.

## Tests

Skill evaluations live under `tests/<plugin>/<skill-name>/`. Keep test
fixtures and evaluation contracts outside the distributable plugin.

## Validation

Run the repository quality gate before committing:

```text
python eng/eval-quality/check_eval_quality.py
```

For a skill, also run its own deterministic validation scripts and its
matching `tests/<plugin>/<skill-name>/eval.yaml` evaluation when available.
