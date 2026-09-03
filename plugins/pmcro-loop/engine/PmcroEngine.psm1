# PmcroEngine.psm1
# Deterministic (non-LLM) state/queue/trail/approval mechanics for PMCR-O.
# This module does NOT call any model API. It manages .pmcro state.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-PmcroSessionState {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'session-state.md'
    if (-not (Test-Path $path)) { throw "session-state.md not found at $path" }
    $lines = (Get-Content -Raw $path) -split "`n"
    $state = [ordered]@{}
    foreach ($line in $lines) {
        if ($line -match '^([a-z_]+):\s?(.*)$') { $state[$matches[1]] = $matches[2].Trim() }
    }
    return [pscustomobject]$state
}

function Set-PmcroSessionState {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][hashtable]$Fields)
    $current = Get-PmcroSessionState -PmcroRoot $PmcroRoot
    $merged = [ordered]@{}
    foreach ($p in $current.PSObject.Properties) { $merged[$p.Name] = $p.Value }
    foreach ($k in $Fields.Keys) { $merged[$k] = $Fields[$k] }
    $out = @('# Session State', '')
    foreach ($k in $merged.Keys) { $out += "$k`: $($merged[$k])" }
    Set-Content -Path (Join-Path $PmcroRoot 'session-state.md') -Value ($out -join "`n") -NoNewline
}

function Get-PmcroQueue {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'queue.jsonl'; if (-not (Test-Path $path)) { return @() }
    $items = @(); foreach ($line in (Get-Content $path)) { if (-not [string]::IsNullOrWhiteSpace($line)) { $items += ConvertFrom-Json $line } }
    return $items
}

function Save-PmcroQueue {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][array]$Items)
    $lines = @(); foreach ($item in $Items) { $lines += ConvertTo-Json -InputObject $item -Compress }
    Set-Content -Path (Join-Path $PmcroRoot 'queue.jsonl') -Value ($lines -join "`n") -NoNewline
}

function Claim-PmcroTask {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $queue = Get-PmcroQueue -PmcroRoot $PmcroRoot
    $open = @($queue | Where-Object { $_.status -eq 'open' })
    if ($open.Count -eq 0) { Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ status='idle'; notes='Queue empty at ' + (Get-Date -Format 'o') }; return $null }
    $next = $open | Sort-Object priority | Select-Object -First 1
    $nowIso = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
    foreach ($item in $queue) { if ($item.id -eq $next.id) { $item.status='claimed'; $item | Add-Member -NotePropertyName claimed_at -NotePropertyValue $nowIso -Force; $item | Add-Member -NotePropertyName claimed_by -NotePropertyValue 'orchestrator' -Force } }
    Save-PmcroQueue -PmcroRoot $PmcroRoot -Items $queue
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ status='active'; seed_intent=$next.seed_intent; task_id=$next.id; domain=[string]$next.domain; priority=[string]$next.priority }
    return $next
}

function New-PmcroTrail {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][pscustomobject]$Task)
    $trailId = "cycle-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($Task.id)"
    $trailsDir = Join-Path $PmcroRoot 'trails'; New-Item -ItemType Directory -Force -Path $trailsDir | Out-Null
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
    Set-PmcroSessionState -PmcroRoot $PmcroRoot -Fields @{ last_cycle_id=$trailId }
    return $trailPath
}

function Get-PmcroApprovals {
    param([Parameter(Mandatory)][string]$PmcroRoot)
    $path = Join-Path $PmcroRoot 'approvals.jsonl'; if (-not (Test-Path $path)) { return @() }
    $items = @(); foreach ($line in (Get-Content $path)) { if (-not [string]::IsNullOrWhiteSpace($line)) { $items += ConvertFrom-Json $line } }
    return $items
}

function Save-PmcroApproval {
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [Parameter(Mandatory)][string]$OperationId,
        [Parameter(Mandatory)][string]$Decision,
        [Parameter(Mandatory)][string]$Operation,
        [Parameter(Mandatory)][string[]]$Scope,
        [Parameter(Mandatory)][string]$Actor,
        [Parameter(Mandatory)][string]$Source,
        [string]$Expiry,
        [string]$TrailId,
        [switch]$Destructive
    )
    if ($Decision -notin @('approved','denied','needs-human-approval')) { throw 'Decision must be approved, denied, or needs-human-approval.' }
    if ($Destructive -and $Decision -eq 'approved' -and $Source -ne 'human') { throw 'Destructive operations require explicit human approval.' }
    if ($Decision -eq 'approved' -and [string]::IsNullOrWhiteSpace($TrailId)) { throw 'Approved operations require a trail reference.' }
    $record = [ordered]@{
        operation_id=$OperationId; decision=$Decision; operation=$Operation; scope=@($Scope); actor=$Actor
        source=$Source; destructive=[bool]$Destructive; approved_at=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
        expiry=$Expiry; trail_id=$TrailId
    }
    $path = Join-Path $PmcroRoot 'approvals.jsonl'
    Add-Content -Path $path -Value (ConvertTo-Json $record -Compress)
    return [pscustomobject]$record
}

function Test-PmcroApproval {
    param([Parameter(Mandatory)][string]$PmcroRoot,[Parameter(Mandatory)][string]$OperationId,[Parameter(Mandatory)][string[]]$Targets,[string]$Actor)
    $matches = @(Get-PmcroApprovals -PmcroRoot $PmcroRoot | Where-Object { $_.operation_id -eq $OperationId -and $_.decision -eq 'approved' })
    if ($matches.Count -eq 0) { return $false }
    $approval = $matches[-1]
    if ($Actor -and $approval.actor -ne $Actor) { return $false }
    foreach ($target in $Targets) { if ($approval.scope -notcontains $target) { return $false } }
    if ($approval.expiry) {
        $expires = [datetimeoffset]::Parse([string]$approval.expiry)
        if ([datetimeoffset]::UtcNow -ge $expires) { return $false }
    }
    return $true
}

Export-ModuleMember -Function Get-PmcroSessionState, Set-PmcroSessionState, Get-PmcroQueue, Save-PmcroQueue, Claim-PmcroTask, New-PmcroTrail, Get-PmcroApprovals, Save-PmcroApproval, Test-PmcroApproval
