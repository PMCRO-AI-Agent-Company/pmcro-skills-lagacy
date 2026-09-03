# Trail: cycle-20260903-181500-task-execution-law-and-runtime-handoff

trail_id: cycle-20260903-181500-task-execution-law-and-runtime-handoff
task_id: task-execution-law-and-runtime-handoff
domain: pmcro-governance
priority: 1
opened: 2026-09-03
run_id: task-execution-law-and-runtime-handoff
checkpoint_ref: interrupts prior trail
  cycle-20260903-175440-task-pmcro-runtime-collision-and-governance mid-way
  through its own next_seed_intent (attempting dotnet build on
  pmcro-runtime's refactor branch)
trail_sealed: true

## Seed intent
Human interrupted an in-progress `dotnet build` attempt in
`pmcro-runtime` to make four points at once: (1) git commits, like `gh`
calls, must go through the plugin marketplace, not raw `git`; (2) an MCP
connector in active use (Desktop Commander) needs the same treatment;
(3) PMCR-O should be explicitly mapped to Anthropic's own agent design
patterns; (4) whether it should be a colony law that execution always
happens inside a dispatched PMCR-O cycle, with Checker-caught errors
resolved via Reflector's `next_seed_intent` in the *next* cycle rather
than patched inline; and separately, a naming decision: the pmcro-runtime
project family should be `AgentsRuntime.*`, not `PmcroRuntime.*`.

## OrchestratorFrame
Self-critique first: the interrupt landed mid-violation. The prior cycle
had already committed straight to `pmcro-skills` with raw `git
commit`/`git push` (point 1, retroactively), and had just edited two
`.csproj` files in `pmcro-runtime` the moment `dotnet build` surfaced an
error, with no Plan step, no queue claim, no Orchestrator dispatch
(point 4, live, in progress). Confirmed rather than assumed via
AskUserQuestion given the stakes (a colony-laws.md edit; a rename that
lands on a branch/commit a second concurrent session actively owns):

- Point 4 -> "yes, add as a new Dispatch clause" (not a new section, not
  deferred to earned-knowledge-first). Distinguished from the earlier
  "script your ad hoc gh calls" judgment call (recorded as a provisional
  *constraint*, not a law): that one was a single-instance, narrow,
  evidence-gradeable procedural habit; this one restates and makes
  explicit what colony-laws.md's Mutation/Handoff protocols already
  implied throughout INSTRUCTIONS.md, is the same shape as the existing
  Dispatch/Mutation sections, and is "already in force" in intent if not
  in explicit text -- exactly colony-laws.md's own bar.
- AgentsRuntime rename -> "enqueue it, don't touch the branch yet."

## MakeFrame
- `colony-laws.md`: added a third Dispatch bullet stating the rule from
  point 4 verbatim (execution always inside a dispatched cycle; Checker
  -> Reflector -> next_seed_intent -> resolved next cycle, not patched
  inline).
- Stopped the in-progress `dotnet build` loop in `pmcro-runtime` rather
  than continuing it. The two XML-comment fixes already made moments
  before the interrupt (`PmcroRuntime.Domain.csproj`,
  `PmcroRuntime.Infrastructure.csproj` -- literal `--` inside `<!-- -->`
  comments, invalid XML) were left in place uncommitted rather than
  reverted (reverting a correct fix helps nobody) or committed ad hoc
  (would repeat the exact violation just named).
- Wrote two seed files into `pmcro-runtime`'s own queue
  (`.pmcro/queue/pending/*.seed.json`, matching that repo's actual
  `{seedId, intent, command, priority, status}` shape -- read two
  existing seeds first rather than inventing one, per this repo's own
  `trail-format.md` caution against assuming a schema):
  `agentsruntime-namespace-rename.seed.json` (blocked-in-intent-text on
  the concurrent session, since no `status: blocked` value is evidenced
  anywhere in that scaffold's docs or examples -- used `pending` and
  said so in the free-text `intent` instead of inventing an enum value)
  and `verify-scaffold-build.seed.json` (carries forward the build/test
  handoff, names the two uncommitted fixes explicitly so the next
  cycle's Maker verifies and commits them rather than rediscovering
  them).
- Points 1-3 (git-through-plugin, Desktop-Commander-needs-a-plugin,
  PMCR-O/Anthropic-pattern mapping) acknowledged in conversation as
  correct and left as backlog, not executed this cycle -- named as
  future queue items rather than scope-crept into tonight's work. Also
  surfaced (not resolved): `pmcro-runtime/.pmcro/README.md`'s own
  Provider rule ("PMCRO adds governance around these providers; it does
  not wrap them merely to rename them") is in some tension with "wrap
  every external tool as a plugin script" and is worth reconciling when
  points 1-2 are actually scoped, not glossed over.

## CheckFrame
verdict: pass

- `colony-laws.md` reads validly as markdown; new bullet placed under the
  existing Dispatch heading it extends, not a stray new section.
- Confirmed `pmcro-runtime` working tree matches exactly what's
  documented: `git status --porcelain` shows only the two `.csproj`
  modifications and the two new queue seed files, nothing else touched,
  still on `refactor/rename-projectname-and-seed-clean-architecture`.
  Nothing was committed or pushed there this cycle.
- Both seed JSON files structurally match the two pre-existing examples
  in that directory (same top-level keys, same nesting under `command`).

## Reflection
outcome: done (law added, ad hoc loop stopped, work hand-off queued
properly); blocked (AgentsRuntime rename, explicitly, pending
coordination with the other session)

next_seed_intent: none for *this* repo's queue right now -- the two
follow-ups live in `pmcro-runtime`'s own queue as seeded above, which is
where PMCR-O work on that repo belongs per this repo's own per-repo
schema ownership (`trail-format.md`: "Each PMCR-O implementation owns its
own trail schema"). If a human wants points 1-3 (git-through-plugin,
Desktop-Commander plugin, Anthropic-pattern mapping doc) scoped and
queued in *this* repo, that's a fresh seed intent, not assumed here.
