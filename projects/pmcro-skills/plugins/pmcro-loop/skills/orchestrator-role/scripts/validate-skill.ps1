# Skill-local validation helper
# Run from the skill directory. This script checks the canonical filesystem contract.
$ErrorActionPreference = "Stop"
$skillRoot = Split-Path -Parent $PSScriptRoot
$skill = Join-Path $skillRoot "SKILL.md"
if (-not (Test-Path $skill)) { throw "Missing SKILL.md" }
foreach ($dir in @("assets","references","scripts")) {
  if (-not (Test-Path (Join-Path $skillRoot $dir))) { throw "Missing $dir/" }
}
$lines = (Get-Content $skill).Count
if ($lines -ge 500) { throw "SKILL.md must be under 500 lines; found $lines" }
Write-Output "PASS: $skillRoot ($lines lines)"
