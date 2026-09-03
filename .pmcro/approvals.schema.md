# PMCR-O Approval Record Schema

`approvals.jsonl` is the append-only authorization ledger for bounded TYPE1 operations.

Each record contains:

- `operation_id`: stable identifier for the proposed mutation.
- `decision`: `approved`, `denied`, or `needs-human-approval`.
- `operation`: human-readable concrete mutation.
- `scope`: exact repository-relative targets covered by the authorization.
- `actor`: role/agent receiving authority.
- `source`: `human` or a named pre-existing delegated policy.
- `destructive`: whether the operation can delete or otherwise irreversibly alter state.
- `approved_at`: UTC timestamp when the record was written.
- `expiry`: optional ISO-8601 expiry.
- `trail_id`: required for approved operations.

## Enforcement rules

1. Approval is scoped to the exact `operation_id` and targets listed in `scope`.
2. An actor may execute only when an unexpired `approved` record covers every target.
3. Destructive operations require `source: human` for an `approved` decision.
4. Missing, expired, denied, or mismatched approvals fail closed.
5. An approval never authorizes secrets/credentials, security bypasses, external publishing, or unrelated operations.
6. The ledger is append-only; corrections are represented by a newer decision record rather than rewriting history.
