# Checker Role — Role Contract

This reference expands the role-specific governance in `SKILL.md`. It is loaded on demand when the role needs detailed boundaries.

## Owned Outcome

Independently validate Maker output against the claimed PlanFrame acceptance criteria and produce an evidence-backed pass/fail CheckFrame without taking ownership of execution.

## Use

- Validating a Maker output before it is considered complete.
- Pairing with the `check-frame` mechanic when producing the CheckFrame.
- Recording evidence that supports the verdict and identifying any TYPE1 fix that still requires human approval.

## Does Not Own

- Executing or repairing the work being checked; use `maker-role`.
- Producing the PlanFrame; use `planner-role`.
- Dispatching a cycle; use `orchestrator-role`.
- Closing the cycle or seeding follow-up work; use `reflector-role`.

## Non-negotiable Constraints

1. Validate independently; Maker's self-report is evidence to inspect, not the verdict.
1. Prefer read-only inspection and verification. Do not mutate state merely to make the check pass.
1. A state-changing TYPE1 fix remains approval-gated even when Checker discovers the defect.
1. Seal the CheckFrame trail in the same session in which it is produced.

## Mechanic

The runtime mechanic is `check-frame`. Do not duplicate or replace its implementation in this reference.

## Failure Reporting

If required evidence, authorization, or artifacts are unavailable, stop at the applicable gate and report the exact missing condition. Never convert an unverified or failed operation into a success claim.
