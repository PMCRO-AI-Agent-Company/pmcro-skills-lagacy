---
name: agent-skill
description: Scaffolds and maintains Agent Skills in this repo using the canonical SKILL.md + assets + references + scripts structure. Use when creating a skill, generating templates, deciding support-material placement, or validating a skill package. Do not use for project rules, agents, or workflows.
license: MIT
---

# Agent Skill

Create skills that are complete, self-describing, and reusable.

## Canonical Shape

Every skill directory MUST contain:

```text
<skill-name>/
├── SKILL.md
├── assets/
├── references/
└── scripts/
```

Do not make exceptions for repository/tooling skills. If a directory
has no material yet, keep the directory with a `.gitkeep` until useful
content is authored.

## Support-Material Contract

- `assets/` contains full-file templates, fixtures, examples, and files
  intended to be copied or filled in.
- `references/` contains authoritative guidance consulted while running
  the skill. A template in `assets/` should have a corresponding
  reference when its usage needs explanation.
- `scripts/` contains deterministic helpers for repeatable operations.
  Document every script from `SKILL.md`.

Use `assets/templates/SKILL.md.template` as the baseline skill file.
For project-instruction skills, use `assets/templates/AGENTS.md.template`.

## Location

- Existing plugin: `project/plugins/<plugin>/skills/<name>/`
- New distributed plugin: `project/plugins/<name>/`
- Repo-authoring skill: `.agents/skills/<name>/`

## Workflow

1. Check for an existing skill that already covers the responsibility.
2. Scaffold all four required components with `scripts/scaffold-skill.ps1`.
3. Author `SKILL.md` with precise routing, scope, workflow, validation,
   and an output contract.
4. Add full-file templates to `assets/` when generated artifacts need
   a starting shape.
5. Add focused supporting guidance to `references/`.
6. Add deterministic scripts only where repeatability benefits from code.
7. Validate the resulting tree and inspect the diff.

## Quality Bar

- Actionable: no guesswork.
- Minimal: no unnecessary scope.
- Verifiable: concrete success checks.
- Tool-conscious: use only available capabilities.
- Complete: support directories exist and supporting material is linked
  from the skill instructions.
