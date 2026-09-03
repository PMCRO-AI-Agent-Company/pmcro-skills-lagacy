# Pester setup on a fresh machine

## What's actually there by default
Windows ships PowerShell with a bundled `Pester 3.4.0` under
`C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0`. It cannot be
removed or upgraded in place without admin rights, and its syntax
predates the `Describe { BeforeAll {...} }` / `Should -Be` form this
repo's tests already use. Do not try to uninstall or overwrite it --
`install-pester.ps1` installs a newer Pester into the CurrentUser scope
instead, where it coexists and takes precedence once explicitly
imported with `-MinimumVersion`.

## Why the plain `Install-Module -Name Pester` call isn't enough on a
## fresh machine
Two prerequisites are usually missing and their default prompts are
interactive, which hangs a non-interactive/automated session
indefinitely rather than failing fast:
- The NuGet package provider (`Install-PackageProvider -Name NuGet`).
- Trusting the PSGallery repository
  (`Set-PSRepository -Name PSGallery -InstallationPolicy Trusted`).

`install-pester.ps1` does both explicitly, non-interactively, before
`Install-Module`, rather than letting them prompt.

## Loading the right one afterward
Because two Pester versions can be listed by
`Get-Module -ListAvailable Pester` at once (the old system one and the
new CurrentUser one), always load explicitly:

```powershell
Import-Module Pester -MinimumVersion 5.5.0 -Force
```

Omitting `-MinimumVersion` risks PowerShell resolving the older,
syntax-incompatible system copy first.
