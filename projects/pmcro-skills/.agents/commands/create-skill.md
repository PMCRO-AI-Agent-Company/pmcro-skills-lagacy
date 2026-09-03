---
name: create-skill
description: Invoke this repo's existing skill-authoring mechanic to scaffold or substantially revise a SKILL.md. Thin wrapper only -- delegates entirely to .agents/skills/create-skill/SKILL.md rather than duplicating its workflow.
---

# /create-skill

Note: this command was previously drafted as `createskill.md` (no
hyphen); renamed to `create-skill.md` per explicit human correction so
its filename matches the mechanic skill's own name.

## Purpose
Provide a slash-invocable entry point for skill authoring without
hand-rolling SKILL.md frontmatter each time, and without creating a
second, competing implementation of the authoring workflow.

## Args
- `skill_name` (required): lowercase, hyphenated, matches the target
  directory under `.agents/skills/<skill_name>/`.
- `purpose` (required): the concrete task/outcome the skill improves.
- `plugin` (optional): if the skill belongs under a `plugins/pmcro-*`
  charter rather than the shared `.agents/skills/` mechanics, say so.

## Steps
1. Do not reimplement scaffolding logic here. Load and follow
   `.agents/skills/create-skill/SKILL.md` in full, passing through the
   args above as its Inputs (Skill name, Purpose, Activation triggers,
   Boundaries, Workflow, Resources).
2. `create-skill/SKILL.md`'s own "When Not to Use" section governs this
   command too: if the actual need is a small behavioral correction to
   an *existing* skill, do not invoke this command — edit that skill's
   `SKILL.md` directly instead.
3. Run the mechanic's own Step 8 validation before reporting completion
   (frontmatter parses, `name` matches directory, description states
   what/when, no unnecessary environment-specific paths).

## Validation
- [ ] No scaffolding logic exists in this file beyond delegation.
- [ ] The mechanic's own validation checklist was actually run, not
      assumed.
- [ ] This command was not used for a direct edit to an existing skill.
