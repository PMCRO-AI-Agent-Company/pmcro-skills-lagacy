# Generation Model

Agent Skills generation has three layers.

1. **Project templates** create the repository and marketplace boundary.
2. **Plugin templates** create distributable plugin metadata and skill roots.
3. **Skill templates** create individual `SKILL.md` packages and support files.

Project templates are owned by `create-project`; individual skill templates
remain owned by `create-skill`. The template engine renders both but does not
own domain content.

Generation is plan-first: discover inputs, resolve paths, validate tokens,
then write. Validation happens after rendering. An empty destination is the
only default write target; existing content requires explicit overwrite.
