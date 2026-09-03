# PMCR-O Dispatch Contract

## Orchestrate inputs
`orchestrate` accepts:
- `seed_intent`: optional structured seed; a human message may instead arrive as Messy Seed Intent and be normalized into the first seed.
- `task_id`: optional; must resolve to an eligible queue item.
- `cycle_count`: optional positive integer; default `1`, maximum `4`.
- `until_queue_empty`: optional boolean; if true, run at most `4` cycles.
- `approval`: optional delegated TYPE1 scope; never inferred from queue priority.

## Intent model
The durable `goal` belongs to the Orchestrator. The current `seed_intent` is the operational hypothesis for the active cycle. After a cycle, Reflector may produce the next `seed_intent`. The original human input remains preserved as Messy Seed Intent in the intent lineage.

## Dispatch order
1. Orchestrator reads session, queue, constraints, and active trail.
2. Orchestrator dispatches exactly one current role at a time.
3. Planner produces PlanFrame; no execution.
4. Maker executes only approved PlanFrame steps.
5. Checker independently validates; no fixes.
6. Reflector closes the cycle and produces the next Seed Intent or a terminal/converged status.

## Turn checks
Each role must receive the current `goal`, `seed_intent`, `cycle_id`, `task_id`, phase name, and the prior phase artifact. A role may write only its own frame. A stale cycle or wrong phase is rejected rather than silently advanced.

## TYPE1 boundary
A TYPE1 step requires an approval record in the active trail before Maker executes it. Approval must name operation, target, actor, source, and scope. Destructive deletion, secrets, external publishing, security bypasses, and irreversible external actions remain separately gated.

## Cycle cap
`cycle_count` is bounded to `1..4`. `until_queue_empty` uses the same hard cap. A new cycle cannot begin until the previous trail is sealed. A Checker failure closes the cycle through Reflector and can only seed a fresh retry cycle.

## Autonomy
The human does not need to provide a new seed after every cycle. When another cycle is warranted, Reflector writes the next Seed Intent and Orchestrator dispatches it, subject to cycle limits and stop conditions.
