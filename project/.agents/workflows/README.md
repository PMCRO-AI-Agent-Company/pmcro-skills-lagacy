# workflows/

Multi-step orchestrated workflows — sequences that chain multiple agents,
skills, and/or commands together instead of running each in isolation.

Part of the `.agents/` project environment.

## Convention

One file per workflow. Frontmatter:

```yaml
---
name: <workflow-name>
description: One-paragraph summary of what this closes out.
steps:
  - kind: command | agent | plugin-skill
    ref: <name matching the artifact it points to>
    args: <optional, for commands>
    plugin: <required if kind is plugin-skill>
    condition: <optional — when this step applies>
    gate: <optional — what blocks moving past this step>
    does: One line describing the step.
---
```

The body explains the same sequence without forcing the runtime to rediscover
it. Rules remain always-on and are not invoked as workflow steps.

## Current workflows

- `fix-and-verify.md` — command → code-reviewer agent → validation/testing.

A workflow may dispatch skills and agents together, but each dependency must
be discoverable from the repository's `.agents/` surfaces or installed plugin.
