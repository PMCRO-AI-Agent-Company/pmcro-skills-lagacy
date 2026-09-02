---
name: create-skill
description: Scaffolds and maintains Agent Skills with SKILL.md plus complete flat assets, references, and scripts. Use when creating, improving, validating, or composing skills for MAF agents and workflows.
license: MIT
---

# Create Skill

Create skills that are focused, self-describing, reusable, verifiable, and
honest about what they actually implement.

## Canonical Shape

```text
<skill-name>/
├── SKILL.md
├── assets/
├── references/
└── scripts/
```

This repository requires all three support directories for distributed skills.
Keep each directory flat. Never create `assets/templates/`.

## Authoring Workflow

1. Check whether an existing skill already covers the responsibility.
2. Inspect the target plugin and applicable repository `.agents/` surfaces.
3. Define purpose, activation triggers, inputs, outputs, and boundaries.
4. Scaffold the complete package.
5. Author routing, procedure, validation, and output contract in `SKILL.md`.
6. Put complete reusable output templates directly in `assets/`.
7. Put authoritative supporting material in `references/`.
8. Put deterministic repeatable helpers in `scripts/`.
9. If coordination is required, inspect `.agents/agents/`, `.agents/workflows/`,
   `.agents/commands/`, and rules before changing those surfaces.
10. Add a matching evaluation and exercise representative behavior safely.
11. Validate structure, paths, frontmatter, scripts, and support references.
12. Inspect the diff before publishing.

## MAF Integration

Treat Agent Skills as the procedural knowledge layer around MAF agents and
workflows. Skills supply reusable knowledge and procedures; MAF agents and
workflows own persona, tool execution, sequencing, handoffs, and gates.

```text
MAF Agent -> Skill -> procedure/references/assets/scripts
          -> Tools/MCP
          -> Workflow -> sequencing/handoffs/gates
```

Do not turn a skill into a hidden orchestration engine. Create a project agent,
workflow, or command only when the capability genuinely needs that surface.

## Quality Bar

Use progressive disclosure, concrete procedures, defaults, gotchas, validation
loops, and concise activation descriptions. Add only what the agent needs.
Match specificity to task fragility.

## MCP Documentation

For current Agent Skills specification and best-practice guidance, this plugin
ships the read-only `agent-skills-docs` MCP configuration at the plugin root.
Use it as authoring context; do not copy its network dependency into generated
projects unless explicitly requested.

## References

- `references/skill-structure.md`
- `references/artifact-catalog.md`
- `references/agents-md.md`
- `references/agents.md`
- `references/commands.md`
- `references/mcp-json.md`
- `references/memory.md`
- `references/output-styles.md`
- `references/rules.md`
- `references/settings.md`
- `references/themes.md`
- `references/workflows.md`
- `references/worktreeinclude.md`

## Scripts

- `scripts/scaffold-skill.ps1`
- `scripts/validate-skill.ps1`
- `scripts/inventory-artifacts.ps1`
- `scripts/validate-templates.ps1`
- `scripts/validate-references.ps1`
- `scripts/scaffold-artifact.ps1`
