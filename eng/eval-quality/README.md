# Eval quality gate

`check_eval_quality.py` catches structural problems in skills, plugins, and
evals before they masquerade as skill regressions. It's a scoped-down cousin
of `dotnet/skills`' `eng/eval-quality` checker — same idea, far smaller
surface, zero required dependencies (PyYAML unlocks deeper `eval.yaml`
validation if installed, but the gate degrades gracefully without it).

Run from the repository root:

```bash
python eng/eval-quality/check_eval_quality.py          # errors only
python eng/eval-quality/check_eval_quality.py --strict # warnings fail too
```

## What it checks

- Every `SKILL.md` has `name` (matching its folder) and `description`
  (≤1024 chars) in its frontmatter
- No skill has a `scripts/`, `references/`, or `assets/` subfolder — this
  repo uses a flat skill layout
- Every `tests/**/eval.yaml` is valid YAML with at least one `stimuli` entry
  that has a `prompt` and at least one `grader`
- The root `.claude-plugin/marketplace.json` only lists plugins that exist
  on disk
- Every plugin has a `plugin.json`, a `.claude-plugin/plugin.json` with a
  matching name/version, and a `version.json`

## What it warns (but doesn't fail) on

- A skill with no matching `tests/**/<skill-name>/eval.yaml` yet — useful
  signal while you're still filling in coverage, not a hard blocker
- A plugin with no `version.json`
