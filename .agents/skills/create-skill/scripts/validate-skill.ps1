param(
  [Parameter(Mandatory)] [string] $SkillPath
)
$ErrorActionPreference = 'Stop'
$required = @('SKILL.md','assets','references','scripts')
foreach ($item in $required) {
  if (-not (Test-Path (Join-Path $SkillPath $item))) { throw "Missing skill component: $item" }
}
foreach ($dir in @('assets','references','scripts')) {
  $path = Join-Path $SkillPath $dir
  if (-not (Get-ChildItem $path -File | Select-Object -First 1)) { throw "Empty support directory: $dir" }
  if (Get-ChildItem $path -Directory -Recurse | Select-Object -First 1) { throw "Nested support directory is not allowed: $dir" }
}
$text = Get-Content (Join-Path $SkillPath 'SKILL.md') -Raw
$paths = [regex]::Matches($text, '(?:(?:assets|references|scripts)/[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*)') |
  ForEach-Object Value | Sort-Object -Unique
foreach ($relative in $paths) {
  if ($relative -eq 'assets/templates') { continue }
  $target = Join-Path $SkillPath ($relative -replace '/', '\')
  if (Test-Path $target -PathType Container) { continue }
  if (-not (Test-Path $target -PathType Leaf)) { throw "SKILL.md references missing artifact: $relative" }
}
Write-Host "PASS: complete flat skill package verified at $SkillPath"
