# pmcro-skills

Canonical PMCR-O meta-governance skill repo for this colony.

Holds cross-repo rules that apply regardless of which concrete PMCR-O
implementation is running the cycle:

- `colony-laws.md` — dispatch, queue, mutation/trail, and portability rules
- `trail-format.md` — sealed-trail schema classes (do not assume one
  schema is global; check the concrete runtime's own convention)
- `skills/` — meta-governance skills that operate across repos
- `.agents/` — this repo's own agent roster (Orchestrator, Planner,
  Maker, Checker, Reflector) so it can run its own PMCR-O cycles
  autonomously
- `.pmcro/` — this repo's own colony queue, session-state, and trails
  — self-contained, does not read or write another repo's queue

## Self-containment

This repo makes no reference to, and holds no dependency on, any
specific sibling project's path or state. Cross-repo trail-schema
differences are documented as generic schema classes in
`trail-format.md`, not by naming or linking a specific external repo.
