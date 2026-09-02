param(
  [Parameter(Mandatory)] [string] $SkillPath
)

$ErrorActionPreference = 'Stop'
$required = @('SKILL.md','assets','references','scripts')
$missing = @()
foreach ($item in $required) {
  if (-not (Test-Path (Join-Path $SkillPath $item))) { $missing += $item }
}

if ($missing.Count -gt 0) {
  Write-Error "Missing skill components: $($missing -join ', ')"
  exit 1
}

foreach ($dir in @('assets','references','scripts')) {
  $path = Join-Path $SkillPath $dir
  if (-not (Get-ChildItem $path -File -Recurse | Select-Object -First 1)) {
    Write-Error "Empty support directory: $dir"
    exit 1
  }
}

$templates = Join-Path $SkillPath 'assets\templates'
if (-not (Test-Path $templates)) {
  Write-Error 'Missing assets/templates directory'
  exit 1
}

if (-not (Get-ChildItem $templates -File | Select-Object -First 1)) {
  Write-Error 'assets/templates must contain at least one full-file template'
  exit 1
}

$skillFile = Join-Path $SkillPath 'SKILL.md'
$skillText = Get-Content -LiteralPath $skillFile -Raw
$documented = [regex]::Matches($skillText, '(?:(?:assets/templates|references|scripts)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*)') |
  ForEach-Object { $_.Value } | Sort-Object -Unique

$unimplemented = @()
foreach ($relative in $documented) {
  $target = Join-Path $SkillPath ($relative -replace '/', '\')
  if (-not (Test-Path $target)) { $unimplemented += $relative }
}

if ($unimplemented.Count -gt 0) {
  Write-Error "SKILL.md references missing functionality/files: $($unimplemented -join ', ')"
  exit 1
}

Write-Host "PASS: complete skill shape and documented support references present at $SkillPath"
