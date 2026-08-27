---
name: skills
description: Agent Skills convention doc for this repo — governs .agents/skills/ (repo-authoring), project/.agents/skills/ (project-local), and every plugins/<n>/skills/ folder.
---

# skills/

Agent Skills — one subdirectory per skill, following the open Agent
Skills format (`SKILL.md` + optional support files). Skills are meant
to auto-trigger from conversational context based on their
`description`, unlike `../commands/` (explicitly invoked).

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

Structured layout, mirroring the `dotnet/skills` convention:

```
skills/<skill-name>/
├── SKILL.md          # required — frontmatter + lean instructions
├── scripts/          # optional — executable code the skill invokes
│                     #   (resolve paths relative to SKILL.md's own dir)
├── references/       # optional — detail docs loaded on demand,
│                     #   linked from SKILL.md's own "## References"
│                     #   section instead of inlined
└── assets/           # optional — templates, schemas, static data
                      #   files the skill reads or copies out
```

Rules:

- **SKILL.md stays lean.** Push step-by-step detail, format specs, or
  background reading into `references/*.md` and link out — don't
  inline everything. Aim to keep `SKILL.md` itself well under 500
  lines.
- **`scripts/` holds executable code**, not documentation. A
  PowerShell/Python/shell script the skill runs, referenced from
  `SKILL.md` by a path resolved relative to `SKILL.md`'s own
  directory (so it works regardless of the caller's cwd).
- **`assets/` holds non-executable support files** — JSON schemas,
  templates, sample data — that the skill reads, copies, or fills in.
- **Small skills can stay flat** — just `SKILL.md` plus zero or one
  plain sibling file — when there's nothing substantial enough to
  warrant a subfolder. Don't create an empty `scripts/`/`references/`/
  `assets/` folder speculatively; add each only once there's a real
  file to put in it.

See `/.agents/skills/agent-skill/` at the repo root for the skill that
scaffolds new ones following this convention (it also decides whether a
new skill belongs here, in an existing plugin, or as a new plugin under
`../../plugins/`).

## Current skills

None yet directly under this project template — `security-review` was
promoted to a real, installable plugin at `../../plugins/security-review/`
once it needed its own `plugin.json`/versioning. Skills that are specific
to *this* project (not meant to be distributed as a plugin) belong here;
skills meant to be shared/installed belong under `../../plugins/`.
