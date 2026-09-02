---
name: skills
description: Agent Skills convention doc for this repo — governs .agents/skills/ (repo-authoring), project/.agents/skills/ (project-local), and every plugins/<n>/skills/ folder.
---

# skills/

Agent Skills use the open `SKILL.md` format. This repository adds a stable
package contract: every distributed skill has `assets/`, `references/`, and
`scripts/`, even when a surface currently contains only `.gitkeep`.

## Convention

```text
skills/<skill-name>/
├── SKILL.md          # required — frontmatter + lean instructions
├── assets/           # flat templates, fixtures, static resources
├── references/       # flat detail docs loaded on demand
└── scripts/          # flat deterministic helpers
```

Keep `SKILL.md` lean and route detailed material through explicit relative
references. Keep support directories flat; do not create `assets/templates/`
or other nested category trees.

## Composition

Skills provide reusable procedural knowledge. Project-local `.agents/agents/`
personas provide specialized roles, while `.agents/workflows/` compose agents,
skills, and commands into multi-step execution. `.agents/commands/` remains an
explicit authoring surface rather than a skill-discovery surface.

When authoring a skill, inspect these sibling surfaces before adding artifacts.
Add an agent or workflow only when the capability genuinely needs coordination.

## Current skills

Skills specific to this project belong here. Shared/installable skills belong
under `../../plugins/`. Use the repository `create-skill` authoring skill to
choose the correct boundary and preserve the package contract.
