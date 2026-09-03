<#
.SYNOPSIS
  Idempotently ensures Pester 5.5.0+ is importable for the current user,
  without requiring admin rights and without fighting the old
  Windows-bundled Pester 3.4.0 (which cannot be removed without admin
  and is left alone).

.DESCRIPTION
  1. If a Pester module >= MinimumVersion is already listed by
     Get-Module -ListAvailable, does nothing but report it and exit.
  2. Otherwise trusts the NuGet package provider and the PSGallery
     repository (both non-interactive, CurrentUser-scoped operations --
     needed because a fresh machine's default prompts for these would
     otherwise hang a non-interactive session forever) and installs
     Pester via Install-Module -Scope CurrentUser -SkipPublisherCheck.
  3. Re-checks availability and throws with the actual error if the
     install did not produce an importable module >= MinimumVersion.

.EXAMPLE
  pwsh -File install-pester.ps1
  pwsh -File install-pester.ps1 -MinimumVersion 5.7.0
#>
[CmdletBinding()]
param(
  [version]$MinimumVersion = '5.5.0'
)

$ErrorActionPreference = 'Stop'

function Get-AvailablePester {
  param([version]$MinimumVersion)
  Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge $MinimumVersion } | Sort-Object Version -Descending | Select-Object -First 1
}

$existing = Get-AvailablePester -MinimumVersion $MinimumVersion
if ($existing) {
  Write-Host "Pester $($existing.Version) already available at $($existing.ModuleBase)"
  return
}

Write-Host "No Pester >= $MinimumVersion found -- installing for the current user."

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
  Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser -ErrorAction Stop | Out-Null
} catch {
  throw "Could not trust/install the NuGet package provider (needed before Install-Module will run non-interactively): $($_.Exception.Message)"
}

try {
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction Stop
} catch {
  throw "Could not set PSGallery as a trusted repository: $($_.Exception.Message)"
}

try {
  Install-Module -Name Pester -MinimumVersion $MinimumVersion -Scope CurrentUser -Force -SkipPublisherCheck -ErrorAction Stop
} catch {
  throw "Install-Module Pester failed: $($_.Exception.Message)"
}

$installed = Get-AvailablePester -MinimumVersion $MinimumVersion
if (-not $installed) {
  throw "Install-Module reported success but no importable Pester >= $MinimumVersion is listed by Get-Module -ListAvailable. Check for a version conflict with the system-owned 3.4.0 copy."
}

Write-Host "Installed and available: Pester $($installed.Version) at $($installed.ModuleBase)"
Write-Host "Note: the older system Pester 3.4.0 (C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0) is left in place -- removing it needs admin rights and isn't required. Always Import-Module Pester -MinimumVersion $MinimumVersion -Force before use so the right one loads."
