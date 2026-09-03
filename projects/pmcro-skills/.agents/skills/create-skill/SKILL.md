---
name: create-skill
description: Creates or scaffolds Agent Skills for this `.agents` workspace. Use when adding a new reusable skill, creating or revising a `SKILL.md`, defining skill routing metadata, or structuring skill resources. Aligns skills with the current Agent Skills specification and this repository's `.agents/skills/` conventions. Do not use for changing an existing skill's behavior when the task is a direct edit, creating custom agents, or designing PMCR-O cycle behavior.
---

# Create Skill

Create a small, self-contained Agent Skill that follows the current Agent Skills specification and fits this repository's `.agents/skills/` layout.

## When to Use

- Add a new reusable skill under `.agents/skills/`
- Scaffold or substantially redesign a `SKILL.md`
- Define or improve the skill's activation description
- Decide which instructions belong in `SKILL.md` versus `references/`, `scripts/`, or `assets/`
- Validate a newly created skill against the Agent Skills format

## When Not to Use

- Making a small behavioral correction to an existing skill: edit that skill directly
- Creating or changing `.agents/agents/*.md`: use the custom-agent workflow appropriate to this repository
- Designing the PMCR-O lifecycle itself: use the relevant cycle skill such as `plan-frame`, `make-frame`, `check-frame`, or `reflect-and-seed`
- Adding evaluation infrastructure that this repository does not actually contain

## Inputs

| Input | Required | Description |
|---|---|---|
| Skill name | Yes | Lowercase name matching the skill directory; 1–64 characters |
| Purpose | Yes | The concrete task/outcome the skill improves |
| Activation triggers | Yes | User/task language that should cause the skill to load |
| Boundaries | Recommended | Nearby intents the skill must not claim |
| Workflow | Recommended | Ordered instructions the agent should follow |
| Resources | Optional | Scripts, references, or assets needed for uncommon or detailed paths |

## Workflow

### Step 1: Discover the repository convention

Inspect nearby skills in `.agents/skills/` before creating the directory.

Match the repository's existing naming, frontmatter, and instruction style. Do not assume a path from another repository or framework.

### Step 2: Validate the skill name

The directory and `name` must match.

Use:
- 1–64 characters
- lowercase letters, numbers, and hyphens
- no leading or trailing hyphen
- no consecutive hyphens

### Step 3: Write routing metadata first

The `description` is the primary activation signal. It must state both:
1. what the skill does; and
2. when an agent should use it.

Use concrete trigger language from real requests, artifacts, errors, or outcomes. Explicitly exclude the nearest competing skill when ambiguity is likely.

Keep the description under 1,024 characters.

Do not put the whole workflow into the description.

### Step 4: Create the skill structure

Minimum:

```text
.agents/skills/<skill-name>/
└── SKILL.md
```

Add resources only when they provide real value:

```text
.agents/skills/<skill-name>/
├── SKILL.md
├── scripts/       # executable helpers
├── references/    # detailed material loaded when needed
└── assets/        # templates or static resources
```

Keep `SKILL.md` focused. Move large reference material or rarely used procedures into resource files.

### Step 5: Write the instructions

Prefer decisions and actions over general background.

A strong skill tells the agent:
- when to act;
- what to inspect;
- what order to follow;
- what must never be done;
- what to verify before declaring success;
- what to report when verification fails.

Use explicit stop conditions for no-op or already-correct cases.

Do not require the user to provide information the agent can discover from the workspace.

Use relative paths from the skill root for bundled resources, for example:

```text
references/details.md
scripts/validate.ps1
```

Avoid deep chains of references.

### Step 6: Use the standard frontmatter

The current Agent Skills specification requires `name` and `description`. Optional fields include `license`, `compatibility`, `metadata`, and experimental `allowed-tools`.

Example:

```yaml
---
name: example-skill
description: Performs a specific task. Use when the user asks for that task or presents its characteristic artifacts.
---
```

Only add optional fields when they communicate a real requirement or useful metadata. Do not invent fields that the target Agent Skills implementation does not support.

### Step 7: Keep the body compact

Recommended structure:

```markdown
# Skill Title

One paragraph describing the outcome.

## When to Use

- ...

## When Not to Use

- ...

## Workflow

### Step 1: ...

### Step 2: ...

## Validation

- [ ] ...

## Common Pitfalls

- ...
```

The specification places no rigid body-section requirement. These sections are a practical convention, not mandatory syntax.

Keep `SKILL.md` below 500 lines and preferably below about 5,000 tokens. Use progressive disclosure for detail.

### Step 8: Validate before finishing

Check all of the following:

- `SKILL.md` exists at the skill root
- YAML frontmatter parses
- `name` matches the directory
- `name` satisfies the naming rules
- `description` is 1–1,024 characters and says what/when
- optional `compatibility` is only present when genuinely needed and is ≤500 characters
- referenced files exist and use relative paths
- instructions are actionable and ordered
- boundaries prevent accidental activation
- validation criteria are observable
- no secrets or unnecessary environment-specific paths are embedded

If the `skills-ref` validator is installed, run:

```text
skills-ref validate .agents/skills/<skill-name>
```

If it is unavailable, perform the checks above and report that the reference validator was not available rather than claiming it ran.

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Description is vague | State the task and concrete activation triggers |
| Skill claims a neighboring intent | Add an explicit boundary and adjust the neighboring skill if necessary |
| `SKILL.md` becomes a manual | Move detailed, rarely used material into `references/` |
| Instructions merely restate model knowledge | Encode decisions, stop conditions, verification, or repository-specific behavior |
| Hardcoded absolute paths | Use paths relative to the skill root or discover the workspace path |
| Missing bundled resource | Verify every referenced resource before declaring the skill complete |
| Unsupported frontmatter | Keep required fields to `name` and `description`; add only specification-supported optional fields |
| Claims success without verification | Report the actual validation result and any unavailable checks |
