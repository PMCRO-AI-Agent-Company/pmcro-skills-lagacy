Describe 'PMCR-O TYPE1 approval gate' {
    BeforeAll {
        $module = Join-Path $PSScriptRoot '../../../plugins/pmcro-loop/engine/PmcroEngine.psm1'
        Import-Module $module -Force
        $root = Join-Path $TestDrive '.pmcro'
        New-Item -ItemType Directory -Force -Path $root | Out-Null
        Set-Content (Join-Path $root 'session-state.md') '# Session State`nstatus: idle'
    }

    It 'records and accepts an exact bounded approval' {
        $record = Save-PmcroApproval -PmcroRoot $root -OperationId 'op-1' -Decision approved `
            -Operation 'modify file' -Scope @('src/a.cs') -Actor 'maker' -Source 'policy' -TrailId 'trail-1'
        $record.decision | Should -Be 'approved'
        Test-PmcroApproval -PmcroRoot $root -OperationId 'op-1' -Targets @('src/a.cs') -Actor 'maker' | Should -BeTrue
    }

    It 'fails closed for an out-of-scope target' {
        Test-PmcroApproval -PmcroRoot $root -OperationId 'op-1' -Targets @('src/b.cs') -Actor 'maker' | Should -BeFalse
    }

    It 'rejects delegated approval for destructive operations' {
        { Save-PmcroApproval -PmcroRoot $root -OperationId 'op-2' -Decision approved `
            -Operation 'delete file' -Scope @('old.txt') -Actor 'maker' -Source 'policy' -TrailId 'trail-2' -Destructive } | Should -Throw
    }

    It 'permits explicit human approval for destructive operations' {
        $record = Save-PmcroApproval -PmcroRoot $root -OperationId 'op-3' -Decision approved `
            -Operation 'delete file' -Scope @('old.txt') -Actor 'maker' -Source 'human' -TrailId 'trail-3' -Destructive
        $record.destructive | Should -BeTrue
    }
}
