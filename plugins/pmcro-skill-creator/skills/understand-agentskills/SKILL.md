---
name: understand-agentskills
description: Explains and inventories an Agent Skills project, including project boundaries, marketplaces, plugins, skills, agents, templates, references, scripts, and evaluations. Use when entering an unfamiliar Agent Skills repository or checking whether its generated structure is coherent.
license: MIT
---

# Understand Agent Skills

Treat the repository as a generated Agent Skills application and reconstruct
its architecture from manifests and filesystem evidence rather than guesses.

## Workflow

1. Read root `AGENTS.md` and `README.md`.
2. Discover marketplace manifests and plugin roots.
3. Inventory each plugin's manifest, agents, and skills.
4. Inspect skill support material: assets, references, scripts.
5. Map tests to plugin/skill boundaries.
6. Identify template sources and generated artifacts separately.
7. Report verified structure, missing contracts, and inconsistencies.

## Output Contract

Always distinguish VERIFIED filesystem facts from inferred architecture.
Report the project root, marketplace manifests, plugin list, template sources,
and validation/test boundaries. Do not modify files during discovery.

## References

- `references/project-topology.md` — canonical project map.

