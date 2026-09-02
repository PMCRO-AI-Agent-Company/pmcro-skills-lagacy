param(
  [Parameter(Mandatory)] [string] $SkillPath
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$templates = Join-Path $root 'assets\templates'

New-Item -ItemType Directory -Force -Path $SkillPath | Out-Null
foreach ($dir in @('assets\templates','references','scripts')) {
  New-Item -ItemType Directory -Force -Path (Join-Path $SkillPath $dir) | Out-Null
}

$skill = Join-Path $SkillPath 'SKILL.md'
if (-not (Test-Path $skill)) {
  Copy-Item (Join-Path $templates 'SKILL.md.template') $skill
}

$skillTemplate = Join-Path $SkillPath 'assets\templates\SKILL.md.template'
if (-not (Test-Path $skillTemplate)) {
  Copy-Item (Join-Path $templates 'SKILL.md.template') $skillTemplate
}

$agentsTemplate = Join-Path $SkillPath 'assets\templates\AGENTS.md.template'
if (-not (Test-Path $agentsTemplate)) {
  Copy-Item (Join-Path $templates 'AGENTS.md.template') $agentsTemplate
}

$reference = Join-Path $SkillPath 'references\README.md'
if (-not (Test-Path $reference)) {
  "# References`n`nAdd authoritative guidance used by this skill here." | Set-Content $reference -Encoding utf8
}

$validator = Join-Path $SkillPath 'scripts\validate.ps1'
if (-not (Test-Path $validator)) {
  @'
param([Parameter(Mandatory)] [string] $SkillPath)
$ErrorActionPreference = 'Stop'
foreach ($p in @('SKILL.md','assets','references','scripts')) {
  if (-not (Test-Path (Join-Path $SkillPath $p))) { throw "Missing: $p" }
}
Write-Host "PASS: $SkillPath"
'@ | Set-Content $validator -Encoding utf8
}

Write-Host "Scaffolded complete skill: $SkillPath"
