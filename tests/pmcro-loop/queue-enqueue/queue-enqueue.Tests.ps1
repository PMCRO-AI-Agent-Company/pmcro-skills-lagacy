Describe 'PMCR-O queue enqueue' {
    BeforeAll {
        $module = Join-Path $PSScriptRoot '../../../plugins/pmcro-loop/engine/PmcroEngine.psm1'
        Import-Module $module -Force
        $root = Join-Path $TestDrive '.pmcro'
        New-Item -ItemType Directory -Force -Path $root | Out-Null
    }

    It 'appends a fully-scoped item with status open and a created_at timestamp' {
        $item = Add-PmcroQueueItem -PmcroRoot $root -Id 'task-a' -SeedIntent 'Do the thing' -Priority 3 -CreatedBy 'human'
        $item.status | Should -Be 'open'
        $item.created_at | Should -Not -BeNullOrEmpty
        # @() wrap required: Get-PmcroQueue's array return is unrolled by
        # PowerShell for a single-item queue (constraint-20260903-090939-
        # powershell-array-return-wrapping.md) -- .Count on the unwrapped
        # pscustomobject would silently be $null, not 1.
        (@(Get-PmcroQueue -PmcroRoot $root)).Count | Should -Be 1
    }

    It 'rejects a duplicate id rather than silently overwriting' {
        { Add-PmcroQueueItem -PmcroRoot $root -Id 'task-a' -SeedIntent 'Do it again' -Priority 3 } | Should -Throw
    }

    It 'rejects a priority outside the 0-4 colony scale' {
        { Add-PmcroQueueItem -PmcroRoot $root -Id 'task-bad-priority' -SeedIntent 'x' -Priority 9 } | Should -Throw
    }

    It 'appends a second item, preserves the first, and carries domain/blocked_by' {
        Add-PmcroQueueItem -PmcroRoot $root -Id 'task-b' -SeedIntent 'Do another thing' -Priority 2 -Domain 'cto' -BlockedBy @('task-a') | Out-Null
        $queue = @(Get-PmcroQueue -PmcroRoot $root)
        $queue.Count | Should -Be 2
        ($queue | Where-Object { $_.id -eq 'task-a' }) | Should -Not -BeNullOrEmpty
        $taskB = $queue | Where-Object { $_.id -eq 'task-b' }
        $taskB.domain | Should -Be 'cto'
        $taskB.blocked_by | Should -Contain 'task-a'
    }
}
