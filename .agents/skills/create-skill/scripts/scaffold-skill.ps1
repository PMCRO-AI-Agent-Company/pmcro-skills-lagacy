param(
  [Parameter(Mandatory)] [string] $SkillPath
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$templates = Join-Path $root 'assets'

New-Item -ItemType Directory -Force -Path $SkillPath | Out-Null
foreach ($dir in @('assets','references','scripts')) {
  New-Item -ItemType Directory -Force -Path (Join-Path $SkillPath $dir) | Out-Null
}

$skill = Join-Path $SkillPath 'SKILL.md'
if (-not (Test-Path $skill)) {
  Copy-Item (Join-Path $templates 'skill.md.template') $skill
}

$skillTemplate = Join-Path $SkillPath 'assets\skill.md.template'
if (-not (Test-Path $skillTemplate)) {
  Copy-Item (Join-Path $templates 'skill.md.template') $skillTemplate
}

$agentsTemplate = Join-Path $SkillPath 'assets\agents.md.template'
if (-not (Test-Path $agentsTemplate)) {
  Copy-Item (Join-Path $templates 'agents.md.template') $agentsTemplate
}

$validatorTemplate = Join-Path $SkillPath 'assets\validate-skill.ps1.template'
if (-not (Test-Path $validatorTemplate)) {
  Copy-Item (Join-Path $templates 'validate-skill.ps1.template') $validatorTemplate
}

$reference = Join-Path $SkillPath 'references\README.md'
if (-not (Test-Path $reference)) {
  "# References`n`nAdd authoritative guidance used by this skill here." | Set-Content $reference -Encoding utf8
}

$validator = Join-Path $SkillPath 'scripts\validate-skill.ps1'
if (-not (Test-Path $validator)) {
  Copy-Item (Join-Path $templates 'validate-skill.ps1.template') $validator
}

foreach ($dir in @('assets','references','scripts')) {
  $gitkeep = Join-Path $SkillPath "$dir\.gitkeep"
  if ((Get-ChildItem (Join-Path $SkillPath $dir) -Force | Measure-Object).Count -eq 0) {
    New-Item -ItemType File -Path $gitkeep -Force | Out-Null
  }
}

Write-Host "Scaffolded complete skill: $SkillPath"
Write-Host "Support directories are flat: assets/, references/, scripts/."
Write-Host "Next: run scripts/validate-skill.ps1 before exposing the new skill."
