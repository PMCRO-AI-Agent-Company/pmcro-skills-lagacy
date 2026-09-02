param(
  [Parameter(Mandatory)] [string] $AgentsPath,
  [Parameter(Mandatory)] [string] $Name
)

$ErrorActionPreference = 'Stop'
if ($Name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
  throw "Agent name must be lowercase and hyphenated: $Name"
}

New-Item -ItemType Directory -Force -Path $AgentsPath | Out-Null
$target = Join-Path $AgentsPath "$Name.md"
if (Test-Path $target) { throw "Agent already exists: $target" }

@"
---
name: $Name
description: <what this persona does and when to dispatch it>
---

You are a <role>.

Review or perform:
1. <Responsibility>
2. <Responsibility>

Output contract:
- <Required result and evidence>
"@ | Set-Content -LiteralPath $target -Encoding utf8

Write-Host "Created agent template: $target"
