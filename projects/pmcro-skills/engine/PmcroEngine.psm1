# PmcroEngine.psm1
# Deterministic (non-LLM) state/queue/trail mechanics for the PMCR-O loop.
# This module does NOT call any model API. It only manages the files that
# make up .pmcro/ (session-state.md, queue.jsonl, trails/). Frame reasoning
# content is written as PENDING placeholders for an agent to fill in later.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-PmcroSessionState {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'session-state.md'
    if (-not (Test-Path $path)) { throw "session-state.md not found at $path" }
    $lines = (Get-Content -Raw $path) -split "`n"
    $state = [ordered]@{}
    foreach ($line in $lines) {
        if ($line -match '^([a-z_]+):\s?(.*)$') {
            $state[$matches[1]] = $matches[2].Trim()
        }
    }
    return [pscustomobject]$state
}

function Set-PmcroSessionState {
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][hashtable]$Fields
    )
    $current = Get-PmcroSessionState -PmcroRoot $PmcroRoot
    $merged = [ordered]@{}
    foreach ($p in $current.PSObject.Properties) { $merged[$p.Name] = $p.Value }
    foreach ($k in $Fields.Keys) { $merged[$k] = $Fields[$k] }
    $out = @('# Session State', '')
    foreach ($k in $merged.Keys) { $out += "$k`: $($merged[$k])" }
    $path = Join-Path $PmcroRoot 'session-state.md'
    Set-Content -Path $path -Value ($out -join "`n") -NoNewline
}

function Get-PmcroQueue {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'queue.jsonl'
    if (-not (Test-Path $path)) { return @() }
    $items = @()
    foreach ($line in (Get-Content $path)) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $items += (ConvertFrom-Json $line)
    }
    return $items
}

function Save-PmcroQueue {
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][array]$Items
    )
    $path = Join-Path $PmcroRoot 'queue.jsonl'
    $lines = @()
    foreach ($item in $Items) { $lines += (ConvertTo-Json -InputObject $item -Compress) }
    Set-Content -Path $path -Value ($lines -join "`n") -NoNewline
}
function Claim-PmcroTask {
    <#
      Deterministic claim: picks the lowest-priority-number OPEN item
      (0 = stop-the-line, 4 = backlog), marks it claimed, and updates
      session-state.md accordingly. Does NOT invent a task if queue is
      empty -- returns $null and leaves state idle.
    #>
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $open = @($queue | Where-Object { $_.status -eq 'open' })
    if ($open.Count -eq 0) {
        Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ status = 'idle'; notes = 'Queue empty at ' + (Get-Date -Format 'o') }
        return $null
    }
    $next = $open | Sort-Object priority | Select-Object -First 1
    $nowIso = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    foreach ($item in $queue) {
        if ($item.id -eq $next.id) {
            $item.status = 'claimed'
            $item | Add-Member -NotePropertyName claimed_at -NotePropertyValue $nowIso -Force
            $item | Add-Member -NotePropertyName claimed_by -NotePropertyValue 'orchestrator' -Force
        }
    }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{
        status       = 'active'
        seed_intent  = $next.seed_intent
        task_id      = $next.id
        domain       = [string]$next.domain
        priority     = [string]$next.priority
    }
    return $next
}

function New-PmcroTrail {
    <#
      Creates a trail file skeleton for a claimed task, with PlanFrame /
      MakeFrame / CheckFrame / Reflection sections marked PENDING.
      This function performs NO reasoning and calls NO model API --
      it only allocates the trail id and file so an agent (human-invoked
      or, later, API-driven) has a deterministic place to write into.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][pscustomobject]$Task
    )
    $dateSlug = Get-Date -Format 'yyyyMMdd-HHmmss'
    $trailId = "cycle-$dateSlug-$($Task.id)"
    $trailsDir = Join-Path $PmcroRoot 'trails'
    New-Item -ItemType Directory -Force -Path $trailsDir | Out-Null
    $trailPath = Join-Path $trailsDir "$trailId.md"
    $body = @"
# Trail: $trailId

trail_id: $trailId
task_id: $($Task.id)
domain: $($Task.domain)
priority: $($Task.priority)
opened: $(Get-Date -Format 'yyyy-MM-dd')
engine_generated: true

## Seed intent
$($Task.seed_intent)

## PlanFrame (Planner)
PENDING -- requires agent/model reasoning.

## MakeFrame (Maker)
PENDING -- requires agent/model reasoning.

## CheckFrame (Checker)
PENDING -- requires agent/model reasoning.

## Reflection (Reflector)
PENDING -- requires agent/model reasoning.

trail_sealed: false
"@
    Set-Content -Path $trailPath -Value $body -NoNewline
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ last_cycle_id = $trailId }
    return $trailPath
}

Export-ModuleMember -Function Get-PmcroSessionState, Set-PmcroSessionState, `
    Get-PmcroQueue, Save-PmcroQueue, Claim-PmcroTask, New-PmcroTrail
