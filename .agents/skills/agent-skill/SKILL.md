---
name: agent-skill
description: Scaffolds a new Agent Skill inside this repo, following the structured skill-folder convention (SKILL.md + optional scripts/references/assets subfolders) and the plugin-packaging convention (plugin.json + .claude-plugin/plugin.json + version.json + skills/). Use when creating a new skill, generating a SKILL.md, deciding whether a skill needs its own plugin, deciding whether support material belongs in scripts/references/assets, or writing an eval.yaml for it. Do not use for editing an existing skill's content, or for project/ template rules and agents (those aren't skills).
license: MIT
---

# Agent Skill

Scaffolds a new skill that conforms to the agentskills.io spec and this
repo's conventions.

## Inputs

| Input | Required | Description |
|---|---|---|
| Skill name | Yes | Lowercase, alphanumeric, hyphens only (e.g. `dependency-audit`) |
| Description | Yes | What it does and when to use it, in the model's routing words (symptoms, error text, the phrase a person would actually type) — this is the *only* text the runtime sees when choosing whether to activate the skill |
| Standalone or part of a plugin? | Yes | See decision table below |

## 1. Decide: standalone skill or new plugin?

| Situation | Where it lives |
|---|---|
| Fits an existing plugin's theme (e.g. another testing skill) | Add under `project/plugins/<existing-plugin>/skills/<name>/` |
| New theme, meant to be distributed/installed | New `project/plugins/<name>/` — needs its own `plugin.json`, `.claude-plugin/plugin.json`, `version.json`, and an entry in the root `.claude-plugin/marketplace.json` |
| Repo-authoring tool (helps *build* this repo, not something end users install) | `.agents/skills/<name>/` at repo root, no plugin wrapper |

## 2. Scaffold the files

```
<skill-name>/
├── SKILL.md          # required — frontmatter + lean instructions
├── scripts/          # optional — executable code SKILL.md invokes
├── references/       # optional — detail docs linked from SKILL.md,
│                      #   not inlined (formats, deep background, tables)
└── assets/            # optional — templates, schemas, static data
```

See `project/.agents/skills/README.md` for the full convention. In
short: keep `SKILL.md` itself lean and link out to `references/*.md`
for anything long; only add a subfolder once there's a real file for
it — a trivial skill can still be just `SKILL.md` alone.


### SKILL.md frontmatter

```yaml
---
name: <skill-name>            # required, must match folder name
description: >                # required, ≤1024 chars, this IS the routing signal
  What it does and when to use it. Include the user's own words.
  End with "DO NOT USE for X" to partition against sibling skills.
license: MIT                  # optional
disable-model-invocation: true # optional — set if explicit-invoke only
argument-hint: <arg>           # optional — shown when explicitly invoked
---
```

## 3. Write an eval

Add `tests/<plugin-or-root>/<skill-name>/eval.yaml` (see an existing one for
the schema) with at least one `stimuli` entry and a grader. Then run:

```bash
python eng/eval-quality/check_eval_quality.py
```

## 4. Quality bar

- **Actionable** — the agent can follow it without guesswork
- **Minimal** — no scope creep; delete anything the model already does unaided
- **Verifiable** — always give a way to check success
- **Tool-conscious** — don't assume capabilities that might not exist in every runtime

Prefer "when A, do B, never C, verify D" tables over lists of alternatives,
and end with a concrete output contract.
