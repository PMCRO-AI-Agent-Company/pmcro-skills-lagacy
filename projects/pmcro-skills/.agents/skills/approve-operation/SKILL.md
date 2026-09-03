---
name: approve-operation
description: Orchestrator approval gate for delegated autonomous TYPE1 operations. Persists bounded authority and enforces fail-closed scope checks. Invoke as /pmcro-skills:approve-operation.
---

# Approve Operation

## Invocation

```text
/pmcro-skills:approve-operation
```

## Purpose
Provide an explicit, auditable authorization boundary for TYPE1 mutations.
Approval is scoped delegation, not unrestricted permission.

## Inputs
- `operation_id`: stable id for the concrete proposed mutation.
- `operation`: concrete mutation Maker proposes.
- `scope[]`: exact repository-relative targets covered.
- `actor`: role or agent receiving authority.
- `source`: `human` or named pre-existing delegated policy.
- `expiry`: optional ISO-8601 expiry.
- `trail_id`: required when decision is approved.
- `destructive`: true for deletion or other irreversible state changes.
- `decision`: `approved`, `denied`, or `needs-human-approval`.

## Decision rules
1. Bounded non-destructive repository mutations may be approved by an applicable delegated policy.
2. Destructive or irreversible mutations require explicit `source: human` approval.
3. Secrets/credentials, security bypasses, external publishing, and unrelated external actions are never covered by this gate.
4. Missing, expired, denied, or scope-mismatched approval fails closed.
5. Approval is valid only for the exact `operation_id`, actor, and targets covered by `scope[]`.

## Persistence
The deterministic engine stores append-only records in `.pmcro/approvals.jsonl` using the schema in `.pmcro/approvals.schema.md`.
Use `plugins/pmcro-loop/scripts/approve-operation.ps1` to record a decision; do not edit the ledger manually.

## Enforcement
Before Maker performs a TYPE1 mutation, Orchestrator must require a matching unexpired approval with `Test-PmcroApproval`.
Maker must not execute a mutation when the check returns false.
An approval record is not permission to expand scope during execution.

## Protocol
1. Orchestrator compares the proposed mutation with applicable policy.
2. Produce `needs-human-approval` when explicit human authorization is required and absent.
3. Persist the decision, operation, target scope, actor, source, expiry, and trail reference before execution.
4. Maker executes only operations covered by the persisted approval.
5. Checker verifies the mutation; Reflector closes the cycle.
6. Approval never changes the strict PMCR-O phase order or retry policy.

## Output contract
Return `approved`, `denied`, or `needs-human-approval`, with a concise scope reason and trail reference. Never infer approval from a plan, queue priority, or Checker failure.
