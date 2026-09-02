---
name: plugin-management
description: Discovers, imports, validates, registers, updates, and removes Agent Skills plugins from local or third-party sources. Use when managing marketplace plugins or adding external plugin packages.
license: MIT
---

# Plugin Management

Manage plugins as explicit packages with a clear trust boundary.

## Sources

- Local plugin directory: `./plugins/<plugin-name>`
- External Git repository: materialize into controlled staging
- Marketplace entry: resolve its `source` and validate before registration

## Workflow

1. Inspect the source without executing plugin scripts.
2. Validate the plugin manifest and identifier.
3. Validate skill package boundaries and required `SKILL.md` files.
4. Check assets, references, and scripts for repository conventions.
5. Stage third-party content separately from first-party plugins.
6. Register only after validation succeeds.
7. Run plugin evaluation before declaring installation complete.
8. Record source and provenance so updates can be audited.

## Trust boundary

Discovery and validation are non-execution operations. Do not execute arbitrary
third-party scripts merely because a plugin was discovered or registered.
Execution requires an explicit installation/use decision in a controlled
project environment.

## Naming

Use lowercase kebab-case plugin and skill identifiers. Preserve specification-
required canonical filenames such as `SKILL.md` and `AGENTS.md`.

## Structure

A plugin may contain `skills/`, `agents/`, and plugin metadata. Each skill may
use flat `assets/`, `references/`, and `scripts/` directories when required.

## Failure behavior

Fail closed on malformed manifests, path traversal, identifier violations,
missing skill contracts, duplicate registrations, or validation failures.
Never silently overwrite an existing plugin.

## Output contract

Always report the resolved source, plugin identity, validation result, and
whether registration changed the marketplace.

## References

- `references/plugin-contract.md` — plugin package and provenance contract.
- `references/source-contract.md` — source resolution guidance.

