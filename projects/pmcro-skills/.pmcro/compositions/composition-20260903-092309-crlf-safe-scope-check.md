# Capability Composition: composition-20260903-092309-crlf-safe-scope-check

composition_id: composition-20260903-092309-crlf-safe-scope-check
status: candidate
proven: true
created_at: 2026-09-03T14:23:09Z

## Need
Verify only the intended files changed after a live edit, on a Windows/CRLF checkout, without plain git status/git diff producing whole-repo false positives from line-ending normalization noise.

## Composed of
- git diff
- --ignore-all-space flag
- --stat flag
- manual awareness that plain git status/diff is unreliable here

## How it composes
git diff --ignore-all-space --stat suppresses CRLF-only false-positive hunks while --stat keeps the output to a compact per-file changed-line summary; run against the Linux bridge shell (device_bash) after every live edit made via Desktop Commander on the Windows checkout, before sealing a trail, as the scope-check step.

## Evidence (source trails)
- cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine
- cycle-20260903-125025-task-seed-intent-queue-ingress
- cycle-20260903-140236-task-retrospective-trail-ingestion
- cycle-20260903-141005-task-trail-as-product-evolution

## Promotion
Per knowledge-promotion.md: a composition proven across repeated,
independently checked trails is a skill candidate, not yet a first-class
capability. Promote it by writing a 'skill-candidate' earned-knowledge
record (New-PmcroConstraint) that cites this composition, then scaffold
the real skill via /createskill per INSTRUCTIONS.md -- this manifest
records the proof, it does not itself register a capability.