# Trail: cycle-20260903-145720-task-project-upgrade-doc-version-crlf

trail_id: cycle-20260903-145720-task-project-upgrade-doc-version-crlf
task_id: task-project-upgrade-doc-version-crlf
domain: pmcro-governance
priority: 3
opened: 2026-09-03
run_id: task-project-upgrade-doc-version-crlf
checkpoint_ref: (none — single uninterrupted session)
trail_sealed: true

## Seed intent
Human instruction (verbatim, informal): "just make sure you do a entire
project updgradee and iupdate Agents.md content etc if needed push
everyuthing if recommanded etc." Investigated first rather than guessing
scope (root AGENTS.md content, plugin version.json/plugin.json files,
marketplace.json version-sync requirements, git history of version
numbers, absence of a CHANGELOG) and presented findings via a multiSelect
AskUserQuestion with four options. The human selected all three
substantial items offered: doc pass on what shipped this session, bump
plugin versions, and normalize the repo-wide CRLF noise (did not select
"something else").

## OrchestratorFrame

### 1. Doc pass on what shipped this session
Reviewed the reference docs and SKILL.md files this session actually
added or touched: `run-recovery-lease.md`,
`retrospective-trail-reconstruction.md`, `capability-gap-and-composition.md`,
`knowledge-promotion.md`, `trail-as-product.md`,
`accountability-and-trails.md`, `seed-intent-contract.md`,
`session-bootstrap.md`, `trail-frame-schema.md`,
`reflect-and-seed/SKILL.md`, `make-frame/SKILL.md`, `orchestrate/SKILL.md`,
`queue-claim/SKILL.md`, `discover-capabilities/SKILL.md`,
`send-message.md`, `trail-format.md`, and every `.pmcro/*.schema.md` file
this session added.

Method (repo-wide grep, not spot-reading): (1) scanned all of them for
`TODO|FIXME|XXX|\[see below\]|PLACEHOLDER|TBD` — one hit, a legitimate use
of the word "placeholders" in `trail-format.md` describing the trail
skeleton mechanism itself, not a leftover marker; (2) extracted every
backtick-quoted `.md`/`.ps1`/`.psm1`/`.jsonl` filename referenced across
those docs and resolved each against the actual filesystem — one real
defect found (below), the rest either resolved directly or were
illustrative example filenames in the schema docs (e.g.
`gap-20260903-141719-offline-pdf-ocr.md` as a naming-convention example,
never meant to exist); (3) extracted every `New-Pmcro*`/`Get-Pmcro*`/etc.
function name cited across those docs and diffed it against
`PmcroEngine.psm1`'s actual `Export-ModuleMember` list — zero mismatches.

**Defect found and fixed**: `capability-gap-and-composition.md` step 1
cited discover-capabilities' scripts as
`` `.agents/skills/discover-capabilities/scripts/discover-capabilities.ps1` ``
— missing the `projects/pmcro-skills/` prefix the path actually needs
from repo root (confirmed via `find`: the real files live at
`projects/pmcro-skills/.agents/skills/discover-capabilities/scripts/`).
Fixed to the full, unambiguous repo-relative path.

Also spot-verified the two reciprocal cross-references
`capability-gap-and-composition.md` promised
(`discover-capabilities/SKILL.md` and `knowledge-promotion.md`) are both
actually wired — confirmed via grep, both correctly cite it.

### 2. Bump plugin versions
Evidence gathered before bumping: `plugins/pmcro-loop/version.json`,
`.claude-plugin/plugin.json`, and `.codex-plugin/plugin.json` were all
`0.1.0`; `git log --oneline --all` on each shows exactly one commit in
their entire history (the original `f3d3d62` marketplace/tooling
alignment commit) — version numbers have never been bumped in this
repo's actual practice, for any plugin, despite many subsequent
feature-adding commits. `plugins/pmcro/.claude-plugin/plugin.json` was
`0.2.2` with no `version.json` at all (confirmed ENOENT). Marketplace
manifests (`.claude-plugin/marketplace.json` etc.) carry no `version`
field for any plugin entry (confirmed via repo-wide grep across all 7
marketplace.json copies) — no synchronization was needed there.

Bumped: `pmcro-loop` 0.1.0 → 0.2.0 (minor — Run/Lease/Recovery, Intake,
Retrospective Trail, Constraint/TrailProduct, and Capability
Composition/Gap are all new, additive engine capabilities shipped this
session) across all three of its manifest files; `pmcro` 0.2.2 → 0.2.3
(patch — reference-doc additions and cross-reference wiring only, no
schema/behavior change) across its two manifest files.

