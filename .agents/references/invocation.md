# PMCR-O Skill Invocation Contract

## Canonical form

Every skill in the `pmcro-skills` plugin has one canonical namespaced invocation form:

```text
/pmcro-skills:<skill-name> [optional arguments]
```

Examples:

```text
/pmcro-skills:create-skill
/pmcro-skills:create-custom-agent
/pmcro-skills:discover-capabilities
/pmcro-skills:plan-frame
/pmcro-skills:make-frame
/pmcro-skills:check-frame
/pmcro-skills:reflect-and-seed
/pmcro-skills:orchestrate
```

## Resolution rules

1. `pmcro-skills` is the plugin namespace, not a skill name.
2. `<skill-name>` MUST exactly match the skill directory and SKILL.md frontmatter `name`.
3. Arguments follow the skill selector and are interpreted by the selected skill.
4. Do not use an unqualified `/skill-name` form when invoking a pmcro-skills skill.
5. A plugin or marketplace registration does not by itself prove that a named skill is installed; resolve the skill from the plugin's declared filesystem paths.
6. Cross-plugin skills use their owning plugin namespace, for example `/pmcro-loop:<skill-name>`, rather than `/pmcro-skills:<skill-name>`.

## Agent behavior

Agents must use the canonical selector when they explicitly invoke another skill. Descriptions, examples, handoff instructions, and generated skill templates must use the namespaced form.

## Authoring rule

When creating or renaming a skill, update its frontmatter `name`, directory name, references to its invocation, and any generated examples together. The selector is part of the public skill contract.
