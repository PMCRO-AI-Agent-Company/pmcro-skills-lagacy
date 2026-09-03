<#
.SYNOPSIS
  Idempotently ensures `gh` (GitHub CLI) is available on PATH for the
  current session, installing a portable (no admin, no winget) copy if
  needed.

.DESCRIPTION
  1. If `gh` already resolves and runs, reports its version and exits.
  2. Otherwise downloads the latest Windows amd64 zip release of gh from
     GitHub's own releases API, extracts it under
     $env:LOCALAPPDATA\pmcro-skills-tools\gh (never inside a repo working
     tree), and prepends its bin/ directory to PATH for this session.
  3. Does not attempt auth -- see references/gh-cli-setup.md for that.

.EXAMPLE
  pwsh -File install-gh-portable.ps1
#>
[CmdletBinding()]
param(
  [string]$InstallRoot = (Join-Path $env:LOCALAPPDATA 'pmcro-skills-tools\gh')
)

$ErrorActionPreference = 'Stop'

function Test-GhAvailable {
  $cmd = Get-Command gh -ErrorAction SilentlyContinue
  if (-not $cmd) { return $false }
  try { & gh --version *> $null; return $LASTEXITCODE -eq 0 } catch { return $false }
}

if (Test-GhAvailable) {
  $version = (& gh --version | Select-Object -First 1)
  Write-Host "gh already available: $version"
  return
}

Write-Host "gh not found on PATH -- installing portable copy under $InstallRoot"

$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/cli/cli/releases/latest' -Headers @{ 'User-Agent' = 'pmcro-skills-setup-gh-cli' }
$asset = $release.assets | Where-Object { $_.name -match 'windows_amd64\.zip$' } | Select-Object -First 1
if (-not $asset) {
  throw "Could not find a windows_amd64.zip asset on the latest gh release ($($release.tag_name)). Check https://github.com/cli/cli/releases manually."
}

$zipPath = Join-Path $env:TEMP $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -Headers @{ 'User-Agent' = 'pmcro-skills-setup-gh-cli' }

if (Test-Path $InstallRoot) { Remove-Item $InstallRoot -Recurse -Force }
New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $InstallRoot -Force
Remove-Item $zipPath -Force

# The zip may extract gh.exe directly under <root>\bin\gh.exe, or (older/
# other releases) nested one level down under a gh_<version>_windows_amd64\
# wrapper folder -- handle both rather than assuming one shape.
$ghExe = Get-ChildItem -Path $InstallRoot -Recurse -Filter 'gh.exe' -File | Select-Object -First 1
if (-not $ghExe) {
  throw "Extracted gh release under $InstallRoot but could not find gh.exe anywhere inside it."
}
$ghBin = $ghExe.DirectoryName

$env:PATH = "$ghBin;$env:PATH"

if (-not (Test-GhAvailable)) {
  throw "gh.exe was extracted to $ghBin but is still not runnable -- check PATH/architecture."
}

$version = (& gh --version | Select-Object -First 1)
Write-Host "Installed and available for this session: $version"
Write-Host "Binary at: $ghBin"
Write-Host "Note: PATH change is session-scoped only. Re-run this script (it will be a no-op once installed and still on PATH) or add $ghBin to a persistent PATH if you want gh available in new sessions."
