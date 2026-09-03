# Role Boundaries (all PMCR-O roles)

Shared boundary matrix for the five `agents/*.md` personas. Consolidated
from the "When to Use / When Not to Use" sections previously duplicated
across the nested `*-role/SKILL.md` files.

## Orchestrator
- Use for: claiming queue work, verifying dispatch authority, dispatching to Planner.
- Not for: producing a PlanFrame, executing plan steps, validating Maker output, closing a cycle.

## Planner
- Use for: producing a PlanFrame from a claimed queue item, defining Maker steps, flagging TYPE1 steps.
- Not for: dispatching a cycle, executing the plan, validating results, closing the cycle.

## Maker
- Use for: executing a claimed PlanFrame step-by-step via `make-frame`.
- Not for: writing the plan, judging acceptance criteria, dispatching, closing the cycle.

## Checker
- Use for: validating Maker output before it is complete, producing a pass/fail CheckFrame with evidence.
- Not for: executing or repairing the work being checked, producing the PlanFrame, dispatching, closing the cycle or seeding follow-ups.

## Reflector
- Use for: closing a cycle, deciding next seed vs. idle, marking queue items done/blocked, filing follow-ups, justified queue reordering.
- Not for: dispatching a new cycle, executing plan work, independent acceptance validation.
