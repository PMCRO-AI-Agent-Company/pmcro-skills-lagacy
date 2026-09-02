# Repository instructions

This repo is a plugin marketplace plus reusable project/global Agent
Skills templates. Treat `agents.config.json` (when present) as the
machine-readable source of truth in the marketplace implementation;
otherwise follow this repo's local README and `.agents/` conventions.

**Before editing:**
1. Read this file and the relevant README.
2. Inspect the target plugin/skill structure before changing it.
3. Check git status and preserve unrelated user changes.

## Working on skills, plugins, and evals

Use `.agents/skills/agent-skill/SKILL.md` for skill creation and
`.agents/skills/eval-harness/SKILL.md` for regression validation.

Plugin skills use `SKILL.md` plus the default `assets/`, `references/`,
and `scripts/` subfolders. Session-tooling skills under `.agents/skills/`
are repository-development tools and are not marketplace products.

Before considering a changed skill/plugin complete, run the repository's
structural quality gate and validate changed JSON manifests. Do not rely
on an external CLI unless this repository explicitly declares it as a
current dependency.

## Conventions

- Keep marketplace manifests synchronized when both mirror files exist.
- Keep plugin manifest copies synchronized according to the active
  marketplace convention.
- Never hardcode a machine-specific drive letter into committed content.
- Keep project templates separate from this repository's own session
  tooling.
- Preserve existing architecture; make the smallest verified change.
