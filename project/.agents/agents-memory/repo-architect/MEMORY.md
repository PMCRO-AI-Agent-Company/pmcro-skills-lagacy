# repo-architect memory

version: 1

## 2026-08-27 — global/ removal, create-agent skill, structured skill convention

- Deleted `global/` entirely (a two-tier global-template mirror with
  `agents/checker.md`, `maker.md`, `planner.md`, `reflector.md`,
  `output-styles/teaching.md`, etc.) — confirmed redundant since root
  `.agents/` is the repo's actual shared/live tree.

- Added `.agents/skills/create-agent/SKILL.md` — a scaffolding skill
  for new `project/.agents/agents/<name>.md` personas, mirroring the
  `dotnet/skills` repo's `create-custom-agent` meta-skill pattern but
  adapted to this repo's actual `name`/`description`/`tools`
  frontmatter + plain-prose-body convention (not VS Code's
  `.agent.md`/handoffs format).

- Changed the repo's skill-folder convention from flat-only to a
  structured layout (`SKILL.md` + optional `scripts/`/`references/`/
  `assets/`), mirroring `dotnet/skills`. Updated in three places:
  - `project/.agents/skills/README.md` — full convention doc rewrite
  - `.agents/skills/agent-skill/SKILL.md` — scaffolding instructions
  - `eng/eval-quality/check_eval_quality.py` — the gate previously
    hard-errored on any `scripts/`/`references/`/`assets/` folder;
    now validates unrecognized subfolder names, rejects empty
    recognized subfolders, and warns on `references/*.md` files not
    linked from `SKILL.md`

- Migrated `project/plugins/security-review/skills/security-review/`
  as the reference example of the new convention:
  - `checklist.md` moved to `references/checklist.md`, linked from a
    new `## References` section in `SKILL.md`
  - added `scripts/scan-secrets.ps1` (regex pre-check for AWS/API-key/
    private-key/Slack/GitHub-token/JWT-shaped secrets in diff
    added-lines), wired in via a new `## Automation` section
  - script's parsing/matching logic verified functional against a
    synthetic diff (`git` itself unavailable on this shell's PATH, so
    couldn't test against a real repo diff)

- Quality gate confirmed green (0 errors) after all changes, both
  before and after the `scripts/` addition.

## Open — NextSeedIntent

Before any further repo-architect convention changes on
`P:\src\personal\agent-skills`, the next agent must study
`Z:\pmcro-skills` (the canonical PMCRO meta-governance skill repo —
plugin.json/.codex-plugin/version.json/marketplace.json mirrors,
colony-laws.md, trail-format.md) to check whether this repo's own
conventions (plugin packaging, skill-folder structure, eval-quality
gate) are aligned with or have diverged from the canonical pattern,
before making any more structural changes here.

Reason: this session changed the skill-folder convention from flat to
structured based on a *downloaded snapshot* of upstream dotnet/skills
(`C:\Users\org.tooensure\Downloads\dotnet-skills-main`), not against
`Z:\pmcro-skills` directly — `Z:\` was not mounted in this session, so
that cross-check was never done. Z: needs to be mounted for the next
agent to act on this.
