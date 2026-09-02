---
name: create-skill
description: Creates or improves an Agent Skill package using the repository's complete SKILL.md, flat assets, references, and scripts contract. Use when authoring, scaffolding, validating, or composing skills for MAF-based agents and workflows.
license: MIT
---

# Create Skill

Create a focused, reusable Agent Skill that follows Agent Skills principles and
this repository's stronger packaging contract.

## Architecture

Skills are the procedural-knowledge layer. They provide instructions,
references, assets, examples, and deterministic scripts. They do not become the
orchestration engine.

MAF agents and workflows own persona, tool execution, sequencing, handoffs,
and gates. Project `.agents/` surfaces are inspected when coordination is
needed; do not create an agent or workflow merely because a skill exists.

## Workflow

1. Inspect existing skills before creating a new responsibility.
2. Define purpose, activation triggers, inputs, outputs, and boundaries.
3. Inspect applicable `.agents/agents/`, `.agents/workflows/`, `.agents/commands/`,
   and rules when the skill participates in project coordination.
4. Scaffold a package containing `SKILL.md`, `assets/`, `references/`, and `scripts/`.
5. Keep all support directories flat; never create `assets/templates/`.
6. Put complete reusable output templates directly in `assets/`.
7. Put authoritative supporting material in `references/` and deterministic helpers in `scripts/`.
8. Document every referenced support artifact and executable script.
9. Add or update the behavioral evaluation for the skill.
10. Validate structure, paths, frontmatter, scripts, and representative behavior.
11. Inspect the final diff; preserve existing user content unless replacement is explicit.

## MAF Composition

```text
MAF Agent
  -> activates Skill
       -> SKILL.md + references/ + assets/ + scripts/
  -> uses tools/MCP
  -> participates in Workflow
       -> sequencing + handoffs + gates
```

Use this separation to keep skills portable while allowing MAF applications to
compose them into larger agent workflows.

## Quality Bar

Prefer progressive disclosure, concrete procedures, defaults, gotchas,
validation loops, and concise routing descriptions. Add only material the
agent actually needs. Match specificity to the fragility of the task.

## Repository Contract

The open Agent Skills specification makes support directories optional. This
repository intentionally strengthens that contract: every distributed skill
must contain `assets/`, `references/`, and `scripts/`; use `.gitkeep` when one is
empty. Specification-required `SKILL.md` remains canonical.

## References

- `references/skill-structure.md` — package shape and authoring invariants.
- `references/artifact-catalog.md` — supported project artifact templates.
- `references/agents-md.md` — AGENTS.md guidance.
- `references/agents.md` — agent artifact guidance.
- `references/commands.md` — command guidance.
- `references/mcp-json.md` — MCP configuration guidance.
- `references/memory.md` — memory artifact guidance.
- `references/output-styles.md` — output-style guidance.
- `references/rules.md` — rule guidance.
- `references/settings.md` — settings guidance.
- `references/themes.md` — theme guidance.
- `references/workflows.md` — workflow guidance.
- `references/worktreeinclude.md` — worktree guidance.

## Scripts

Use `scripts/` for deterministic scaffolding and validation. Every executable
script used by the skill must be documented and tested against a safe fixture.
