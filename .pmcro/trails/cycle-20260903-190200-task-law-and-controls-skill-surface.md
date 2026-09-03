# Trail: cycle-20260903-190200-task-law-and-controls-skill-surface

trail_id: cycle-20260903-190200-task-law-and-controls-skill-surface
task_id: task-law-and-controls-skill-surface
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: (filing only -- no build performed this cycle)
checkpoint_ref: (none)
trail_sealed: true

## Seed intent

Human, dictated, two-part message: (1) asked for the correct bootstrap
message to seed a fresh session after loading the `agent-skills`
marketplace, wanting it done better than however this session started;
(2) asked whether law (`colony-laws.md`) and controls/constraints
infrastructure should have dedicated plugin skills/commands, given the
pattern established for queue items via `queue-enqueue`.

## OrchestratorFrame

Part 1 (bootstrap message) answered directly in chat, not filed --
informational, no colony work follows from giving the human a message to
paste elsewhere. Investigated before answering rather than guessing:
read `session-bootstrap.md` (`plugins/pmcro/skills/foundation/
references/`) and `plugins/pmcro/skills/initialize/SKILL.md` --
confirmed `/pmcro:initialize` is the actual documented bootstrap command
(step 7: hands control to Orchestrator after loading session-state,
queue, constraints, approvals, trails, and resolving any unresolved
intake/stale leases first). Also confirmed the marketplace's registered
name is `agent-skills` (`.claude-plugin/marketplace.json`), not
`pmcro-plugin` as the human's dictation phrased it.

Part 2 (law/controls skills) investigated, not assumed: listed
`plugins/pmcro/skills/` and `plugins/pmcro-loop/skills/` directories --
confirmed 5 deterministic engine operations
(`New-PmcroConstraint`/`new-constraint.ps1`, `new-capability-gap.ps1`,
`new-capability-composition.ps1`, `new-retrospective-trail.ps1`,
`new-trail-product.ps1`) have scripts but no skill surface at all (no
SKILL.md, no `skills/<name>/` directory), unlike `queue-enqueue` which
properly wraps its sibling `Add-PmcroQueueItem`. `colony-laws.md` has no
skill wrapping it whatsoever -- this session amended it earlier tonight
via direct file edit, gated only by this agent's own convention of
asking for human confirmation first (via AskUserQuestion), never a
structural requirement. This confirms the human's question named a real,
evidenced gap rather than a hypothetical one.

## MakeFrame

Filed `task-law-and-controls-skill-surface` via `enqueue.ps1` (not
hand-written JSONL), scoping: (1) a constraint-recording skill wrapping
`New-PmcroConstraint`, with an open question about whether the other 4
script-only operations warrant individual skills or one family; (2) a
`law-amend`-style skill for `colony-laws.md` making the
human-confirmation-before-edit requirement structural (a Precondition
section) instead of agent-remembered convention; (3) whether law
amendments should also need a promotion-style evidence bar (multiple
independently-observed instances), mirroring `knowledge-promotion.md`'s
constraint -> rule-policy bar, rather than one cycle's recommendation
being sufficient on its own.

No skills built this cycle -- scoped as filing, consistent with
"resolve findings in a dispatched cycle, not ad hoc," and because
designing 2 new skill families is real scope better started fresh than
appended onto a chat-answer turn.

## CheckFrame
verdict: pass

- `queue.jsonl` line count 39 -> 40; new item confirmed valid JSON with
  expected fields (`status: open`, `priority: 3`, `domain:
  pmcro-governance`).
- Bootstrap recommendation given to the human cross-checked against
  primary source docs (`session-bootstrap.md`, `initialize/SKILL.md`,
  `.claude-plugin/marketplace.json`) rather than reconstructed from
  memory of earlier trails.
- Scratch driver script (`run-enqueue-law-controls-skills.ps1`) removed
  post-run.

## Reflection
outcome: done
next_seed_intent: captured in the filed queue item itself. Standing note
carried forward: human's earlier "autonomous, do as you recommend" grant
is still in effect -- this cycle proceeded through investigation and
filing without pausing to ask, consistent with the two cycles before it.
