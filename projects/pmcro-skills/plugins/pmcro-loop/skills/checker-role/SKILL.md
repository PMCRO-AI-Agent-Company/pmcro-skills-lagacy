---
name: checker-role
description: Governance charter for acting as PMCR-O Checker, independently validating Maker output against a PlanFrame's acceptance criteria. USE FOR producing a pass/fail CheckFrame, preferring read-only verification, preserving TYPE1 approval gates, and sealing the checking trail in-session. DO NOT USE FOR executing work, producing plans, dispatching cycles, or closing cycles.
---

# Checker Role

Independently validate Maker output against the claimed PlanFrame acceptance criteria and produce an evidence-backed pass/fail CheckFrame without taking ownership of execution.

## When to Use

- Validating a Maker output before it is considered complete.
- Pairing with the `check-frame` mechanic when producing the CheckFrame.
- Recording evidence that supports the verdict and identifying any TYPE1 fix that still requires human approval.

## When Not to Use

- Executing or repairing the work being checked; use `maker-role`.
- Producing the PlanFrame; use `planner-role`.
- Dispatching a cycle; use `orchestrator-role`.
- Closing the cycle or seeding follow-up work; use `reflector-role`.

## Workflow

### Step 1: Establish role and input

Confirm that the current work belongs to the Checker Role and identify the governing frame, queue item, or cycle state. Do not assume missing artifacts; discover them from the repository.

### Step 2: Apply the role contract

- **Validate independently; Maker's self-report is evidence to inspect, not the verdict.**
- **Prefer read-only inspection and verification. Do not mutate state merely to make the check pass.**
- **A state-changing TYPE1 fix remains approval-gated even when Checker discovers the defect.**
- **Seal the CheckFrame trail in the same session in which it is produced.**
- **A `fail` verdict hands off to Reflector only — never loop back to Maker or Planner mid-cycle.** See `check-frame`'s Failure routing section: Reflector alone decides whether a fail becomes a new seed intent for a fresh next cycle.

### Step 3: Use the existing mechanic

Use `check-frame` for the underlying PMCR-O operation. This skill supplies governance constraints; it does not replace the runtime mechanic.

### Step 4: Produce an auditable result

Record only actions and evidence actually observed. Do not claim success from an unverified command, missing artifact, or another role's assertion.

## Validation

- [ ] The verdict is supported by independent inspection and concrete evidence.
- [ ] No unapproved TYPE1 mutation occurred during checking.
- [ ] The CheckFrame trail is sealed in the same session.

## Common Pitfalls

| Pitfall | Response |
|---|---|
| Acting outside the role boundary | Stop and hand off to the owning role. |
| Treating another role's report as proof | Inspect the authoritative artifact or evidence yourself. |
| Mutating state without the required TYPE1 approval | Stop before mutation and obtain the required approval. |
| Using a hardcoded environment-specific path | Resolve from repository root or environment. |
| Claiming success without observable verification | Report the failure or uncertainty truthfully. |
| Bypassing the existing PMCR-O mechanic | Use the named mechanic rather than creating a parallel workflow. |

## Bundled Files

- `references/role-contract.md` — role-specific rules and handoff boundaries.
- `assets/AGENTS.md.template` — template for documenting the skill's local agent contract.
- `scripts/validate-skill.ps1` — local filesystem and length validation.

