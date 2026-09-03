# Trail: cycle-20260902-221212-task-never-idle-policy

trail_id: cycle-20260902-221212-task-never-idle-policy
task_id: task-never-idle-policy
domain: 
priority: 2
opened: 2026-09-02
engine_generated: true

## Seed intent
Change reflect-and-seed's idle disposition from a passive default to a justified one: before setting session-state status:idle, Reflector must actively check for a next seed intent -- backlog/priority-4 opportunistic items in queue.jsonl, known gaps in earned constraints (.pmcro/constraints/), unresolved earlier-session notes -- and record in the trail why none qualify. Only a priority-0 stop-the-line condition should halt auto-run.

## PlanFrame (Planner)
1. Inspect the reflector and orchestrator mechanics plus queue schema.
2. Make idle a justified disposition: inspect queue, constraints, and unresolved notes.
3. Clarify that queue-empty is not itself a priority-0 stop condition.
4. Validate the changed mechanics and preserve file-backed continuity.

Success criteria: the policy is explicit in reflector/orchestrator documentation and the deterministic dispatch message no longer treats queue-empty as stop-the-line.

## MakeFrame (Maker)
Updated `.agents/skills/reflect-and-seed/SKILL.md`, `.agents/skills/orchestrate/SKILL.md`, and `engine/run-cycle.ps1` using native file writes. The reflector now has explicit pre-idle checks and must record why no seed qualifies; orchestrate documents priority-0 as the auto-run stop condition; the deterministic driver distinguishes an empty dispatch snapshot from stop-the-line.

## CheckFrame (Checker)
PASS — reflector policy explicitly checks open backlog including priority 4, `.pmcro/constraints/`, and unresolved session notes before idle.
PASS — orchestrate states that auto-run stops only on priority-0 stop-the-line conditions and preserves TYPE1 approval.
PASS — run-cycle no longer labels an empty dispatch snapshot as a stop condition.
PASS — deterministic engine restored from the canonical `agent-skills/plugins/pmcro-loop` implementation; cycle claim and trail allocation execute successfully.

## Reflection (Reflector)
Outcome: done.

The repository had open priority-2 work when this cycle was claimed, so idle was not appropriate. The policy now makes that reasoning explicit for future cycles. The next cycle remains file-driven: session state is active until this cycle is closed, then the remaining queue can be dispatched by Orchestrator.

Lessons: distinguish dispatch mechanics from the higher-level Reflector disposition. Queue emptiness at one instant is not equivalent to a priority-0 stop-the-line condition.

trail_sealed: true
