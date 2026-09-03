[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [ValidateSet('directory','gemini','agents')]
    [string]$Target,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourcePath = (Resolve-Path -LiteralPath $Source).Path
if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) { throw "Source must be a directory: $Source" }

$destination = [IO.Path]::GetFullPath($OutputPath)
if (Test-Path -LiteralPath $destination) { throw "Output path already exists: $destination" }

$protected = @('.git', '.env', '.env.*', 'secrets', 'credentials', '.pmcro/approvals.jsonl', '.pmcro/secrets', '.pmcro/credentials')

function Test-ProtectedPath {
    param([string]$RelativePath)
    foreach ($pattern in $protected) {
        $normalized = $pattern -replace '\\', '/'
        if ($RelativePath -eq $normalized -or $RelativePath.StartsWith("$normalized/", [StringComparison]::OrdinalIgnoreCase)) { return $true }
    }
    return $false
}

function Test-BinaryFile {
    param([string]$Path)
    $stream = [IO.File]::OpenRead($Path)
    try {
        $buffer = New-Object byte[] 4096
        $read = $stream.Read($buffer, 0, $buffer.Length)
        for ($i = 0; $i -lt $read; $i++) { if ($buffer[$i] -eq 0) { return $true } }
        return $false
    }
    finally { $stream.Dispose() }
}

function Copy-Tree {
    param([string]$From, [string]$To)
    New-Item -ItemType Directory -Path $To -Force | Out-Null
    Get-ChildItem -LiteralPath $From -Recurse -Force | ForEach-Object {
        $relative = [IO.Path]::GetRelativePath($From, $_.FullName) -replace '\\', '/'
        if (Test-ProtectedPath $relative) { return }
        $target = Join-Path $To $relative
        if ($_.PSIsContainer) {
            New-Item -ItemType Directory -Path $target -Force | Out-Null
        }
        elseif (-not (Test-BinaryFile $_.FullName)) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
            Copy-Item -LiteralPath $_.FullName -Destination $target -Force
        }
    }
}

switch ($Target) {
    'directory' {
        $projectionRoot = $destination
        Copy-Tree -From $sourcePath -To $projectionRoot
    }
    'gemini' {
        $projectionRoot = Join-Path $destination '.gemini/skills'
        New-Item -ItemType Directory -Path $projectionRoot -Force | Out-Null
        $skillRoot = Join-Path $sourcePath 'skills'
        if (Test-Path -LiteralPath (Join-Path $sourcePath 'SKILL.md')) {
            Copy-Tree -From $sourcePath -To (Join-Path $projectionRoot (Split-Path -Leaf $sourcePath))
        }
        elseif (Test-Path -LiteralPath $skillRoot -PathType Container) {
            Get-ChildItem -LiteralPath $skillRoot -Directory | ForEach-Object { Copy-Tree -From $_.FullName -To (Join-Path $projectionRoot $_.Name) }
        }
        else {
            Copy-Tree -From $sourcePath -To (Join-Path $projectionRoot (Split-Path -Leaf $sourcePath))
        }
    }
    'agents' {
        $projectionRoot = Join-Path $destination '.agents/skills'
        New-Item -ItemType Directory -Path $projectionRoot -Force | Out-Null
        $skillRoot = Join-Path $sourcePath 'skills'
        if (Test-Path -LiteralPath (Join-Path $sourcePath 'SKILL.md')) {
            Copy-Tree -From $sourcePath -To (Join-Path $projectionRoot (Split-Path -Leaf $sourcePath))
        }
        elseif (Test-Path -LiteralPath $skillRoot -PathType Container) {
            Get-ChildItem -LiteralPath $skillRoot -Directory | ForEach-Object { Copy-Tree -From $_.FullName -To (Join-Path $projectionRoot $_.Name) }
        }
        else {
            Copy-Tree -From $sourcePath -To (Join-Path $projectionRoot (Split-Path -Leaf $sourcePath))
        }
    }
}

Write-Output "Package projection written to $destination"
