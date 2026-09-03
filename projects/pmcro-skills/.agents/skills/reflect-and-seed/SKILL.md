---
name: reflect-and-seed
description: Close the cycle. Write trail, promote earned constraints, set the next Seed Intent or terminal status, mark queue item done/blocked, and optionally enqueue follow-ups. This is the autonomy engine. Invoke as /pmcro-skills:reflect-and-seed.
---

# Reflect and Seed

## Invocation

```text
/pmcro-skills:reflect-and-seed
```

Use `/pmcro-skills:queue-enqueue` for follow-up queue writes. Consult `/pmcro:intent-refinement` for the semantic intent-handoff contract.

## Inputs
- PlanFrame, MakeFrame, CheckFrame
- Current task_id from session-state
- Current Goal and Seed Intent

## Actions
1. **Trail** — write under `.pmcro/trails/<cycle-id>.md` summarizing plan / make / check / outcome / lessons and preserve the intent transition.
2. **Earned constraints** — if Checker or experience produced durable rules, write under `.pmcro/constraints/`.
3. **Queue item** — set status `done` or `blocked` on the claimed task in `queue.jsonl`.
4. **Next seed** — the Reflector is the default producer of the next Seed Intent.
   - Before choosing `idle`, inspect the queue for any open backlog, including priority-4 opportunistic work.
   - Inspect `.pmcro/constraints/` for known gaps or newly surfaced constraints that imply follow-up work.
   - Inspect current session notes and unresolved earlier-session notes for unfinished work.
   - If the Goal remains unresolved and a next operational step is justified, produce a new Seed Intent that carries forward the relevant evidence, constraints, and lessons; do not repeat the prior seed verbatim unless repetition is itself justified.
   - If a natural follow-up exists, enqueue it via `/pmcro-skills:queue-enqueue` and record the resulting Seed Intent/lineage.
   - If the Goal is converged or complete with no qualifying follow-up, set `status: idle` and record why no next seed qualified in the trail.
5. **Lessons** — short note for future Planners.

## Failure / retry path

When the closing CheckFrame's `verdict` is `fail`:
1. Do **not** reopen this cycle or hand control back to Maker/Planner — the cycle closes exactly like any other.
2. Mark the claimed queue item `blocked` (not `done`), carrying a `RetryContext` note: which acceptance criterion failed, Checker's findings/blockers, and the recommendation (`retry` | `escalate`).
3. Write the next Seed Intent as a **new** cycle seed derived from the original intent plus the RetryContext, rather than re-running the same seed verbatim — Planner needs the failure context on the next pass.
4. `escalate` recommendations still produce a seed (do not silently drop to idle); note escalation in the trail so a human can intervene before the next cycle dispatches, if warranted.
5. Orchestrator, not Reflector, dispatches that next cycle fresh to Planner — Reflector only writes the seed and closes.

## Auto-run stop condition
A queue-looking-empty condition is not by itself a stop-the-line condition. An auto-run may halt for a **priority-0 stop-the-line condition** (for example a Checker hard fail or security issue). Human handoffs must enter through the queue, so Reflector must justify any idle disposition from the file-backed checks above rather than treating an empty snapshot as proof that work is complete.

## Autonomy contract
The next cycle must be able to start from files alone (session-state + queue) in this repo. Chat memory is not required for continuity.
