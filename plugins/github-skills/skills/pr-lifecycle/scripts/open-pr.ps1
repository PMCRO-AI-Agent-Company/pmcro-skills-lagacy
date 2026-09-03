<#
.SYNOPSIS
  Opens a GitHub PR via gh, from the current repo, requiring gh to
  already be installed and authenticated (see setup-gh-cli).

.EXAMPLE
  .\open-pr.ps1 -Base main -Head feat/my-branch -Title "feat: thing" -BodyFile .\pr-body.txt
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string]$Base,
  [Parameter(Mandatory)] [string]$Head,
  [Parameter(Mandatory)] [string]$Title,
  [Parameter(Mandatory)] [string]$BodyFile
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "gh is not on PATH. Run setup-gh-cli's install-gh-portable.ps1 first."
}
$authStatus = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
  throw "gh is not authenticated. See references/gh-cli-setup.md (setup-gh-cli skill) for working non-interactive auth options.`n$authStatus"
}
if (-not (Test-Path $BodyFile)) {
  throw "BodyFile not found: $BodyFile"
}

Write-Host "Opening PR: $Head -> $Base"
& gh pr create --base $Base --head $Head --title $Title --body-file $BodyFile
if ($LASTEXITCODE -ne 0) {
  throw "gh pr create failed (exit $LASTEXITCODE). See output above."
}
