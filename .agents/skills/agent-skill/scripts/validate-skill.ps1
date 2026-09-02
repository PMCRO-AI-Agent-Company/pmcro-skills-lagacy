param(
  [Parameter(Mandatory)] [string] $SkillPath
)
$ErrorActionPreference = 'Stop'

$required = @('SKILL.md','assets','references','scripts')
foreach ($item in $required) {
  if (-not (Test-Path (Join-Path $SkillPath $item))) {
    throw "Missing skill component: $item"
  }
}

foreach ($dir in @('assets','references','scripts')) {
  $path = Join-Path $SkillPath $dir
  if (-not (Get-ChildItem $path -File -Recurse | Select-Object -First 1)) {
    throw "Empty support directory: $dir"
  }
}

$templates = Join-Path $SkillPath 'assets\templates'
if (-not (Test-Path $templates)) { throw 'Missing assets/templates' }
if (-not (Get-ChildItem $templates -File | Select-Object -First 1)) {
  throw 'assets/templates must contain a full-file template'
}

$text = Get-Content (Join-Path $SkillPath 'SKILL.md') -Raw
$paths = [regex]::Matches($text, '(?:(?:assets/templates|references|scripts)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*)') |
  ForEach-Object Value | Sort-Object -Unique
foreach ($relative in $paths) {
  $target = Join-Path $SkillPath ($relative -replace '/', '\')
  if (-not (Test-Path $target)) {
    throw "SKILL.md references missing artifact: $relative"
  }
}

Write-Host "PASS: complete skill package and documented artifacts verified at $SkillPath"

# Validation is intentionally deterministic and local to this skill package.
