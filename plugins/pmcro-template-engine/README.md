# PMCR-O Template Engine

The `pmcro-template-engine` plugin adapts the upstream .NET Template Engine skill family for this Agent Skills repository.

## Skills

- `template-authoring` — create and refine custom `dotnet new` templates.
- `template-comparison` — compare installed templates using observed CLI metadata.
- `template-discovery` — map project intent to concrete templates and parameters.
- `template-instantiation` — create projects and solutions with workspace-aware settings.
- `template-smart-defaults` — resolve cross-parameter defaults without overriding user choices.
- `template-validation` — validate custom template metadata and generated behavior.

## Agent

`agents/template-engine.agent.md` is the routing agent for the six skills above.

## Upstream alignment

The skill content is sourced from the current `dotnet/skills` `dotnet-template-engine` plugin and adapted only at the plugin boundary. The upstream plugin currently declares six skills and a `template-engine` agent.

## Boundary

AgentSkills project scaffolding belongs in the `pmcro-skill-creator` plugin. This plugin owns .NET `dotnet new` template discovery, creation, authoring, comparison, defaults, and validation.
