# Merge Strategy

## Default: merge commit, not squash or rebase

`git log --oneline` on this repo's own history shows its real merges as
`Merge pull request #N from <owner>/<branch>` commits -- an ordinary
two-parent merge commit, not a squash or a rebase-and-fast-forward. Match
that shape by default:

- `gh pr merge --merge` (not `--squash`, not `--rebase`).
- The local fallback's `git merge --no-ff` (never a plain `git merge`,
  which would fast-forward and produce no merge commit when the branch
  is a strict descendant of the target).

Only deviate (squash a noisy WIP branch, rebase a single trivial commit)
when a task explicitly asks for it -- it's a real, visible change to how
the repo's history reads, not a default to reach for on your own.

## When the local-git-merge fallback is reasonable on your own judgment

- `gh` install genuinely fails (no network egress to
  `api.github.com`/`github.com`, or the portable-zip host is
  unreachable) -- not just "gh isn't installed yet," which
  `setup-gh-cli` should resolve first.
- The branch has already been fully reviewed within the same session --
  e.g. every file in it was individually approved by a human before it
  was written, the way a disposition or upgrade cycle's file-by-file
  approval already works in this colony's own Approval protocol. Merging
  locally at that point isn't skipping review, it's just skipping the
  GitHub UI's re-presentation of review that already happened.

## When to flag it to a human first instead of just doing it

- The first time in a session that gh setup fails and a merge is
  needed -- confirm the fallback is acceptable rather than assuming it,
  per `INSTRUCTIONS.md`'s Approval protocol on main-branch/semi-
  consequential actions. Once a human has confirmed the fallback is fine
  for this session, later merges in the same session don't need to
  re-ask.
- The branch being merged has NOT already been reviewed file-by-file
  within the session (e.g. it's someone else's long-lived branch, or
  work from a much earlier session) -- a local merge then genuinely
  bypasses the review a real PR would have forced, which is a materially
  different risk than the case above.
- Merging would touch a file a human specifically asked to review before
  it lands, regardless of which merge path is used.

## After merging

Delete the now-merged branch on the remote
(`git push origin --delete <branch>`, or `gh pr merge --delete-branch`)
unless there's a reason to keep it (e.g. it's still referenced by an
open, separate PR). A merged branch left around is just clutter -- the
history is preserved in the merge commit either way.
