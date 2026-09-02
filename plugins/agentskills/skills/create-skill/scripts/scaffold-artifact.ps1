[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$SkillPath,
  [Parameter(Mandatory)][ValidateSet('rule','command','agent')][string]$Type,
  [Parameter(Mandatory)][string]$Name
)
$ErrorActionPreference = 'Stop'
if ($Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') { throw "Artifact name must be lowercase and hyphenated: $Name" }
$map = @{
  rule = @('rules','rule.md.template')
  command = @('commands','command.md.template')
  agent = @('agents','agent.md.template')
}
$dir,$template = $map[$Type]
$targetDir = Join-Path $SkillPath $dir
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
$out = Join-Path $targetDir $Name
if (Test-Path $out) { throw "Refusing to overwrite existing artifact: $out" }
$templatePath = Join-Path $SkillPath "assets\$template"
if (-not (Test-Path $templatePath -PathType Leaf)) { throw "Missing template: $templatePath" }
Copy-Item $templatePath $out
Write-Host "Scaffolded ${Type}: $out"
