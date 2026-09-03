# Earned Knowledge: skill-candidate-20260903-092347-crlf-safe-scope-check

constraint_id: skill-candidate-20260903-092347-crlf-safe-scope-check
kind: skill-candidate
scope: live-edit scope verification on Windows/CRLF checkouts accessed via the remote-devices bridge
status: active
superseded_by: 
created_at: 2026-09-03T14:23:47Z

## Statement
A live-edit scope-check on a Windows/CRLF checkout should run git diff --ignore-all-space --stat via the Linux bridge shell rather than plain git status/git diff, which produce whole-repo false positives from line-ending normalization noise. See compositions/composition-20260903-092309-crlf-safe-scope-check.md for the proven composition this generalizes.

## Evidence (source trails)
- cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine
- cycle-20260903-125025-task-seed-intent-queue-ingress
- cycle-20260903-140236-task-retrospective-trail-ingestion
- cycle-20260903-141005-task-trail-as-product-evolution

## Narrowest valid scope
Per accountability-and-trails.md: the narrowest valid scope should be
preserved, and evidence should support confidence and later supersession.
Widening this record's scope beyond what the cited evidence actually
demonstrated requires new evidence, not an edit to this file -- write a
new record and set this one's status to superseded / superseded_by
instead of loosening scope in place.