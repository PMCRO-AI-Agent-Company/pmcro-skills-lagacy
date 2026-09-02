---
name: agent-skill
description: Scaffolds and maintains Agent Skills in this repo using the canonical SKILL.md + assets + references + scripts structure. Use when creating a skill, generating templates, deciding support-material placement, or validating a skill package. Do not use for project rules, agents, or workflows.
license: MIT
---

# Agent Skill

Create skills that are complete, self-describing, and reusable.

## Canonical Shape

Every completed skill directory MUST contain the full package structure:

```text
<skill-name>/
├── SKILL.md
├── assets/
│   └── templates/
│       └── <full-file-template>
├── references/
│   └── <authoritative-reference>.md
└── scripts/
    └── <deterministic-helper>.ps1
```

`SKILL.md` is the executable instruction contract. `assets/` contains
full-file templates, fixtures, and examples. `references/` contains
supporting authoritative guidance. `scripts/` contains deterministic
helpers. Run `scripts/validate-skill.ps1` to validate the completed
package. A skill MUST NOT claim functionality that is not implemented
or backed by an existing artifact.

Do not make exceptions for repository/tooling skills. A completed skill
must have real support material; do not use empty directories to imply
implemented functionality.

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
2. Scaffold the complete package with `scripts/scaffold-skill.ps1`.
3. Author `SKILL.md` with precise routing, scope, workflow, validation,
   and an output contract.
4. Add full-file templates to `assets/` when generated artifacts need
   a starting shape.
5. Add focused supporting guidance to `references/`.
6. Add deterministic scripts only where repeatability benefits from code.
7. Run `scripts/validate-skill.ps1` against the completed skill, execute its behavior against a safe fixture, and inspect the diff.

## Quality Bar

- Actionable: no guesswork.
- Minimal: no unnecessary scope.
- Verifiable: concrete success checks.
- Tool-conscious: use only available capabilities.
- Complete: support directories exist and supporting material is linked
  from the skill instructions.

## Capability Integrity

A skill is not complete merely because its documentation describes a feature.
Before using or shipping a capability:

1. Resolve every referenced asset, reference, and script to a real file.
2. Verify every claimed command or operation has an implementation.
3. Run `scripts/validate-skill.ps1` and execute the relevant implementation against a safe test target.
4. If functionality is missing, treat that as a blocking failure and implement it before declaring the skill usable.
5. Report the implementation and verification evidence.

## Full Package Example

```text
agent-skill/
├── SKILL.md
├── assets/
│   └── templates/
│       ├── SKILL.md.template
│       ├── AGENTS.md.template
│       └── validate-skill.ps1.template
├── references/
│   └── skill-structure.md
└── scripts/
    └── scaffold-skill.ps1
```

Use this as the concrete model when auditing or creating a complete
skill package. The filenames may differ by skill, but the four-part
structure and implemented support-material principle do not.

## Implementation Rule

Do not expose or route to a capability until its implementation exists.
A missing implementation is a blocking defect, not a documentation gap.
Implement it, test it, then add or update the skill contract.


The canonical example above is the minimum shape. Skills should add
additional assets, references, tests, and scripts whenever their actual
capabilities require them; the validator must keep those claims honest.


The `agent-skill` package itself is the canonical full-structure example,
including a full-file `AGENTS.md` template and a dedicated validator.


## Validation Implementation

The package validator is implemented at `scripts/validate-skill.ps1`.
It verifies the required directories, real template/reference/script
artifacts, and every support path explicitly referenced by this file.
Behavioral claims still require execution through the evaluation harness.


The scaffold also installs `assets/templates/validate-skill.ps1.template`
and the executable `scripts/validate-skill.ps1`, so validation is part of
the generated package rather than an external assumption.

## Artifact Template Library

The repository tree inventory defines a broader Agent artifact surface than skills alone. Reusable templates in `assets/templates/` cover authored configuration and extension artifacts; runtime-generated memory remains example-only.

### Templates
- `assets/templates/skill.md.template`
- `assets/templates/agents.md.template`
- `assets/templates/project-agents.md.template`
- `assets/templates/mcp.json.template`
- `assets/templates/worktreeinclude.template`
- `assets/templates/settings.json.template`
- `assets/templates/settings.local.json.template`
- `assets/templates/rule.md.template`
- `assets/templates/command.md.template`
- `assets/templates/output-style.md.template`
- `assets/templates/agent.md.template`
- `assets/templates/workflow.template`
- `assets/templates/theme.json.template`
- `assets/templates/memory.md.template` (example only; memory is runtime-generated)

### References
See `references/artifact-catalog.md` for the complete artifact-to-template/reference/script mapping. Detailed references include `agents-md.md`, `mcp-json.md`, `worktreeinclude.md`, `settings.md`, `rules.md`, `commands.md`, `output-styles.md`, `agents.md`, `workflows.md`, `themes.md`, and `memory.md`.

### Scripts
Deterministic helpers include `scripts/scaffold-skill.ps1`, `scripts/validate-skill.ps1`, `scripts/inventory-artifacts.ps1`, `scripts/validate-templates.ps1`, `scripts/validate-references.ps1`, and `scripts/scaffold-artifact.ps1`. A script is only documented as functional when it exists and has been exercised successfully.
