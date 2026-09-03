---
name: setup-pester
description: Detects and installs (non-admin, CurrentUser scope) a Pester 5.5.0+ module on a Windows machine, coexisting with the old bundled Pester 3.4.0 rather than fighting it, so this colony's PowerShell tests can actually run. Use before any task needs to verify a PmcroEngine.psm1 change or a wrapper script with a real test run.
license: MIT
---

# Setup Pester

Discovering, mid-task, that the only `Pester` on a machine is the ancient
Windows-bundled `3.4.0` -- too old for `Should -Be`/`BeforeAll` syntax
this repo's own tests use -- is a recurring, avoidable delay, and
installing one ad hoc inline is exactly the kind of unscripted tool use
this colony has already been corrected on twice this session (for `gh`,
for raw `git`). This skill makes it a one-script check instead.

## When to use this

Before any task that needs to actually run a `.Tests.ps1` file under
`tests/` -- verifying a `PmcroEngine.psm1` change, a new wrapper script,
or any existing test. Not needed just to *write* PowerShell.

## Workflow

1. Run `scripts/install-pester.ps1`. Idempotent: if a Pester >= 5.5.0 is
   already listed by `Get-Module -ListAvailable`, it does nothing but
   report the version and exit. Otherwise it trusts the NuGet provider
   and PSGallery (both required non-interactive steps whose default
   prompts would otherwise hang), then installs Pester to the
   `CurrentUser` scope -- no admin rights needed, and the old
   system-owned `3.4.0` is left alone rather than fought.
2. `run-tests`'s script (or any direct `Invoke-Pester` call) then works,
   provided it explicitly imports `-MinimumVersion 5.5.0` -- see
   `references/pester-setup.md` for why that matters when two versions
   are installed at once.

## What this deliberately does not do

- It does not attempt to remove or overwrite the system Pester 3.4.0 --
  that needs admin rights this skill doesn't assume, and isn't required
  since `-MinimumVersion` resolves the right one.
- It does not run any tests itself -- see `run-tests`.

## References

- `references/pester-setup.md` — why the plain `Install-Module` call
  isn't enough on a fresh machine, and the explicit-`-MinimumVersion`
  import discipline needed once two Pester versions coexist.

## Scripts

- `scripts/install-pester.ps1` — idempotent, no-admin Pester 5+ install.
