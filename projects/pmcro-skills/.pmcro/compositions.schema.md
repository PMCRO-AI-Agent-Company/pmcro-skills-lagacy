# PMCR-O Capability Composition Schema

`.pmcro/compositions/` holds records of 2+ existing capabilities used
together to cover a need no single installed provider covers alone — see
`pmcro:foundation` -> `capability-gap-and-composition.md`.
`New-PmcroCapabilityComposition`
(`plugins/pmcro-loop/scripts/new-capability-composition.ps1`) writes the
record shape deterministically; deciding whether the composition actually
works is Reflector/model reasoning done before calling it.

## File naming

`composition-<timestamp>-<slug>.md`, e.g.
`composition-20260903-141534-crlf-safe-diff-scope-check.md`.

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| composition_id | yes | Matches the filename stem |
| status | yes | `candidate` \| `promoted` \| `superseded` |
| proven | yes | **derived automatically** — `true` when 2+ independent evidence trails are cited, `false` otherwise; never asserted by the caller |
| created_at | yes | ISO-8601 |
| Need (body section) | yes | What this composition covers |
| Composed of (body section) | yes | At least 2 parts — a single capability is not a composition |
| How it composes (body section) | yes | How the parts actually combine |
| Evidence (body section) | yes | At least one source trail where it was exercised |

## `proven` derivation

Mirrors `New-PmcroTrailProduct`'s `evidence_class` derivation and
`knowledge-promotion.md`'s own bar ("repeated, independently checked
observations can justify stronger policy"): a composition backed by only
one trail is `proven: false` (still a reasonable `candidate`, just not
yet demonstrated to generalize); two or more independent trails flips it
to `true`.

## Promotion

Per `capability-gap-and-composition.md`: a `proven` composition is a
skill candidate, not yet a first-class capability. Promote it by writing
a `skill-candidate` earned-knowledge record (`New-PmcroConstraint`) that
cites this composition, then scaffold the real skill via `/createskill`.
Once promoted, set `status: promoted` on this record rather than deleting
it — the composition remains the evidence trail for the resulting skill.
