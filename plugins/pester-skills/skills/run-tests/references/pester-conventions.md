# This colony's Pester conventions

## Where tests live
`tests/<plugin>/<skill>/<skill>.Tests.ps1`, mirroring
`plugins/<plugin>/scripts/*.ps1` -- e.g.
`tests/pmcro-loop/approve-operation/approve-operation.Tests.ps1` tests
`plugins/pmcro-loop/scripts/approve-operation.ps1` (and, transitively,
the `PmcroEngine.psm1` functions it wraps).

## Shape (see approve-operation.Tests.ps1 as the reference example)
```powershell
Describe 'PMCR-O <thing under test>' {
    BeforeAll {
        $module = Join-Path $PSScriptRoot '../../../plugins/pmcro-loop/engine/PmcroEngine.psm1'
        Import-Module $module -Force
        $root = Join-Path $TestDrive '.pmcro'
        New-Item -ItemType Directory -Force -Path $root | Out-Null
    }

    It 'does the thing' {
        $result = Some-PmcroFunction -PmcroRoot $root -Whatever 'value'
        $result.field | Should -Be 'expected'
    }
}
```
- Import `PmcroEngine.psm1` directly (not the thin wrapper script) so
  assertions run against the actual function, not stdout/JSON
  round-tripping.
- Use Pester's `$TestDrive` for a throwaway `.pmcro` root -- never point
  a test at this repo's real `projects/pmcro-skills/.pmcro/`.
- One `Describe` block per capability under test; one `It` per behavior,
  named as an assertion ("rejects a duplicate id"), not a step number.

## Not every skill has (or needs) a `.Tests.ps1`
`tests/pmcro-loop/queue-enqueue/eval.yaml` is a different thing: an
LLM-eval rubric (prompt + grader pattern), used where the skill's job is
inherently a judgment call (routing, classification) rather than a pure
function with deterministic inputs/outputs. A skill backed by a real
`PmcroEngine.psm1` function should get a `.Tests.ps1` (see
`../queue-enqueue`'s own fix, which added `Add-PmcroQueueItem` +
`enqueue.ps1` + a matching `queue-enqueue.Tests.ps1` for exactly this
reason); a skill that is pure LLM reasoning (e.g. `plan-frame`,
`check-frame`) legitimately doesn't need one.
