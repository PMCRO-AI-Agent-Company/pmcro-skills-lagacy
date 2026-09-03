# repo-topology.md — authoritative directory map

This file exists because `CONTEXT.md` drifted out of sync with the real
directory structure and no single doc was responsible for catching that.
It is the one place that documents where things actually live right now.
If you move a top-level directory, update this file in the same trail
that does the move — that discipline is the whole point of the file.

## What changed on 2026-09-03

Before this date the repo had two competing "project root" ideas:
- `projects/pmcro-skills/` (created by commit `7fbbbbc`) held the real,
  live `.NET` solution and the entire live PMCR-O colony state
  (`.pmcro/`, `colony-laws.md`, `CONTEXT.md`, `INSTRUCTIONS.md`, `.agents/`,
  `.github/`, `eng/`, `tests/`) that every session actually operated from.
- `project/` (singular, created by commit `9964a45`) was a frozen,
  intentionally-documented template/example of what a *consumer* repo's
  own root should contain (per the then-current `LAYOUTS.md`).

`CONTEXT.md` itself claimed `colony-laws.md` was "kept at repository root"
and described a separate `P:\agent-skills` monorepo root — neither was
true; both were stale claims describing an earlier, already-abandoned
topology. On explicit human instruction, both `projects/` and `project/`
were deleted, `LAYOUTS.md` was deleted, and everything that mattered from
`projects/pmcro-skills/` was consolidated into this true repo root
(merging file-for-file against anything already at root, preferring
whichever side was more recently and substantively edited — see the
migration trail below for the specific calls made on the 8 real
collisions found).

Migration trail: `.pmcro/trails/` (search for the 2026-09-03 topology
consolidation cycle). Queue item: `task-reconcile-project-vs-projects-topology`.

## Top-level map (true repo root)

Colony governance and runtime state:
- `.pmcro/` — this repo's own colony queue (`queue.jsonl`), session-state,
  sealed trails, constraints, capability registry/gaps, approvals, and
  trail-product schemas. Self-contained; does not read another repo's queue.
- `colony-laws.md` — cross-repo dispatch/queue/mutation/trail law.
- `trail-format.md` — sealed-trail schema classes.
- `.agents/CONTEXT.md` — this project's own architecture/governance summary
  (narrower and more implementation-specific than this file).
- `.agents/INSTRUCTIONS.md` — lifecycle command invocation, approval and
  trail-logging protocol, handoff protocols (mirrors what's loaded as this
  repo's claude.ai Project custom instructions).
- `AGENTS.md` — repo-wide marketplace conventions plus (in its "PMCR-O
  project conventions" section) this project's own operating rules.

Agent-facing tooling and skills:
- `.agents/agents/` — role identity/contract files (checker, maker,
  orchestrator, planner, reflector, trailkeeper, memorykeeper).
- `.agents/agents-memory/` — persistent per-agent `MEMORY.md` (gitignored;
  advisory, may be stale).
- `.agents/commands/` — human/agent entry points (`create-skill.md`,
  `run-queue.md`, `seed-intent.md`, `send-message.md`).
- `.agents/skills/` — `/pmcro-skills:<name>`-namespaced mechanics
  (`approve-operation`, `check-frame`, `discover-capabilities`,
  `make-frame`, `orchestrate`, `plan-frame`, `queue-claim`,
  `queue-enqueue`, `reflect-and-seed`, `trailkeeper`, `memorykeeper`,
  `create-skill`, `create-custom-agent`, `authoring-github-workflows`,
  plus marketplace-wide `eval-harness`, `session-resume`).
- `.agents/references/`, `.agents/rules/`, `.agents/workflows/` — supporting
  contract/reference docs for the above.
- `.agents/plugins/` — `marketplace.json` + `plugins.lock.json` copies (see
  Plugin registration below).
- `engine/` — deterministic queue/trail allocation support
  (`PmcroEngine.psm1`, `enqueue.ps1`, `run-cycle.ps1`); never performs
  reasoning, never replaces the declarative workflow substrate.

Marketplace plugins (each self-contained: `plugin.json` + `SKILL.md`-based
skills):
- `plugins/pmcro/` — semantic model, lifecycle, packaging/projection
  (`/pmcro:initialize`, `/pmcro:package`, `/pmcro:source-dump`, etc.).
- `plugins/pmcro-loop/` — runtime lifecycle engine (`orchestrate`,
  `plan-frame`, `make-frame`, `check-frame`, `reflect-and-seed`,
  `queue-claim`, `queue-enqueue`).
- `plugins/agentskills/` — whole-project generation (`create-project`).
- `plugins/agentskills-template-engine/` — `.NET` Template Engine
  scaffolding skills.
- `plugins/agent-design-patterns/` — routing/pattern-mapping skills.
- `plugins/github-skills/` — `gh` CLI setup + PR lifecycle wrappers.
- `plugins/pester-skills/` — Pester test-running skills.

Plugin registration (kept as synchronized copies, not independently
authoritative — canonical source is `.claude-plugin/marketplace.json`,
registered marketplace name `agent-skills`):
- `.claude-plugin/marketplace.json`, `plugin.json`
- `.agents/plugins/marketplace.json`, `plugins.lock.json`
- `.cursor-plugin/marketplace.json`
- `.codex-plugin/` — Codex-specific plugin manifest copy.
- `.github/` — GitHub Actions workflows, `CODEOWNERS`, agentic-workflow
  lock files, PR/issue triage automation, `skills/agentic-workflows/`.

The `.NET` solution:
- `AgentSkills.slnx`, `src/`, `tests/`, `workflows/` — the
  `AgentSkills.Workflows.{Domain,Application,Infrastructure,Mcp}` bounded
  context; Aspire AppHost is the composition boundary, Aspire integration
  tests live under `tests/`.
- `eng/` — build/eval tooling: `skill-validator/` (the C# skill/plugin
  validator solution), `eval-quality/`, `dashboard/`, `evaluation/`,
  `evaluation-tools/`, `skill-coverage/`, `vally-adapter/`, `version/`.
- `docs/` — including `docs/architecture-governance.md` (read before any
  architecture reconciliation work) and `docs/legacy/role-plugins/`
  (archived pre-consolidation split role plugins).

Repo-root config: `.gitignore`, `.gitattributes`, `.dockerignore`,
`.markdownlint-cli2.jsonc`, `global.json`, `Directory.Build.{props,targets}`,
`Directory.Packages.props`, `version.json`, `LICENSE`, `CODE_OF_CONDUCT.md`,
`CONTRIBUTING.md`, `SECURITY.md`, `README.md`.

## What no longer exists (do not recreate)

- `projects/` (plural) — deleted 2026-09-03; everything under it that
  mattered was merged into the true root paths listed above.
- `project/` (singular) — deleted 2026-09-03; was a frozen template
  example, not live state.
- `LAYOUTS.md` — deleted 2026-09-03; described the now-obsolete
  `project/` template. This file replaces it as the directory-map
  reference going forward.
- Any path under `P:\agent-skills\...` — never existed; a stale claim in
  the pre-consolidation `CONTEXT.md`. This repo's true root is wherever
  it is checked out (this machine: `P:\source\pmcro-skills`); nothing in
  the repo's own content should hardcode a machine-specific drive letter
  (see `AGENTS.md` Conventions).
