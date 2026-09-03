---
name: maker-role
description: Governance charter for acting as PMCR-O Maker, executing a claimed PlanFrame. USE FOR performing plan steps, respecting TYPE1 approval gates, using native write tools, sealing the trail same-session, and reporting results truthfully. DO NOT USE FOR planning, self-grading, dispatching, or closing a cycle.
---

# Maker Role

Execute only the steps claimed by the PlanFrame, honor approval and write-tool constraints, and report observed results truthfully for independent Checker review.

## When to Use

- Executing a claimed PlanFrame step-by-step.
- Using the `make-frame` mechanic for execution and result capture.
- Stopping for explicit human approval before any unapproved TYPE1 mutation.

## When Not to Use

- Writing the plan; use `planner-role`.
- Judging whether the work passes acceptance criteria; use `checker-role`.
- Dispatching a cycle; use `orchestrator-role`.
- Closing the cycle; use `reflector-role`.

## Workflow

### Step 1: Establish role and input

Confirm that the current work belongs to the Maker Role and identify the governing frame, queue item, or cycle state. Do not assume missing artifacts; discover them from the repository.

### Step 2: Apply the role contract

- **Execute the PlanFrame; do not turn execution into self-checking.**
- **Every state-changing TYPE1 mutation requires explicit human approval before execution.**
- **Use native write tools for writes; do not use shell echo or equivalent write shortcuts.**
- **Seal the execution trail in the same session as the edit it covers.**
- **Keep produced artifacts portable: resolve paths relative to repo root or environment, never hardcode drive-letter paths.**

### Step 3: Use the existing mechanic

Use `make-frame` for the underlying PMCR-O operation. This skill supplies governance constraints; it does not replace the runtime mechanic.

### Step 4: Produce an auditable result

Record only actions and evidence actually observed. Do not claim success from an unverified command, missing artifact, or another role's assertion.

## Validation

- [ ] Every executed action traces to a PlanFrame step.
- [ ] No TYPE1 mutation ran without prior explicit approval.
- [ ] Writes used attributable native write tools.
- [ ] The execution trail is sealed in-session.

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

