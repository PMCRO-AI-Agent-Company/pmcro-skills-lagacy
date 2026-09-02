# Skill Structure Reference

Every skill in this repository uses the canonical four-part shape:

```text
<skill>/
├── SKILL.md
├── assets/
├── references/
└── scripts/
```

## SKILL.md
The executable instruction contract: routing, scope, workflow,
validation, and output contract.

## assets/
Reusable templates, fixtures, examples, and files copied or filled
into generated projects. Keep full-file templates here.

## references/
Human/agent reference material used while executing the skill. Prefer
focused documents over duplicating the instructions in SKILL.md.

## scripts/
Deterministic helpers that implement repeatable operations. Scripts
must be documented by the skill and safe to run from a clean checkout.

## Required baseline

A completed skill must contain the full structure below:

```text
<skill>/
├── SKILL.md
├── assets/
│   └── templates/
│       └── <full-file-template>
├── references/
│   └── <authoritative-reference>.md
└── scripts/
    └── <deterministic-helper>.ps1
```

The scaffold creates the structural baseline. Before a skill is treated
as complete, it must contain meaningful support material in all three
areas and every capability named by SKILL.md must resolve to an actual
implementation, artifact, or documented repository capability.

Do not use placeholders to make an unimplemented capability appear
implemented. Missing functionality is a validation failure and should
be implemented before the skill is considered usable.

## Capability integrity

A referenced artifact is not an implementation by itself. If SKILL.md
claims an operation, command, validator, generator, or other behavior,
that behavior must exist and be executable. Missing behavior is a
blocking defect: implement it first, then validate it against a safe
fixture or scratch target.


## Concrete example

`agent-skill` itself is the reference package:

```text
agent-skill/
├── SKILL.md
├── assets/
│   ├── SKILL.md.template
│   ├── AGENTS.md.template
│   └── validate-skill.ps1.template
├── references/
│   └── skill-structure.md
└── scripts/
    └── scaffold-skill.ps1
```


The package validator is
`.agents/skills/eval-harness/scripts/check-skill-shape.ps1` (repo-root
relative; `../../eval-harness/scripts/check-skill-shape.ps1` from this
file); `agent-skill/scripts/validate-skill.ps1` is the authoring entry
point. Both are real executable implementations, not documentation-only
claims.
