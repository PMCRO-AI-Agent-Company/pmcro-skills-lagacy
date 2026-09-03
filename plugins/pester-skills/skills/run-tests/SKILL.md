---
name: run-tests
description: Runs this colony's Pester test suite (or a single .Tests.ps1) via Invoke-Pester and reports a clear pass/fail summary, exiting non-zero on failure. Use to actually verify a PmcroEngine.psm1 change or a new wrapper script, not just parse it.
license: MIT
---

# Run Tests

"Live-tested, not just parsed" is a discipline this colony already holds
its own scripts to (`setup-gh-cli`'s `install-gh-portable.ps1`,
`github-skills`'s `inspect-repo.ps1` both found and fixed real bugs only
by actually being run). This skill makes running the existing test suite
a one-script call instead of typing `Invoke-Pester` inline each time.

## When to use this

After changing `PmcroEngine.psm1` or any `plugins/*/scripts/*.ps1` that
has a matching `.Tests.ps1` under `tests/`. Requires `setup-pester` to
have already ensured Pester >= 5.5.0 is importable -- this script does
not install anything itself.

## Workflow

1. `scripts/run-tests.ps1 -Path <file-or-directory-under-tests/>`
2. Reads the pass/fail/skipped counts and, on any failure, the list of
   failed test names, printed to the console. Exits `1` on any failure,
   `0` otherwise.

## What this deliberately does not do

- It does not install or upgrade Pester -- see `setup-pester`.
- It does not write or scaffold new test files -- see
  `references/pester-conventions.md` for this colony's actual test
  shape and where a new one belongs.

## References

- `references/pester-conventions.md` — where tests live, the
  `Describe`/`BeforeAll`/`$TestDrive` shape this repo already uses, and
  when a skill genuinely doesn't need a `.Tests.ps1` (LLM-judgment
  skills like `plan-frame`/`check-frame`) versus when missing one is a
  real gap (any skill backed by a `PmcroEngine.psm1` function).

## Scripts

- `scripts/run-tests.ps1` — `Invoke-Pester` wrapper with a clear
  pass/fail summary and a non-zero exit code on failure.
