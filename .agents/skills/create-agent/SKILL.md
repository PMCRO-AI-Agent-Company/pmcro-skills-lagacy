---
name: create-agent
description: Scaffolds a new subagent persona under project/.agents/agents/, following this repo's name/description/tools frontmatter + plain-prose-body convention. Use when creating a new PMCRO subagent persona, deciding whether a task needs its own persona vs. reusing an existing one, or writing a persona's tool allow-list. Do not use for creating Agent Skills (use create-skill instead) or for workflows/output-styles/commands.
license: MIT
---

# Create Agent

Scaffolds a new subagent persona that conforms to this repo's
`.agents/agents/` convention (see `project/.agents/agents/README.md`).

## When to Use

- Adding a new dispatchable persona (e.g. `test-writer`, `docs-editor`)
- Deciding whether a task needs a dedicated persona or should stay
  inline in a workflow step

## When Not to Use

- Creating an Agent Skill (`SKILL.md`) — use the `create-skill` skill
- Creating a workflow, output-style, or slash-command — those are
  separate `.agents/` folders with their own conventions

## Inputs

| Input | Required | Description |
|---|---|---|
| Persona name | Yes | Lowercase, hyphenated, matches the filename (e.g. `test-writer.md` → `test-writer`) |
| Description | Yes | What this persona is for and when a workflow/orchestrator should dispatch to it |
| Tools | No | Comma-separated allow-list restricting what the persona can invoke (omit for no restriction) |

## Workflow

### Step 1: Check for an existing fit

Read `project/.agents/agents/README.md`'s "Current personas" list. If
an existing persona already covers this responsibility, extend its
instructions instead of creating a duplicate.

### Step 2: Create the file

```
project/.agents/agents/<persona-name>.md
```

One flat file — no subfolders.

Use `assets/templates/agent.md.template` as the starting shape (it
matches the frontmatter + body structure `scripts/scaffold-agent.ps1`
writes) rather than composing the file from scratch.

### Step 3: Write frontmatter

```yaml
---
name: <persona-name>          # required, must match filename
description: <what this persona is for and when to dispatch to it>
tools: <Tool, Tool, Tool>      # optional allow-list, omit for unrestricted
---
```

### Step 4: Write the body

Plain-prose instructions for how the persona should think and
respond — not a template with headers to fill in. Keep it as tight
as `code-reviewer.md`: a one-line role statement plus a short
numbered list of what it checks or produces, ending with a concrete
output expectation.

### Step 5: Update the README

Add a one-line entry to `project/.agents/agents/README.md`'s
"Current personas" list.

## Validation

- [ ] Filename (minus `.md`) matches the `name` field exactly
- [ ] `description` says both what the persona does and when to
      dispatch to it
- [ ] `tools` (if present) is the minimal set the persona actually
      needs
- [ ] Body ends with a concrete output contract (what it must always
      include in its response)
- [ ] README's "Current personas" list updated

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Persona overlaps an existing one | Extend the existing persona instead of forking a near-duplicate |
| Description only says what, not when | Add the dispatch trigger explicitly |
| Unrestricted `tools` by default | Only omit `tools` if the persona genuinely needs full access |
| Body reads like a skill's step-by-step workflow | Personas are a role + checklist, not a procedure — keep it short |

## References

- [references/agent-frontmatter.md](references/agent-frontmatter.md) — required frontmatter and persona conventions.