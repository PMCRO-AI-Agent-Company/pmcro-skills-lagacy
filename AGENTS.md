# Repository instructions

This repo is an Agent Skills plugin marketplace plus reusable project and
repository-authoring templates. Treat marketplace manifests as registries
and generated project templates as the source for new instances.

**Before editing:**
1. Read this file and the relevant README.
2. Inspect the target plugin/skill structure before changing it.
3. Check git status and preserve unrelated user changes.

## Working on skills, plugins, and projects

Use `.agents/skills/create-skill/SKILL.md` for individual skill creation,
`.agents/skills/create-custom-agent/SKILL.md` for agent personas, and the installed
`plugins/agentskills/skills/create-project/SKILL.md` for whole-project generation.

Plugin skills use `SKILL.md` plus `assets/`, `references/`, and `scripts/` when
those support materials are required by the capability.

## Namespace distinction (short names collide, addresses do not)

Two different capability namespaces both expose skills named `create-skill` and
`create-custom-agent`. Discovery must never key on short skill name alone —
always resolve the full address:

- `.agents/skills/<name>` — session/repository tooling scoped to this repo's own
  agent workspace (e.g. `.agents/skills/create-skill`, `.agents/skills/create-custom-agent`).
  Not PMCR-O governed; no TYPE1 approval gating.
- `/pmcro-skills:<name>` — PMCR-O-governed marketplace capabilities from the
  `pmcro-skills` plugin (e.g. `/pmcro-skills:create-skill`, `/pmcro-skills:create-custom-agent`).
  Subject to the Orchestrator/approval model in `plugins/pmcro-loop`.

Same short name, different scope and governance. Resolve by full address before
treating two same-named skills as duplicates or interchangeable.

## Conventions

- Keep marketplace manifests synchronized.
- Keep plugin manifest copies synchronized according to the active convention.
- Never hardcode a machine-specific drive letter into committed content.
- Keep project templates separate from repository session tooling.
- Preserve existing architecture; make the smallest verified change.
- Generation must never silently overwrite user content.