### 3. Normalize the repo-wide CRLF noise
Investigated before acting: no `.gitattributes` existed;
`core.autocrlf` was unset at both repo-local and global git config scope
(checked via the Linux bridge mount's git). This was presented to the
human as "~300 files show only line-ending differences."

**Finding that changed the plan mid-execution**: that ~300-file number
was a false signal. Checking out `main` cleanly and running
`git status`/`git add --renormalize .` through the actual Windows git
client (the one this checkout is really used from) showed a completely
clean tree both before and after renormalization — every tracked blob is
already stored as LF, and this machine's Git for Windows has a
system-level `core.autocrlf=true`
(`C:\Program Files\Git\etc\gitconfig`, confirmed via
`git config --system --get core.autocrlf` and
`git config --list --show-origin`) that was already converting correctly
on every checkout/commit. That setting lives outside the repo and outside
`--global`/`--local` config scope, which is why the earlier query missed
it. The apparent noise came from diffing this Windows checkout through
the Linux-mounted bridge shell, which has no autocrlf conversion layer of
its own and so compared raw checked-out CRLF bytes against LF-stored
blobs — a cross-environment comparison artifact, not a repo defect.
`git add --renormalize .` on a fresh branch off `main` changed exactly
one file: the new `.gitattributes` itself (verified via
`git status --porcelain` immediately before committing).

Added `.gitattributes` (`* text=auto` plus explicit `binary` markers for
`.png/.jpg/.jpeg/.gif/.ico/.pdf/.zip/.dll/.exe`) anyway — not because
anything was broken, but to make the line-ending policy explicit and
reproducible for any future clone or contributor, rather than depending
on one machine's undocumented installer default.

## MakeFrame
- `plugins/pmcro/skills/foundation/references/capability-gap-and-composition.md`
  — one-line path fix (see above).
- `plugins/pmcro-loop/version.json`,
  `plugins/pmcro-loop/.claude-plugin/plugin.json`,
  `plugins/pmcro-loop/.codex-plugin/plugin.json` — `0.1.0` → `0.2.0`.
- `plugins/pmcro/.claude-plugin/plugin.json`,
  `plugins/pmcro/.codex-plugin/plugin.json` — `0.2.2` → `0.2.3`.
- New file `.gitattributes` at repo root (`chore/normalize-line-endings`
  branch only, based on `main`, not the feature branch — kept separate
  since it's a mechanical, unrelated, repo-policy change rather than part
  of the feature work).

Committed to two branches, both pushed to `origin`:
- `feat/pmcro-o-run-recovery-through-capability-lifecycle` — second
  commit `da1d208` (`chore(pmcro): doc-pass fix and plugin version bumps
  for this session's work`), on top of the already-pushed `0136770`.
  PR still not opened (`gh` CLI unavailable on this machine); GitHub's
  PR-creation URL was already given to the human for the first commit and
  remains valid for the branch as a whole:
  https://github.com/PMCRO-AI-Agent-Company/pmcro-skills/pull/new/feat/pmcro-o-run-recovery-through-capability-lifecycle
- `chore/normalize-line-endings` — new branch off `main`, single commit
  `c11f3db` (`chore: add .gitattributes for explicit line-ending
  policy`), pushed with tracking set up. PR-creation URL:
  https://github.com/PMCRO-AI-Agent-Company/pmcro-skills/pull/new/chore/normalize-line-endings

## CheckFrame
verdict: pass

- Doc pass: verified via the repo-wide grep/cross-reference/function-name
  scan described above (method, not spot-check) — one real defect found
  and fixed, confirmed no others.
- Version bumps: re-read all 5 manifest files after editing to confirm
  exact target values landed (`0.2.0` ×3, `0.2.3` ×2); confirmed no
  `version` field exists in any `marketplace.json` so no further sync was
  required.
- CRLF: verified the renormalize step's actual diff scope via
  `git status --porcelain` before committing (exactly 1 file: the new
  `.gitattributes`) rather than trusting the earlier ~300-file estimate;
  that estimate itself was traced to its root cause (Linux-bridge git has
  no autocrlf layer) rather than left unexplained.
- Both branches verified clean (`git status` → "nothing to commit,
  working tree clean") and pushed (`git push` output confirmed remote
  branch refs updated) before this trail was sealed.
- Scope discipline maintained throughout: each of the three approved
  work items landed on the branch it actually belongs to (doc
  fix + version bumps on the feature branch they describe;
  `.gitattributes` on its own branch off `main`), verified via
  `git status --porcelain` immediately before each `git commit` to
  confirm only the intended files were staged.

## Reflection
outcome: done
next_seed_intent: (none required — this closes the "entire project
upgrade" instruction as scoped by the human's multiSelect answer). Two
open items remain for the human, not the colony: (1) open the two PRs —
`gh` CLI is not installed on this machine, so both PR-creation URLs above
were handed to the human rather than opened automatically; (2) decide
whether to install `gh` for future sessions, which was offered but not
yet answered.

Notable finding worth carrying forward: **cross-environment git
comparisons on this repo are unreliable for line-ending questions
specifically** — the Linux bridge mount's git has no `core.autocrlf`
configured at any scope it can see, while this Windows checkout's actual
git relies on a system-level (not global, not repo-local) `autocrlf=true`
set by the Git for Windows installer. Any future diff of this checkout
that crosses between the two shells should scope-check with
`git diff --ignore-all-space` (already dogfooded as a proven composition
this session) before treating a raw `git status`/`git diff` from either
side as ground truth on content changes, and should treat a
Linux-bridge-observed line-ending diff as inconclusive on its own — worth
a `skill-candidate`/constraint record if this recurs on a future task,
per `knowledge-promotion.md`'s recurrence bar (this is the first
occurrence, so not promoted yet).
