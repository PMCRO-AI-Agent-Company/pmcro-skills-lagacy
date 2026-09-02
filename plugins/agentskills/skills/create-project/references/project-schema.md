# Agent Skills Project Manifest

A project manifest describes the instance to generate. Minimum fields:

```json
{
  "name": "example",
  "displayName": "Example Agent Skills",
  "description": "Skills for Example",
  "plugins": [
    { "name": "example", "description": "Core Example skills" }
  ]
}
```

## Invariants

- `name` is lowercase, hyphenated, and contains only letters, digits, and `-`.
- `displayName` and `description` are non-empty strings.
- Plugin names follow the same identifier rule.
- Plugin names are unique within the project.
- Every plugin gets a marketplace entry and a `plugins/<name>` directory.
- The generated tests mirror `tests/<plugin>/<skill-name>/`.
- `-EnablePmcro` is opt-in; when enabled, `pmcro-loop` is added as a first-party plugin and `.pmcro/` is initialized without a pre-seeded task.
