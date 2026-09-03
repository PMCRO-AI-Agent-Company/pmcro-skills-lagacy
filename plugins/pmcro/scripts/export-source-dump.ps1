[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Root = (Get-Location).Path,

    [string[]]$Include = @(),

    [string[]]$Exclude = @(
        '.git', '.github/CODEOWNERS', 'node_modules', 'bin', 'obj',
        '.venv', '__pycache__', '.pytest_cache', '.idea', '.vs',
        'secrets', 'credentials'
    ),

    [string]$OutputPath = '',

    [switch]$IncludeBinary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$rootPath = (Resolve-Path -LiteralPath $Root).Path

function Get-RepoRelativePath {
    param([string]$Path)

    $full = [IO.Path]::GetFullPath($Path)
    $root = [IO.Path]::GetFullPath($rootPath)
    $relative = [IO.Path]::GetRelativePath($root, $full)
    return ($relative -replace '\\', '/')
}

function Matches-Path {
    param(
        [string]$RelativePath,
        [string[]]$Patterns
    )

    foreach ($pattern in $Patterns) {
        if ([string]::IsNullOrWhiteSpace($pattern)) { continue }
        $normalized = $pattern -replace '\\', '/'
        if ($RelativePath -eq $normalized -or
            $RelativePath.StartsWith("$normalized/", [StringComparison]::OrdinalIgnoreCase) -or
            $RelativePath -like $normalized -or
            $RelativePath -like "$normalized/*") {
            return $true
        }
    }

    return $false
}

function Get-FileType {
    param([string]$RelativePath)

    $lower = $RelativePath.ToLowerInvariant()
    if ($lower -match '(^|/)(skill\.md)$' -or $lower -match '(^|/)(skills?)(/|$)') { return 'skill' }
    if ($lower -match '(^|/)(references?|docs?)(/|$)' -or $lower -match '\.md$') { return 'reference' }
    if ($lower -match '(^|/)(scripts?)(/|$)' -or $lower -match '\.(ps1|psm1|psd1|sh|bash|cmd|bat|py)$') { return 'script' }
    if ($lower -match '(^|/)(assets?)(/|$)') { return 'asset' }
    if ($lower -match '(^|/)(templates?)(/|$)') { return 'template' }
    if ($lower -match '(^|/)(\.pmcro|config|configuration)(/|$)' -or $lower -match '\.(json|jsonl|ya?ml|toml|xml|ini|editorconfig)$') { return 'configuration' }
    if ($lower -match '(^|/)(\.pmcro)(/|$)') { return 'state' }
    return 'source'
}

function Test-TextFile {
    param([string]$Path)

    if ($IncludeBinary) { return $true }

    $stream = [IO.File]::OpenRead($Path)
    try {
        $buffer = New-Object byte[] 4096
        $read = $stream.Read($buffer, 0, $buffer.Length)
        for ($i = 0; $i -lt $read; $i++) {
            if ($buffer[$i] -eq 0) { return $false }
        }
        return $true
    }
    finally {
        $stream.Dispose()
    }
}

$files = Get-ChildItem -LiteralPath $rootPath -File -Recurse -Force |
    ForEach-Object {
        $relative = Get-RepoRelativePath -Path $_.FullName
        [pscustomobject]@{ Item = $_; RelativePath = $relative }
    } |
    Where-Object {
        if (Matches-Path -RelativePath $_.RelativePath -Patterns $Exclude) { return $false }
        if ($Include.Count -gt 0 -and -not (Matches-Path -RelativePath $_.RelativePath -Patterns $Include)) { return $false }
        if (-not (Test-TextFile -Path $_.Item.FullName)) { return $false }
        return $true
    } |
    Sort-Object RelativePath

$revision = 'UNKNOWN'
try {
    $revision = (git -C $rootPath rev-parse HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($revision)) { $revision = 'UNKNOWN' }
}
catch {
    $revision = 'UNKNOWN'
}

$generated = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
$project = Split-Path -Leaf $rootPath

$lines = [Collections.Generic.List[string]]::new()
$lines.Add('=== PMCR-O SOURCE DUMP ===')
$lines.Add('FORMAT: PMCR-O-SOURCE-DUMP/1')
$lines.Add("PROJECT: $project")
$lines.Add("REVISION: $revision")
$lines.Add("GENERATED: $generated")
$lines.Add('')
$lines.Add('=== MANIFEST ===')
$lines.Add("ROOT: $rootPath")
$lines.Add("FILES: $($files.Count)")
$lines.Add('')

foreach ($entry in $files) {
    $relative = $entry.RelativePath
    $type = Get-FileType -RelativePath $relative
    $content = [IO.File]::ReadAllText($entry.Item.FullName)

    $lines.Add("=== FILE: $relative ===")
    $lines.Add("TYPE: $type")
    $lines.Add('ENCODING: utf-8')
    $lines.Add('--- BEGIN FILE ---')
    if ($content.Length -gt 0) {
        foreach ($line in ($content -split "`r?`n", -1)) {
            $lines.Add($line)
        }
    }
    $lines.Add('--- END FILE ---')
    $lines.Add('')
}

$lines.Add('=== END PMCR-O SOURCE DUMP ===')
$output = [string]::Join("`n", $lines)

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    [Console]::Out.Write($output)
}
else {
    $destination = Resolve-Path -LiteralPath (Split-Path -Parent $OutputPath) -ErrorAction SilentlyContinue
    if (-not $destination) {
        $parent = Split-Path -Parent $OutputPath
        if (-not [string]::IsNullOrWhiteSpace($parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
    }
    [IO.File]::WriteAllText((Join-Path (Get-Location).Path $OutputPath), $output, [Text.UTF8Encoding]::new($false))
    Write-Output "Source dump written to $OutputPath"
}
