---
name: discover-capabilities
description: Discover installed project plugins and resolve task capabilities from local manifests without hardcoding a provider. Use before planning or execution when work may require an installed plugin or skill. Invoke as /pmcro-skills:discover-capabilities.
---

# Discover Capabilities

## Invocation

```text
/pmcro-skills:discover-capabilities
```

## Purpose
Build a current, file-backed view of capabilities actually installed under the
agent-skills projects root. Marketplace registration is discovery metadata;
filesystem manifests and declared skill paths are the installation evidence.

## Discovery contract
- Start from the repository's resolved projects root; never hardcode a drive letter.
- Inspect immediate project/plugin manifests (`plugin.json`) before treating a folder as a plugin.
- Read declared `skills`, `agents`, `commands`, and `workflows` paths when present.
- Resolve paths and record only existing files/directories.
- Do not execute plugin code during discovery.
- A plugin name is not itself proof that the plugin is installed or usable.

## Resolution contract
1. Planner identifies capability needs from the seed and PlanFrame.
2. Discovery maps needs to installed providers using manifest name, description,
   skill names, and declared artifact paths.
3. Prefer an exact installed provider over a weaker semantic match.
4. If multiple providers match, preserve all candidates and let Planner/Maker
   choose according to the PlanFrame; discovery must not dispatch work.
5. If no provider is installed, report unresolved capability rather than inventing one.

## Registry
The bundled script writes a generated registry to `.pmcro/capability-registry.json`.
It is derived state, not colony law. Re-run discovery when projects or plugin
manifests change. The registry includes scan time, projects root, providers,
capabilities, declared artifacts, and resolution evidence.

## PMCR-O boundaries
- Orchestrator remains the only dispatcher.
- Planner resolves required capabilities before Maker execution.
- Maker may use only capabilities approved by the PlanFrame.
- Checker verifies that claimed provider use matches discovered evidence.
- Reflector may record durable lessons; it does not change discovery rules alone.
- Trailkeeper records provider/capability provenance in the Cognitive Trail.
- TYPE1 mutations remain gated by explicit human approval.

## Validation
Run `scripts/discover-capabilities.ps1` against the resolved projects root and
verify that known installed plugins such as dotnet-skills are discovered without
special-case code. Discovery must tolerate projects that contain no plugin.json.
