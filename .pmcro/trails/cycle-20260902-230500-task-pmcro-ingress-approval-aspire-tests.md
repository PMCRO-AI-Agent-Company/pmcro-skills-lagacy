# Trail: cycle-20260902-230500-task-pmcro-ingress-approval-aspire-tests

trail_id: cycle-20260902-230500-task-pmcro-ingress-approval-aspire-tests
task_id: task-pmcro-ingress-approval-aspire-tests
domain: pmcro-governance
priority: 1
opened: 2026-09-02
engine_generated: false

## Seed intent
Make `/send-message` the primary ingress, add Orchestrator approval skill for
bounded autonomous TYPE1 operations, and add Aspire integration-test coverage
for the workflow AppHost.

## Approval
Human instruction received in chat: "okay lets update project". Applied as
explicit approval to implement the previously agreed architecture update.

## PlanFrame (Planner)
Add `/send-message` while retaining `/seed-intent` as a specialized seed
command; add `approve-operation` under `.agents/skills`; preserve bounded
approval exclusions; add `AgentSkills.Workflows.Aspire.Tests` under `tests/`;
register `Aspire.Hosting.Testing` centrally; add the test project to the root
solution; verify restore, build, and test.

## MakeFrame (Maker)
Implemented the command, approval skill, Aspire test project, central package
version, and solution entry. Kept workflow project naming bounded as
`AgentSkills.Workflows.Domain`, `Application`, `Infrastructure`, and `Mcp`.

## CheckFrame (Checker)
PASS. Restore completed. The root solution builds with zero warnings and
zero errors. Aspire integration test build completed and `dotnet test`
reported 1 passed, 0 failed, 0 skipped.

## Reflection (Reflector)
Cycle closed as done. `/send-message` is now the canonical ingress, approval
is an explicit Orchestrator skill, and Aspire topology has a test boundary.
The existing `task-restore-workflow-tests` remains open and is not masked by
this new test project; it still concerns the two historical workflow test
projects lost during the prior flattening cycle.

trail_sealed: true
