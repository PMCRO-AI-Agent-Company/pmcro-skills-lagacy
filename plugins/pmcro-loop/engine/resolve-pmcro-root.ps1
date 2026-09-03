<#
.SYNOPSIS
  Locates the nearest .pmcro directory by walking upward from a start path.

.DESCRIPTION
  Never silently defaults to a guessed path (consistent with the "no
  hardcoded paths" mandate followed elsewhere in this repo). Throws a
  clear error if no .pmcro directory is found before reaching the
  filesystem root.

.PARAMETER StartPath
  Directory to begin the upward search from. Defaults to the current
  location.
#>
function Find-PmcroRoot {
    param(
        [string]$StartPath = (Get-Location).Path
    )
    $current = Resolve-Path -Path $StartPath
    while ($true) {
        $candidate = Join-Path $current '.pmcro'
        if (Test-Path $candidate -PathType Container) {
            return $candidate
        }
        $parent = Split-Path -Parent $current
        if ([string]::IsNullOrEmpty($parent) -or $parent -eq $current) {
            throw "No .pmcro directory found walking up from '$StartPath'. Pass -PmcroRoot explicitly."
        }
        $current = $parent
    }
}
