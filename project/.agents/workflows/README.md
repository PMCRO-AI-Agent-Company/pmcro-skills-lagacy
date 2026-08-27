# workflows/

Multi-step orchestrated workflows — sequences that chain multiple
agents, skills, and/or commands together, as opposed to any single
one of those running in isolation.

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

One file per workflow. Frontmatter:

```yaml
---
name: <workflow-name>
description: One-paragraph summary of what this closes out.
steps:
  - kind: command | agent | plugin-skill
    ref: <name matching the file/plugin it points to>
    args: <optional, for commands>
    plugin: <required if kind is plugin-skill>
    condition: <optional — when this step applies>
    gate: <optional — what blocks moving past this step>
    does: One line, what this step actually does.
---
```

Body is prose walking through the same steps in enough detail to run
the workflow without re-deriving it from the frontmatter alone.
Path-scoped `../rules/` aren't listed as steps — they're always-on
wherever they match, not something a workflow invokes.

## Current workflows

- `fix-and-verify.md` — `/fix-issue` → `code-reviewer` agent →
  `security-review` plugin skill (conditionally), the reference
  workflow the convention above was written against.
