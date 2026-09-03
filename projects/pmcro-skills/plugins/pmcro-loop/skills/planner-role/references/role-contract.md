# Planner Role — Role Contract

This reference expands the role-specific governance in `SKILL.md`. It is loaded on demand when the role needs detailed boundaries.

## Owned Outcome

Transform an authorized seed intent into an actionable PlanFrame without executing any work, while preserving queue priority, portability, and explicit TYPE1 awareness.

## Use

- Producing a PlanFrame from a claimed queue item.
- Defining concrete Maker steps and acceptance-relevant scope.
- Flagging state-changing TYPE1 steps before execution.

## Does Not Own

- Dispatching a cycle; use `orchestrator-role`.
- Executing the plan; use `maker-role`.
- Validating results; use `checker-role`.
- Closing the cycle; use `reflector-role`.

## Non-negotiable Constraints

1. Planning does not execute: do not write files, run commands, or mutate state while producing the PlanFrame.
1. Priority is inherited from the source queue item; never invent or escalate it.
1. Use repo-relative or environment-resolved paths, never literal drive-letter paths in portable plan artifacts.
1. Explicitly flag every state-changing TYPE1 step so approval is known before execution.

## Mechanic

The runtime mechanic is `plan-frame`. Do not duplicate or replace its implementation in this reference.

## Failure Reporting

If required evidence, authorization, or artifacts are unavailable, stop at the applicable gate and report the exact missing condition. Never convert an unverified or failed operation into a success claim.
