# PMCR-O Trail Product Schema

`.pmcro/products/` holds Trail Product manifests — packaged, reusable
operational experience per `pmcro:foundation` -> `trail-as-product.md`.
`New-PmcroTrailProduct`
(`plugins/pmcro-loop/scripts/new-trail-product.ps1`) writes the manifest
shape deterministically; deciding whether the source trail(s) actually
validate the product for reuse is Reflector/model reasoning done before
calling it.

## File naming

`product-<timestamp>-<slug>.md`, e.g.
`product-20260903-140733-lease-recovery-workflow.md`.

## Fields

| Field | Required | Notes |
|-------|----------|-------|
| product_id | yes | Matches the filename stem |
| version | yes | Free-form (default `0.1.0`); bump on a materially changed manifest |
| scope | yes | What this product actually covers — narrowest valid framing |
| evidence_class | yes | `native` \| `reconstructed` \| `mixed` — **derived automatically** from the source trail id prefixes (`cycle-` vs. `retro-`), never asserted by the caller |
| created_at | yes | ISO-8601 |
| Provenance (body section) | yes | At least one source trail id — refused if empty |
| Assumptions (body section) | no | Conditions the product assumes hold in a consumer runtime |
| Known limitations (body section) | no | Where reuse may not hold |
| Reusable skill / marketplace references (body section) | no | Related skills/capabilities this product draws on or could seed |

## evidence_class derivation

- All source trails are `cycle-*` (native, live-verified) → `native`.
- All source trails are `retro-*` (reconstructed, see
  `retrospective-trail-reconstruction.md`) → `reconstructed`.
- A mix of both → `mixed`.

This mirrors `trail-as-product.md`'s provenance requirement: a product's
declared evidence strength must reflect what its actual source trails can
support, not what would make the product look stronger.

## Identity binding

A Trail Product manifest never carries or implies consumer execution
identity, operator identity, authority, accounts/resources, or approvals —
see `trail-as-product.md` "Identity binding." The manifest supplies
procedure and evidence; the runtime that re-executes it supplies
everything else.
