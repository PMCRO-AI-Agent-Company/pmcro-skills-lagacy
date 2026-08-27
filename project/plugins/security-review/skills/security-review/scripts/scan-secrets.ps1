#requires -version 5.1
<#
.SYNOPSIS
    Scans a git diff for common hardcoded-secret patterns.

.DESCRIPTION
    Fast pre-check for the security-review skill: greps added lines
    (diff lines starting with a single '+') against a set of regexes
    for common credential/secret shapes. Not a substitute for the
    full manual checklist (see ../references/checklist.md) — this
    only catches obviously-shaped secrets, not logic-level auth or
    injection issues.

.PARAMETER DiffArgs
    Arguments passed straight through to `git diff` (e.g. a branch
    name, path, or nothing for the working tree diff).

.EXAMPLE
    ./scan-secrets.ps1 main
.EXAMPLE
    ./scan-secrets.ps1
#>
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$DiffArgs
)

$patterns = @(
    @{ Name = "AWS Access Key ID";        Regex = 'AKIA[0-9A-Z]{16}' }
    @{ Name = "AWS Secret Access Key";    Regex = '(?i)aws_secret_access_key\s*[:=]\s*[''"][A-Za-z0-9/+=]{40}[''"]' }
    @{ Name = "Generic API key assign";   Regex = '(?i)(api[_-]?key|secret|token|password)\s*[:=]\s*[''"][A-Za-z0-9\-_./+=]{12,}[''"]' }
    @{ Name = "Private key header";       Regex = '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----' }
    @{ Name = "Slack token";              Regex = 'xox[baprs]-[0-9A-Za-z-]{10,}' }
    @{ Name = "GitHub token";             Regex = 'gh[pousr]_[A-Za-z0-9]{36,}' }
    @{ Name = "JWT-looking string";       Regex = 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' }
)

$diffText = & git diff @DiffArgs
if (-not $diffText) {
    Write-Host "No diff output (empty diff, or invalid git args: $DiffArgs)."
    exit 0
}

$findings = @()
$currentFile = "(unknown file)"
$lineNo = 0

foreach ($line in $diffText) {
    if ($line -match '^\+\+\+ b/(.+)$') {
        $currentFile = $Matches[1]
        $lineNo = 0
        continue
    }
    if ($line -match '^@@ -\d+(?:,\d+)? \+(\d+)') {
        $lineNo = [int]$Matches[1] - 1
        continue
    }
    if ($line -match '^\+' -and $line -notmatch '^\+\+\+') {
        $lineNo++
        $added = $line.Substring(1)
        foreach ($p in $patterns) {
            if ($added -match $p.Regex) {
                $findings += [PSCustomObject]@{
                    File    = $currentFile
                    Line    = $lineNo
                    Pattern = $p.Name
                    Text    = $added.Trim()
                }
            }
        }
    }
    elseif ($line -notmatch '^-') {
        $lineNo++
    }
}

if ($findings.Count -eq 0) {
    Write-Host "No obvious hardcoded secrets found in the diff." -ForegroundColor Green
    exit 0
}

Write-Host "Potential secrets found:" -ForegroundColor Yellow
$findings | Format-Table -AutoSize File, Line, Pattern, Text
Write-Host "`nTreat these as leads, not verdicts — confirm each manually against references/checklist.md before reporting." -ForegroundColor Yellow
exit 1
