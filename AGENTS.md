# Repository instructions

This repo is a plugin marketplace (`.claude-plugin/marketplace.json`) plus
two scaffold templates (`global/`, `project/`) — see `README.md` for the
full layout.

## Working on skills, plugins, and evals

Use `.agents/skills/agent-skill/SKILL.md` instead of improvising — it
covers naming, the flat skill-folder convention, deciding standalone
skill vs. new plugin, frontmatter shape, and writing an `eval.yaml`.

Before committing a new or changed skill/plugin, run:

```bash
python eng/eval-quality/check_eval_quality.py
```

It's a structural gate only (frontmatter shape, plugin manifest sync,
eval schema) — it does not run the evals themselves, and it never
interprets prose, so it can't fire on a well-written skill.

## Conventions worth knowing before you edit

- Flat skill layout: `SKILL.md` + plain sibling files, never
  `scripts/`/`references/`/`assets/` subfolders.
- Every plugin needs `plugin.json` **and** a byte-for-byte-matching
  `.claude-plugin/plugin.json` (name/version must agree) plus its own
  `version.json`.
- `project/.agents/` is a *template*, not itself a live project — don't
  add project-specific content there; it belongs in the consuming
  project's own `.agents/` after the template is copied in.
