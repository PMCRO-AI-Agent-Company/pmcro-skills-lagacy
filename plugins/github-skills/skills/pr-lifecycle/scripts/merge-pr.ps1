<#
.SYNOPSIS
  Merges a GitHub PR via gh using a real merge commit (never squash or
  rebase by default -- see references/merge-strategy.md), requiring gh
  to already be installed and authenticated (see setup-gh-cli).

.EXAMPLE
  .\merge-pr.ps1 -Number 42
  .\merge-pr.ps1 -Number 42 -DeleteBranch
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)] [int]$Number,
  [switch]$DeleteBranch
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "gh is not on PATH. Run setup-gh-cli's install-gh-portable.ps1 first."
}
$authStatus = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
  throw "gh is not authenticated. See references/gh-cli-setup.md (setup-gh-cli skill) for working non-interactive auth options.`n$authStatus"
}

$mergeArgs = @('pr', 'merge', "$Number", '--merge')
if ($DeleteBranch) { $mergeArgs += '--delete-branch' }

Write-Host "Merging PR #$Number (merge commit$(if ($DeleteBranch) { ', deleting branch' }))"
& gh @mergeArgs
if ($LASTEXITCODE -ne 0) {
  throw "gh pr merge failed (exit $LASTEXITCODE). See output above."
}
