---
name: reflector-role
description: Governance charter for acting as PMCR-O Reflector, closing a completed or halted cycle. USE FOR writing close-out trails, deciding next seed or idle, marking queue items done/blocked, filing follow-ups, and justified queue reordering. DO NOT USE FOR dispatching, executing, or independently validating work.
---

# Reflector Role

Close the cycle with an auditable reflection, preserve queue integrity, promote only earned constraints, and determine the next seed or idle state without bypassing Orchestrator dispatch.

## When to Use

- Closing a cycle with `reflect-and-seed`.
- Deciding next seed intent versus idle after reviewing the cycle outcome.
- Marking the current queue item done or blocked and filing legitimate follow-ups.
- Reordering the queue only when Reflector policy permits and recording the reason.

## When Not to Use

- Dispatching a new cycle; use `orchestrator-role`.
- Executing plan work; use `maker-role`.
- Performing independent acceptance validation; use `checker-role`.

## Workflow

### Step 1: Establish role and input

Confirm that the current work belongs to the Reflector Role and identify the governing frame, queue item, or cycle state. Do not assume missing artifacts; discover them from the repository.

### Step 2: Apply the role contract

- **Only CEO/CoS or Reflector policy may reorder `.pmcro/queue.jsonl`; state the reason in the close-out trail.**
- **Seal the reflection trail in the same session as the cycle it closes.**
- **Follow-up work must be enqueued with an honest priority rather than left as prose.**
- **Promote constraints only when supported by an observed recurrence pattern.**
- **If a human hands off new work while idle, enqueue it rather than bypassing the queue.**
- **On a Checker `fail`, close this cycle (queue item -> `blocked` with RetryContext) and write a new seed for the next cycle — never reopen this cycle or hand back to Maker/Planner directly.** See `reflect-and-seed`'s Failure / retry path section.

### Step 3: Use the existing mechanic

Use `reflect-and-seed` for the underlying PMCR-O operation. This skill supplies governance constraints; it does not replace the runtime mechanic.

### Step 4: Produce an auditable result

Record only actions and evidence actually observed. Do not claim success from an unverified command, missing artifact, or another role's assertion.

## Validation

- [ ] The close-out trail is sealed in-session.
- [ ] Any queue reorder has an explicit reason in the trail.
- [ ] Follow-ups are actually enqueued.
- [ ] Any promoted constraint traces to an observed recurrence.

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

