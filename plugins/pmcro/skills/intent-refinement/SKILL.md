---
name: intent-refinement
description: Refine messy seed intent into the best current Seed Intent using the PMCR-O cycle and preserve intent lineage. Invoke with /pmcro:intent-refinement.
---

# PMCR-O Intent Refinement

Transform intent through the loop rather than demanding a perfect task statement up front.

## Refinement contract

1. Accept the raw human message as Messy Seed Intent.
2. Derive the first Seed Intent from the available evidence, constraints, and desired outcome.
3. Execute the PMCR-O cycle against that Seed Intent.
4. Record what the cycle learned, changed, verified, or rejected.
5. Have the Reflector produce the next Seed Intent when another cycle is warranted.
6. Carry the lineage forward so every Seed Intent can be traced to the original human input and prior reflections.

The next Seed Intent is a hypothesis for the next cycle, not a declaration that the prior interpretation was perfect.

## Refinement principles

- Preserve the human Goal while allowing the operational Seed Intent to change.
- Prefer clarification through evidence and checking over speculative assumptions.
- Do not silently replace a human objective with a locally convenient task.
- Do not broaden mutation scope merely because a new interpretation is attractive; governed TYPE1 approval still applies.
- Stop refining when the objective is complete, converged, blocked, or requires human decision.
