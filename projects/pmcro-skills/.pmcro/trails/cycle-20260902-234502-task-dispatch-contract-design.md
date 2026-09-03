# Trail: cycle-20260902-234502-task-dispatch-contract-design

trail_id: cycle-20260902-234502-task-dispatch-contract-design
task_id: task-dispatch-contract-design
domain: 
priority: 2
opened: 2026-09-02
engine_generated: true

## Seed intent
Formalize cycle dispatch contract, explicit orchestrate args, capped cycle_count, per-role turn checks, and TYPE1 approval behavior.

## Approval
- decision: approved
- source: human message `approve`
- scope: task-dispatch-contract-design
- actor: Orchestrator -> Planner -> Maker -> Checker -> Reflector
- boundary: bounded PMCR-O dispatch/governance files; no destructive deletion, secrets, external publishing, or security bypass

## PlanFrame (Planner)
Approved to formalize the dispatch contract while preserving strict phase order.
Define explicit `orchestrate` inputs, a small capped `cycle_count`, per-role turn checks, and a non-bypass TYPE1 approval boundary.
Validation must include the existing queue command contract and full solution tests.

## MakeFrame (Maker)
Implemented the dispatch contract in `orchestrate` and `run-queue` documentation and added the authoritative `references/dispatch-contract.md`.
The contract fixes `cycle_count` at 1..4, caps `until_queue_empty` at 4, requires cycle/task/phase context for each role turn, rejects stale/wrong-phase handoffs, and requires recorded TYPE1 approval before Maker execution.

## CheckFrame (Checker)
verdict: pass
findings: none
blockers: none
- Dispatch contract reference exists and is linked from `orchestrate`.
- `cycle_count` is explicitly bounded to 1..4 and `until_queue_empty` is capped at 4.
- Per-role turn context and stale/wrong-phase rejection are explicitly specified.
- TYPE1 approval remains required before Maker execution.
- Full solution test suite passed: 5/5, 0 failures, 0 skipped.

## Reflection (Reflector)
Outcome: complete. The dispatch contract is now explicit and bounded without changing the PMCR-O lifecycle or TYPE1 safety boundary.
Lesson: keep deterministic claim/trail allocation separate from model reasoning, and make cycle limits and phase provenance file-backed.
No follow-up seed is required from this task; remaining queue work is independent.

trail_sealed: true