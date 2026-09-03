# Trail Format (per-repo — not global)

Earned constraint: do not assume one universal "sealed trail" schema
across all PMCR-O repos. Each PMCR-O implementation owns its own trail
schema; check which schema a given repo's engine actually implements
before validating or authoring a trail against it.

## Known schema classes

### Class A — single-file markdown trail
One markdown file per cycle, named by cycle timestamp + task id, with
`## PlanFrame / MakeFrame / CheckFrame / Reflection` sections and a
`trail_sealed: true|false` flag. Backed by a deterministic engine that
does file-mechanics only (session-state read/write, queue claim, trail
skeleton with PENDING placeholders) and hands off to the LLM phases —
no reasoning happens in the engine itself.

### Class B — structured per-phase trail
GUID-folder trail with one JSONL file per phase plus a disposition
manifest:
- plan phase: `{Steps:[{Index,Action,SubjectAgent,ActionType}],SuccessCriteria}`
- make phase: `{StepResults:[{StepIndex,Action,Output,Ok}]}`
- check phase: `{CheckItems:[{StepIndex,Passed,Criterion,FailureEvidence}]}`
- reflect phase: `{Disposition,FinalOutput,RawReflection,HaltReason,RetryContext}`
- disposition manifest: `{Disposition,FinalOutput,RetryContext,HaltReason,CycleNumber,NextSeedIntent}`

Field casing/shape must match the concrete runtime's own serializer
convention — never invent a shape (e.g. a generic `{seq,content}`
form) without confirming it against that runtime's actual writer.

## Rule for this repo
`pmcro-skills` documents schema classes generically and does not hold
a stake in — or hardcode a path to — any specific external repo's
instance of either class.
