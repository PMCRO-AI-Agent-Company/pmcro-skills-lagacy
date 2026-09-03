# pester-skills

Getting a working Pester 5+ on a machine whose only pre-installed copy is
the ancient Windows-bundled 3.4.0, and running this colony's PowerShell
tests against it, without re-discovering the same install dance every
session.

## Skills

`setup-pester` · `run-tests`

## Why this plugin exists

Born directly from a real gap: mid-task, fixing `queue-enqueue`'s missing
implementation needed a live Pester run to verify it, and the only
`Pester` module on this machine was `3.4.0` from
`C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0` -- too old for
the `Describe`/`BeforeAll`/`Should -Be` syntax this repo's own tests
already use (`tests/pmcro-loop/approve-operation/approve-operation.Tests.ps1`).
Installing a newer Pester and invoking it was about to happen ad hoc,
typed inline, the exact pattern already corrected twice this session for
`gh` and for raw `git` -- caught before it happened a third time.
`setup-pester` documents the actual non-interactive install path
(NuGet provider trust, `PSGallery` trust, `Install-Module -Scope
CurrentUser`, coexisting with the system-owned 3.4.0 rather than fighting
it); `run-tests` wraps `Invoke-Pester` with this repo's own conventions.
