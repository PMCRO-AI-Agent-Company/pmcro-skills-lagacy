# Trail Product: product-20260903-090953-file-based-run-recovery-and-intake-durability

product_id: product-20260903-090953-file-based-run-recovery-and-intake-durability
version: 0.1.0
scope: Deterministic Run/Checkpoint/Lease/Heartbeat/Recovery for a claimed queue item, plus durable pre-classification message intake, for a file-based (queue.jsonl + session-state.md + trails/) PMCR-O engine implementation
evidence_class: native
created_at: 2026-09-03T14:09:53Z

## Provenance (source trails)
- cycle-20260903-123224-task-wire-run-lease-into-pmcro-loop-engine
- cycle-20260903-125025-task-seed-intent-queue-ingress

## Assumptions
Consumer repo has a PowerShell 7+ (or Windows PowerShell 5.1+) deterministic engine layer that performs file-mechanics only and defers all classification/recovery-decision reasoning to a model or human; consumer has a single shared queue.jsonl-style backlog, not per-team queues.

## Known limitations
PowerShell array-return-unrolling footguns (see constraint-20260903-090939-powershell-array-return-wrapping) are documented and worked around but not eliminated at the language level -- a consumer reimplementing this in another language will not inherit the same footgun but must independently verify its own array/collection semantics at each call site. The CRLF/LF git-diff false-positive verification caveat is specific to a Linux-bridge-vs-Windows-native-repo environment and may not apply to a consumer running entirely on one OS.

## Reusable skill / marketplace references
- pmcro-loop:queue-claim
- pmcro-loop:orchestrate
- pmcro:foundation -> run-recovery-lease.md
- pmcro:foundation -> retrospective-trail-reconstruction.md

## Identity binding
Per trail-as-product.md: this product supplies learned procedure and
evidence only. A consumer runtime supplies its own execution identity,
operator identity, authority, accounts/resources, and approvals when it
re-executes this product -- this manifest does not carry or imply any of
those, whatever evidence_class says about the strength of the procedure
itself.