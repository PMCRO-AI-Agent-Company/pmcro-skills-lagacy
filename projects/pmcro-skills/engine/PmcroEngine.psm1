# PmcroEngine.psm1
# Deterministic (non-LLM) state/queue/trail mechanics for the PMCR-O loop.
# This module does NOT call any model API. It only manages the files that
# make up .pmcro/ (session-state.md, queue.jsonl, trails/). Frame reasoning
# content is written as PENDING placeholders for an agent to fill in later.
#
# Robustness notes (colony/throughput-scale pass, 2026-09-02):
# - All writes to queue.jsonl / session-state.md go through
#   Set-PmcroFileAtomic (write temp file, then Move-Item) to avoid
#   truncated/corrupt files if a process is killed mid-write.
# - Claim-PmcroTask takes a file lock (.pmcro/.queue.lock) with retry so
#   two concurrent invocations against the SAME .pmcro root cannot
#   double-claim the same item. This does not coordinate across
#   DIFFERENT repos' .pmcro roots -- each repo's queue stays independent
#   per colony-laws.md.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Set-PmcroFileAtomic {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Content
    )
    $tmp = "$Path.tmp-$([guid]::NewGuid().ToString('N'))"
    Set-Content -Path $tmp -Value $Content -NoNewline
    Move-Item -Path $tmp -Destination $Path -Force
}

function Lock-PmcroQueue {
    <#
      Acquires a simple file-based lock at <PmcroRoot>/.queue.lock,
      retrying up to $TimeoutMs. Returns the lock file path to pass to
      Unlock-PmcroQueue. Throws on timeout.
    #>
    param(
        [Parameter(Mandatory)][string]$PmcroRoot,
        [int]$TimeoutMs = 5000,
        [int]$PollMs = 100
    )
    $lockPath = Join-Path $PmcroRoot '.queue.lock'
    $waited = 0
    while ($true) {
        try {
            $fs = [System.IO.File]::Open($lockPath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write)
            $fs.Close()
            return $lockPath
        } catch [System.IO.IOException] {
            if ($waited -ge $TimeoutMs) {
                throw "Could not acquire queue lock at $lockPath after $TimeoutMs ms -- delete it manually only if you've confirmed no other process is running."
            }
            Start-Sleep -Milliseconds $PollMs
            $waited += $PollMs
        }
    }
}

function Unlock-PmcroQueue {
    param([Parameter(Mandatory)][string]$LockPath)
    if (Test-Path $LockPath) { Remove-Item -Path $LockPath -Force }
}
