# PMCR-O Capability Gap Schema

`.pmcro/capability-gaps/` holds durable records of a need that neither an
installed capability nor a composition of existing ones covers — see
`pmcro:foundation` -> `capability-gap-and-composition.md` and
`discover-capabilities/SKILL.md`'s Resolution contract step 5.
`New-PmcroCapabilityGap`
(`plugins/pmcro-loop/scripts/new-capability-gap.ps1`) writes the record
shape deterministically and enforces one hard rule: a gap cannot be
recorded without first explaining why composition didn't suffice.

## File naming

`gap-<timestamp>-<slug>.md`, e.g.
`gap-20260903-141719-offline-pdf-ocr.md`.

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| gap_id | yes | Matches the filename stem |
| status | yes | `open` \| `resolved` |
| resolved_by | no | Set when `status: resolved` — the capability/skill name that now covers `Need` |
| discovery_query | no | The `resolve-capability.ps1` query used, if any |
| created_at | yes | ISO-8601 |
| Need (body section) | yes | What was being sought |
| Partial matches found (body section) | no | Weak/partial provider matches discovery returned, if any — `(none found)` if truly zero |
| Why composition doesn't suffice (body section) | yes | `New-PmcroCapabilityGap` refuses to write without this — a gap is not a shortcut around trying composition first |
| Evidence (body section) | yes | At least one trail documenting the search |

## Hard rule

A gap record requires a non-empty `-CompositionConsidered` explanation.
This is enforced by the engine, not left to convention — it is the
deterministic guarantee that gap-recording never substitutes for the
composition step that must come first, per
`capability-gap-and-composition.md`'s procedure.

## Resolution

A gap stays `open` until a capability that actually covers `Need`
exists — an installed provider found on a later `discover-capabilities`
scan, a composition later proven, or a newly scaffolded skill. Set
`status: resolved` and `resolved_by` at that point rather than deleting
the record; the gap's own history (that this need went unmet for a time)
is evidence worth keeping.
