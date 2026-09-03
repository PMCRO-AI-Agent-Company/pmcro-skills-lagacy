# Trail: cycle-20260903-marketplace-dotnet-gap-correction

trail_id: cycle-20260903-marketplace-dotnet-gap-correction
task_id: task-marketplace-capability-alignment
domain: pmcro-governance
priority: 1
opened: 2026-09-03
engine_generated: false

## Seed intent (verbatim, human, immutable provenance)
"I want PMCR-O to bring this repository's Agent Skills and marketplace
capability system into alignment with the current PMCR-O architecture...
[full text preserved in chat transcript this cycle] ... use a
representative domain operation such as building a .NET MAUI application
and ask whether the current capability ecosystem can correctly discover
and compose the required capabilities without pretending that a
nonexistent specialized skill exists."

## PlanFrame (Planner)
Inspected before planning: three marketplace.json copies, plugins.lock.json,
projects/ tree, LAYOUTS.md, AGENTS.md, pmcro-skills:approve-operation gate.
Findings:
1. `.cursor-plugin/marketplace.json` missing `pmcro` entry (present in the
   other two copies) -- manifest drift.
2. All three marketplace copies advertised 16 `dotnet-*` plugins sourced at
   `./projects/dotnet-skills/plugins/*`. `projects/dotnet-skills` does not
   exist on disk; no `.gitmodules`; not referenced in `plugins.lock.json`
   (which only ever pinned the 6 first-party plugins).
3. `LAYOUTS.md` documents `dotnet-skills` as an example of the
   generator -> domain-product mechanism (agent-skills generates domain
   marketplaces like it), i.e. intended future generated output, not
   committed first-party content -- explains the gap, doesn't excuse the
   false advertisement.
4. `.agents/skills/create-skill` / `create-custom-agent` (session tooling)
   share short names with `pmcro-skills:create-skill` /
   `create-custom-agent` (PMCR-O governed) -- undocumented namespace
   collision risk.
5. `plugins/pmcro/scripts/` empty, untracked (`git ls-files` empty),
   history ends at the commit that migrated plugin-level scripts to
   skill-local `scripts/` dirs; zero references (`git grep` empty).
Plan: (1) sync `pmcro` into cursor manifest, (2) remove unmaterialized
`dotnet-*` entries from all three manifests -- correcting the advertised
surface, not deleting the generator concept in LAYOUTS.md, (3) document
the namespace distinction in AGENTS.md, (4) remove the stale empty
scripts dir if untracked/unreferenced, (5) re-run discovery and verify.
Destructive-mutation flag: change (2) alters advertised capability
surface -- routed to human for explicit approval per
pmcro-skills:approve-operation rule 2 before Maker executed anything.
approval: source=human, scope=[marketplace manifests x3, AGENTS.md,
plugins/pmcro/scripts], decision=approved (explicit chat message)

## MakeFrame (Maker)
1. Added `pmcro` entry to `.cursor-plugin/marketplace.json`.
2. Removed all 16 `dotnet-*` entries from `.claude-plugin/marketplace.json`,
   `.agents/plugins/marketplace.json`, `.cursor-plugin/marketplace.json`.
   Left `LAYOUTS.md`'s generator/domain-product documentation untouched.
3. Added "Namespace distinction" section to `AGENTS.md` documenting
   `.agents/skills/<name>` vs `/pmcro-skills:<name>` addressing.
4. Attempted removal of `plugins/pmcro/scripts/`: blocked, file in use by
   another process (editor/IDE lock). Left in place; follow-up item.

## CheckFrame (Checker)
Independent verification via fresh PowerShell processes (not reused from
Maker):
- Parsed all three marketplace.json copies; plugin name sets identical
  (6 entries each: agentskills, agentskills-template-engine,
  agent-design-patterns, pmcro, pmcro-loop, pmcro-skills). SYNCHRONIZED.
- Every advertised `source` path resolved to a real directory on disk
  (Test-Path true for all 6).
- Compared marketplace name set against `plugins.lock.json`: exact match,
  no additions/removals required to the lockfile.
- MAUI validation: queried marketplace for any `*maui*`/`*dotnet*` entry
  -> none found. `projects/dotnet-skills` confirmed still absent. Prior
  false-discovery condition (dotnet-maui advertised with no resolvable
  source) is closed; the generator path to materialize it later remains
  documented and untouched.
- `git status --porcelain` reviewed in full: only the 4 intended files
  touched, plus 3 pre-existing unrelated dirty `.csproj` files (present
  before this cycle, not modified by this cycle -- preserved per AGENTS.md
  "preserve unrelated user changes"). One untracked scratch dir
  (`.pmcro-tmp/`, from an earlier unrelated packaging task) noted, not
  cleaned up without separate instruction.
verdict: pass
findings: plugins/pmcro/scripts removal blocked by file lock (follow-up,
non-blocking); 3 pre-existing unrelated .csproj modifications observed
and correctly left untouched; .pmcro-tmp/ scratch dir present, unrelated
to this cycle
blockers: none
recommendation: accept

## Reflection (Reflector)
Cycle accepted. Capability-surface correction verified end-to-end:
advertised == resolvable == locked, across all three manifest copies.
Missing-capability finding (dotnet-* family) traced to its documented
cause (generator/domain-product pattern never yet run) rather than
treated as arbitrary breakage -- mechanism preserved for future
materialization.

Learned constraint candidate: capability discovery/marketplace-consistency
checks should be re-run as a standing check whenever any marketplace.json
copy is hand-edited, given this is the second time in this repo's trail
history (see cycle-20260903-035500-task-plugin-path-validation) that
manifest drift was found and corrected. Worth promoting to a reusable
skill/script if a third occurrence is observed.

Next Seed Intent: task-pmcro-scripts-dir-cleanup [priority 3, non-
destructive once unblocked] -- retry removal of the now-empty, untracked,
unreferenced `plugins/pmcro/scripts/` directory once it is not locked by
another process (likely an open editor/IDE handle); re-verify with
`git ls-files` and `git grep` immediately before removal in case state
changed. Secondary candidate, not claimed: review the 3 pre-existing
unrelated `.csproj` diffs noted in this cycle's CheckFrame and the
untracked `.pmcro-tmp/` directory, both surfaced but out of this cycle's
scope -- human should decide whether either needs action.

trail_sealed: true
