param(
  [Parameter(Mandatory)] [string] $RepoRoot
)

$ErrorActionPreference = 'Stop'

# This repo's actual entry points (AGENTS.md-declared), not a fixed
# path set copied from a different repo. `agents.config.json` and
# `.agents/CONTEXT.md`/`INSTRUCTIONS.md`/`session-state.md` belong to
# a *different* repository's convention and never exist here - do not
# reintroduce them as required paths for this repo.
$required = @('AGENTS.md', 'README.md')

# Optional-but-common: only reported, never blocking, since not every
# checkout has them.
$optional = @('.agents/skills/README.md', 'LAYOUTS.md')

$missingRequired = @($required | Where-Object { -not (Test-Path (Join-Path $RepoRoot $_)) })
if ($missingRequired.Count -gt 0) {
  Write-Host 'MISSING (required):'
  $missingRequired | ForEach-Object { Write-Host "- $_" }
  exit 1
}

$missingOptional = @($optional | Where-Object { -not (Test-Path (Join-Path $RepoRoot $_)) })
if ($missingOptional.Count -gt 0) {
  Write-Host 'Note - optional entry points not present:'
  $missingOptional | ForEach-Object { Write-Host "- $_" }
}

Write-Host 'PASS: all required resume entry points exist.'
