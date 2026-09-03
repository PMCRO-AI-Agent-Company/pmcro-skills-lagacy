<#
.SYNOPSIS
  Read-only reconnaissance on a GitHub repo via gh, before cloning it or
  opening a PR against it -- what's actually there, not what a stale
  assumption says is there.

.DESCRIPTION
  Wraps three gh calls this session ran ad hoc while investigating the
  PMCRO-AI-Agent-Company/pmcro-runtime repo (found it wasn't the empty/
  abandoned scaffold it looked like from the outside): repo metadata,
  a directory listing at any path, and the N most recent commits. Always
  requires gh installed/authenticated (see setup-gh-cli) -- never falls
  back to scraping via git clone --depth 1, since that's much slower for
  "just tell me what's here" questions.

.EXAMPLE
  .\inspect-repo.ps1 -Repo PMCRO-AI-Agent-Company/pmcro-runtime
  .\inspect-repo.ps1 -Repo PMCRO-AI-Agent-Company/pmcro-runtime -Path src
  .\inspect-repo.ps1 -Repo PMCRO-AI-Agent-Company/pmcro-runtime -RecentCommits 5
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string]$Repo,
  [string]$Path,
  [int]$RecentCommits = 3
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "gh is not on PATH. Run setup-gh-cli's install-gh-portable.ps1 first."
}
$authStatus = & gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
  throw "gh is not authenticated. See references/gh-cli-setup.md (setup-gh-cli skill).`n$authStatus"
}

Write-Host "=== $Repo ==="
& gh api "repos/$Repo" -q '.description, .visibility, .default_branch, .pushed_at, .html_url'

Write-Host "`n=== branches ==="
& gh api "repos/$Repo/branches" -q '.[].name'

if ($Path) {
  Write-Host "`n=== contents: $Path ==="
  & gh api "repos/$Repo/contents/$Path" -q '.[].name'
} else {
  Write-Host "`n=== contents: (root) ==="
  & gh api "repos/$Repo/contents" -q '.[].name'
}

Write-Host "`n=== last $RecentCommits commits ==="
& gh api "repos/$Repo/commits" -q ".[0:$RecentCommits][] | .sha[0:7], .commit.author.date, .commit.message"
