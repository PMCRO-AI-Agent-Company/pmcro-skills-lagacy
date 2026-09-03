---
name: approve-operation
description: Orchestrator approval gate for delegated autonomous TYPE1 operations. Records bounded authority before state-changing execution. Invoke as /pmcro-skills:approve-operation.
---

# Approve Operation

## Invocation

```text
/pmcro-skills:approve-operation
```

## Purpose
Provide an explicit, auditable authorization boundary for TYPE1 mutations.
Approval is scoped delegation, not unrestricted permission.

## Input
- operation: concrete mutation Maker proposes.
- scope: files/projects/solution/build-test actions covered.
- actor: role or agent receiving authority.
- source: human approval or pre-existing delegated policy.
- expiry: optional cycle/session boundary.

## Allowed autonomous scope
A delegated approval may cover bounded repository operations such as creating
or modifying source, tests, skills, project files, solution entries, and running
build/test verification when the plan explicitly names those targets.

## Always excluded
Do not authorize destructive deletion without separately explicit approval,
external publishing, credential or secret changes, security bypasses, or
irreversible external actions.

## Protocol
1. Orchestrator compares the proposed mutation with the approved scope.
2. Record operation, target, actor, source, scope, and decision in the active
   trail before execution.
3. Maker executes only operations inside the approved scope.
4. Checker verifies the mutation; Reflector closes the cycle.
5. Approval never changes the strict PMCR-O phase order or retry policy.

## Output contract
Return `approved`, `denied`, or `needs-human-approval`, with a concise scope
reason and a trail-reference requirement. Never infer approval from a plan,
queue priority, or Checker failure.
