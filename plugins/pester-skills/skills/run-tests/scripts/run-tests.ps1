<#
.SYNOPSIS
  Run this colony's Pester tests and report a clear pass/fail summary,
  exiting non-zero on any failure.

.DESCRIPTION
  Requires Pester >= MinimumVersion to already be importable -- run
  setup-pester's install-pester.ps1 first if not. Does not attempt to
  install anything itself, matching pr-lifecycle's own separation from
  setup-gh-cli: this script stays in its lane.

.EXAMPLE
  pwsh -File run-tests.ps1 -Path <repo-root>\tests\pmcro-loop
  pwsh -File run-tests.ps1 -Path <repo-root>\tests\pmcro-loop\queue-enqueue\queue-enqueue.Tests.ps1

  A relative path also works when run from inside the repo, e.g.
  -Path .\tests\pmcro-loop -- this script does not assume any fixed
  checkout location.
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$Path,
  [version]$MinimumVersion = '5.5.0'
)

$ErrorActionPreference = 'Stop'

$available = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge $MinimumVersion } | Sort-Object Version -Descending | Select-Object -First 1
if (-not $available) {
  throw "No importable Pester >= $MinimumVersion found. Run setup-pester's scripts/install-pester.ps1 first."
}

Import-Module Pester -MinimumVersion $MinimumVersion -Force

$config = [PesterConfiguration]::Default
$config.Run.Path = $Path
$config.Run.PassThru = $true
$config.Output.Verbosity = 'Normal'

$result = Invoke-Pester -Configuration $config

Write-Host ""
Write-Host "Passed: $($result.PassedCount)  Failed: $($result.FailedCount)  Skipped: $($result.SkippedCount)  Total: $($result.TotalCount)"

if ($result.FailedCount -gt 0) {
  Write-Host "FAILED tests:"
  foreach ($t in $result.Failed) { Write-Host "  - $($t.ExpandedPath)" }
  exit 1
}

exit 0
