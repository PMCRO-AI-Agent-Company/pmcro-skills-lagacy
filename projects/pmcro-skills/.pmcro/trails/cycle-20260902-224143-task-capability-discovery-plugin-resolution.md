# Trail: cycle-20260902-224143-task-capability-discovery-plugin-resolution

trail_id: cycle-20260902-224143-task-capability-discovery-plugin-resolution
task_id: task-capability-discovery-plugin-resolution
domain: pmcro-governance
priority: 1
opened: 2026-09-02
engine_generated: true

## Seed intent
Implement dynamic capability discovery and plugin resolution so PMCR-O can see
installed/imported projects, resolve capabilities without hardcoding dotnet,
and preserve provider provenance.

## PlanFrame (Planner)
Acceptance criteria:
1. Discover installed plugin.json manifests under the resolved projects root.
2. Ignore adapter manifests under .codex-plugin/.claude-plugin/.cursor-plugin.
3. Produce a generated .pmcro/capability-registry.json with provider metadata,
   declared artifacts, and existence evidence.
4. Resolve a natural-language capability query to installed providers.
5. Integrate the contract into Planner/Orchestrator and Trailkeeper guidance.
6. No TYPE1 mutation or dispatch shortcut is introduced.

## MakeFrame (Maker)
Created discover-capabilities skill with standard assets/references/scripts
layout and deterministic PowerShell discovery/resolution helpers. The scanner
uses a caller-supplied projects root, reads plugin manifests only, and writes
generated registry state. Planner and Orchestrator now require installed
capability evidence for plugin-dependent work; Trailkeeper records provider
provenance.

## CheckFrame (Checker)
Ran discovery against the installed projects root: 23 canonical plugin
providers were found. Ran resolution query `C# testing dotnet`; results
included dotnet, dotnet-test, dotnet-test-migration, and related providers,
with project and manifest-relative provenance. Initial scan exposed duplicate
adapter manifests; scanner was corrected to exclude .codex-plugin,
.claude-plugin, and .cursor-plugin and was rerun successfully.
verdict: pass
findings: none
blockers: none
recommendation: accept

## Capability provenance
Example verified provider: `dotnet` version `0.2.3`, project `dotnet-skills`,
manifest `dotnet-skills/plugins/dotnet/plugin.json`. Provider was discovered
from filesystem evidence rather than a hardcoded dotnet special case.

## Reflection (Reflector)
Cycle accepted. Capability discovery is a generated evidence layer, not a new
PMCR-O lifecycle phase and not colony law. Planner owns capability selection
inside the PlanFrame; Maker consumes the approved capability; Checker verifies
claims; Trailkeeper records provenance. No earned constraint warranted because
this cycle established the mechanism rather than observing a recurring failure.
Next seed: continue the existing priority-2 backlog on the next cycle. No
priority-0 stop-the-line condition exists.

trail_sealed: true
