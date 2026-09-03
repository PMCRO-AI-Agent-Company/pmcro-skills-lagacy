# PMCR-O Earned Knowledge Schema

`.pmcro/constraints/` holds durable, evidence-backed records promoted from
Trail experience — see `pmcro:foundation` -> `knowledge-promotion.md` for
the promotion criteria (recurrence, scope, outcome quality, evidence
strength, contradiction with existing knowledge) that must be satisfied
*before* a record is written here. This file documents the record's file
shape once that judgment has been made; `New-PmcroConstraint`
(`plugins/pmcro-loop/scripts/new-constraint.ps1`) enforces the shape and
the one hard rule below deterministically, but does not make the
promotion judgment itself.

Distinct from `runtime-baseline.md`, which is a foundational, hand-authored
colony law rather than a per-cycle earned record.

## File naming

`<kind>-<timestamp>-<slug>.md`, e.g.
`constraint-20260903-140733-array-return-wrapping.md`.

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| constraint_id | yes | Matches the filename stem |
| kind | yes | One of: `constraint`, `rule-policy`, `strategy-preference`, `skill-candidate`, `training-example`, `audit-record` — mirrors the taxonomy in `knowledge-promotion.md` |
| scope | yes | The narrowest valid scope the evidence actually supports (`accountability-and-trails.md`) |
| status | yes | `provisional` \| `active` \| `superseded` |
| superseded_by | no | Set when `status: superseded`; the id of the record that replaced this one |
| created_at | yes | ISO-8601 |
| Statement (body section) | yes | The actual rule/observation/candidate being recorded |
| Evidence (body section) | yes | At least one source trail id — `New-PmcroConstraint` refuses to write a record with none |

## Hard rule

An earned record must cite at least one trail as evidence. This is
enforced by the engine, not left to convention — an unevidenced "earned"
record contradicts the word "earned."

## Scope discipline

Widening a record's `scope` beyond what its cited evidence demonstrated is
not an in-place edit. Write a new record with the wider scope (backed by
whatever new evidence justifies the widening) and set the old record's
`status` to `superseded` with `superseded_by` pointing at the new one.
History is preserved, never overwritten.

## Reconstructed evidence

A record whose evidence trail(s) are retrospective (`retro-` prefix, see
`retrospective-trail-reconstruction.md`) carries capped evidence strength
per `knowledge-promotion.md` — it can support `provisional`/`audit-record`
but should not alone justify `active` `rule-policy`/`skill-candidate`
status the way independently-checked, repeated native-trail evidence can.
