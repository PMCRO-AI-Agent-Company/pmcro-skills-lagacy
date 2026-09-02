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
  Copy-Item (Join-Path $templates 'skill.md.template') $skill
}

$skillTemplate = Join-Path $SkillPath 'assets\templates\skill.md.template'
if (-not (Test-Path $skillTemplate)) {
  Copy-Item (Join-Path $templates 'skill.md.template') $skillTemplate
}

$agentsTemplate = Join-Path $SkillPath 'assets\templates\agents.md.template'
if (-not (Test-Path $agentsTemplate)) {
  Copy-Item (Join-Path $templates 'agents.md.template') $agentsTemplate
}

$validatorTemplate = Join-Path $SkillPath 'assets\templates\validate-skill.ps1.template'
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

Write-Host "Scaffolded complete skill: $SkillPath"
Write-Host "Next: run scripts/validate-skill.ps1 before exposing the new skill."

# Scaffold only creates artifacts; it never represents missing behavior as implemented.

# The generated support files are a baseline; replace placeholders with actual implementations.
