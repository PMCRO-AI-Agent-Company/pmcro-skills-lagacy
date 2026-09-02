# Generic Golden Cases (fallback only)

Prefer a skill-specific `references/eval-cases.md` inside the target
skill when one exists.

| Case | Setup | Expected |
|---|---|---|
| Scaffold produces required subfolders | Run the skill's scaffold/install script against a scratch target | `assets/`, `references/`, `scripts/` all exist when the current plugin convention requires them |
| No stale mechanism references | Search the skill's SKILL.md and scripts | No retired mechanism or unrelated toolchain references |
| Manifest still parses | Run `ConvertFrom-Json` against any manifest the skill touched | No parse error |
