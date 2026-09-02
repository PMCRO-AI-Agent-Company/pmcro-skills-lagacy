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

A product skill must create all three support directories even when
some are initially empty. Use `.gitkeep` only when no real material
exists yet. The scaffold itself should not invent unnecessary files.
