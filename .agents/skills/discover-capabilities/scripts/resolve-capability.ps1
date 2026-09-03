[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $RegistryPath,
    [Parameter(Mandatory)] [string] $Query,
    [int] $Top = 10
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$registry = Get-Content -LiteralPath $RegistryPath -Raw | ConvertFrom-Json
$terms = @($Query.ToLowerInvariant() -split '\s+' | Where-Object { $_ })

$results = foreach ($provider in @($registry.providers)) {
    $text = (([string]$provider.name) + ' ' + ([string]$provider.description) + ' ' +
        ((@($provider.capabilities) | ForEach-Object { [string]$_.name + ' ' + [string]$_.description }) -join ' ')).ToLowerInvariant()
    $hits = @($terms | Where-Object { $text.Contains($_) }).Count
    if ($hits -gt 0) {
        [pscustomobject]@{
            score = $hits
            provider = [string]$provider.name
            version = [string]$provider.version
            project = [string]$provider.project
            root = [string]$provider.root
            manifest = [string]$provider.manifest
            capabilities = @($provider.capabilities | ForEach-Object { [string]$_.name })
        }
    }
}
$results | Sort-Object -Property score -Descending | Select-Object -First $Top | ConvertTo-Json -Depth 8
