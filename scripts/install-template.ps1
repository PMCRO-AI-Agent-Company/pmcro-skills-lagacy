# Install Agents Skill Directory layouts into a target project and/or user home.
# Usage:
#   ./scripts/install-template.ps1 [-Target .] [-Global]

param(
  [string]$Target = ".",
  [switch]$Global
)

$ErrorActionPreference = "Stop"
$Root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
if (-not (Test-Path (Join-Path $PSScriptRoot "..\template\project"))) {
  $Root = Resolve-Path (Join-Path $PSScriptRoot "..")
} else {
  $Root = Resolve-Path (Join-Path $PSScriptRoot "..")
}

$ProjectSrc = Join-Path $Root "template\project"
$GlobalSrc  = Join-Path $Root "template\global"

if (-not (Test-Path $ProjectSrc)) { throw "Missing template/project at $ProjectSrc" }

New-Item -ItemType Directory -Force -Path $Target | Out-Null
Write-Host "[OK] Installing project layout into $Target"

foreach ($f in @("AGENTS.md", ".mcp.json", ".worktreeinclude")) {
  $src = Join-Path $ProjectSrc $f
  if (Test-Path $src) { Copy-Item $src (Join-Path $Target $f) -Force }
}

$agentsDest = Join-Path $Target ".agents"
New-Item -ItemType Directory -Force -Path $agentsDest | Out-Null
Copy-Item (Join-Path $ProjectSrc ".agents\*") $agentsDest -Recurse -Force

Write-Host "[OK] Project layout installed"

if ($Global) {
  $homeAgents = Join-Path $HOME ".agents"
  New-Item -ItemType Directory -Force -Path $homeAgents | Out-Null
  Copy-Item (Join-Path $GlobalSrc ".agents\*") $homeAgents -Recurse -Force
  $agentsJson = Join-Path $GlobalSrc ".agents.json"
  $homeJson = Join-Path $HOME ".agents.json"
  if ((Test-Path $agentsJson) -and -not (Test-Path $homeJson)) {
    Copy-Item $agentsJson $homeJson
    Write-Host "[OK] Wrote ~/.agents.json"
  }
  Write-Host "[OK] Global layout installed under ~/.agents/"
}
