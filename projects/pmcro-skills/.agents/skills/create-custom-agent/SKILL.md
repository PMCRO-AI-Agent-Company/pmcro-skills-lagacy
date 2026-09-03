---
name: create-custom-agent
description: Creates or scaffolds an agent persona for this `.agents` workspace. Use when adding a new role under `.agents/agents/`, defining an agent's purpose, tool boundary, operating rules, or handoff responsibility. Aligns agent definitions with the repository's current PMCR-O roles and conventions. Do not use for reusable task skills under `.agents/skills/` or for editing an existing agent's behavior when a direct edit is sufficient.
---

# Create Custom Agent

Create a focused agent persona that fits this repository's PMCR-O system.

## When to Use

- Add a new agent role under `.agents/agents/`
- Define a persona's responsibility and operating boundary
- Decide which tools the role needs
- Establish handoff or ownership rules for a new role

## When Not to Use

- Creating a reusable task procedure under `.agents/skills/`: use `create-skill`
- Changing an existing agent: edit that agent directly unless the change is a structural redesign
- Changing the PMCR-O workflow itself: use the relevant cycle skill

## Current Repository Convention

Agent definitions live here:

```text
.agents/agents/
├── orchestrator.md
├── planner.md
├── maker.md
├── checker.md
└── reflector.md
```

These are repository-specific instruction/persona files consumed by the PMCR-O engine. Do not substitute a VS Code `.agent.md` schema unless this repository is explicitly being migrated to that format.

## Inputs

| Input | Required | Description |
|---|---|---|
| Agent name | Yes | Lowercase role-oriented filename stem |
| Responsibility | Yes | The work this agent owns |
| Boundaries | Yes | What it must not own or modify |
| Tools | Recommended | Smallest tool set needed |
| Handoffs | Recommended | Which role receives the result |

## Workflow

### Step 1: Inspect neighboring agents

Read the existing files in `.agents/agents/` and identify the closest role.

Do not duplicate an existing responsibility. If the new role overlaps another role, either narrow it or update the existing role instead.

### Step 2: Define one clear responsibility

The agent should have one primary ownership statement.

Use explicit boundaries such as:
- what repository/state it may inspect;
- what it may modify;
- what it must not modify;
- which agent owns the next stage.

Avoid broad personas such as "general developer" when a narrower role is sufficient.

### Step 3: Choose the minimum tools

Grant only tools required by the responsibility.

Typical current roles use:

```yaml
tools:
  - Read
  - Grep
  - Glob
```

Add `Bash`, `Edit`, or `Write` only when the role actually needs them.

### Step 4: Write the agent file

Create:

```text
.agents/agents/<agent-name>.md
```

Use the repository's current simple frontmatter:

```yaml
---
name: <agent-name>
description: <one-line responsibility and boundary>
tools:
  - Read
  - Grep
  - Glob
---
```

Then write concise operating instructions below the frontmatter.

### Step 5: Define handoff behavior

State:
- what input the agent expects;
- what artifact/result it produces;
- who consumes that result;
- whether it may execute, modify, validate, or only report.

Do not give a Checker permission to fix the work it is checking. Do not give a Planner execution responsibility. Preserve the current separation of plan → make → check → reflect.

### Step 6: Validate

- [ ] Filename is under `.agents/agents/` and ends in `.md`
- [ ] `name` matches the role/file convention
- [ ] Description states responsibility and scope
- [ ] Tools are no broader than necessary
- [ ] Repository/state boundaries are explicit
- [ ] Ownership does not duplicate another agent
- [ ] Handoff/output is explicit
- [ ] No VS Code-only frontmatter was copied into this repository without a migration requirement
- [ ] YAML frontmatter parses

## Common Pitfalls

| Pitfall | Solution |
|---|---|
| Copying `.agent.md` examples from another host | Follow this repository's `.agents/agents/*.md` convention |
| Agent has overlapping ownership | Narrow the responsibility or update the existing role |
| Every agent gets write tools | Grant only the minimum required tools |
| Checker fixes what it finds | Checker reports findings; Maker owns fixes |
| Planner executes commands | Planner produces the plan; Maker executes |
| Absolute repository paths are embedded | Use the current workspace/repository context |
| Agent claims work it did not perform | Report only actions and validation actually completed |
