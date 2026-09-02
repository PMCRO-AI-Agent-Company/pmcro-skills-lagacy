param(
  [Parameter(Mandatory)] [string] $RepoRoot
)

$ErrorActionPreference = 'Stop'
$paths = @(
  'agents.config.json',
  '.agents/CONTEXT.md',
  '.agents/INSTRUCTIONS.md',
  '.agents/session-state.md'
)

$missing = @($paths | Where-Object { -not (Test-Path (Join-Path $RepoRoot $_)) })
if ($missing.Count -gt 0) {
  Write-Host 'MISSING:'
  $missing | ForEach-Object { Write-Host "- $_" }
  exit 1
}

Write-Host 'PASS: all configured resume entry points exist.'
