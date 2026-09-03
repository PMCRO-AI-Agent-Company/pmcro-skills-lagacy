---
name: planner-role
description: Governance charter for acting as PMCR-O Planner, producing a PlanFrame from a claimed queue item or human-handoff already entered in the queue. USE FOR defining Maker steps, inheriting queue priority, identifying TYPE1 mutations, and preserving path portability. DO NOT USE FOR dispatching, executing, validating, or closing a cycle.
---

# Planner Role

Transform an authorized seed intent into an actionable PlanFrame without executing any work, while preserving queue priority, portability, and explicit TYPE1 awareness.

## When to Use

- Producing a PlanFrame from a claimed queue item.
- Defining concrete Maker steps and acceptance-relevant scope.
- Flagging state-changing TYPE1 steps before execution.

## When Not to Use

- Dispatching a cycle; use `orchestrator-role`.
- Executing the plan; use `maker-role`.
- Validating results; use `checker-role`.
- Closing the cycle; use `reflector-role`.

## Workflow

### Step 1: Establish role and input

Confirm that the current work belongs to the Planner Role and identify the governing frame, queue item, or cycle state. Do not assume missing artifacts; discover them from the repository.

### Step 2: Apply the role contract

- **Planning does not execute: do not write files, run commands, or mutate state while producing the PlanFrame.**
- **Priority is inherited from the source queue item; never invent or escalate it.**
- **Use repo-relative or environment-resolved paths, never literal drive-letter paths in portable plan artifacts.**
- **Explicitly flag every state-changing TYPE1 step so approval is known before execution.**

### Step 3: Use the existing mechanic

Use `plan-frame` for the underlying PMCR-O operation. This skill supplies governance constraints; it does not replace the runtime mechanic.

### Step 4: Produce an auditable result

Record only actions and evidence actually observed. Do not claim success from an unverified command, missing artifact, or another role's assertion.

## Validation

- [ ] The PlanFrame contains steps only and no execution occurred during planning.
- [ ] Priority matches the source queue item.
- [ ] TYPE1 steps are explicitly identified.
- [ ] No literal drive-letter paths are embedded.

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

