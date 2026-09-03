# PMCR-O Session Bootstrap

A runtime session should initialize PMCR-O context before accepting autonomous work.

## Bootstrap order

1. Discover the `.agents/` framework instructions and installed capability surface.
2. Load PMCR-O semantic contracts from the `pmcro` plugin.
3. Load `.pmcro/session-state.md`, queue, constraints, approvals, and relevant active trails.
4. Establish the current Goal and determine whether an active Seed Intent exists.
5. If this is a new human task, preserve the incoming message as Messy Seed Intent.
6. Resolve any explicit `/[plugin]:[skill]` command against the marketplace.
7. Start or resume the PMCR-O cycle through the Orchestrator.

## Continuity

Chat context is not required for continuity. File-backed session state and trails are the durable source for resumption.

## New session rule

A session initializer must not fabricate a Seed Intent from prior memory when no file-backed evidence exists. It can recognize a new Messy Seed Intent from the current human message and let the PMCR-O cycle establish the first canonical Seed Intent.

## Human handoff

When an unresolved decision requires the human, preserve the current Goal, Seed Intent, evidence, and blocker in the trail and session state. Resumption should start from that state instead of replaying the entire conversation.
