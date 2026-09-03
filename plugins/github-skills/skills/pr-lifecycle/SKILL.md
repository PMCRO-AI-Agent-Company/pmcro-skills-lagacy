---
name: pr-lifecycle
description: Opens and merges GitHub pull requests via gh once it's set up (see setup-gh-cli), with a documented local-git-merge fallback for when gh genuinely isn't available. Use whenever colony work needs to land a branch on a protected/default branch through review, or must merge without gh.
license: MIT
---

# PR Lifecycle

Two paths to the same outcome -- a branch landed on the default branch
with a clear merge commit -- depending on whether `gh` is actually usable
right now.

## Preferred path: real PRs via gh

1. Run `setup-gh-cli`'s `install-gh-portable.ps1` and confirm
   `gh auth status` reports logged in.
2. `scripts/open-pr.ps1 -Base main -Head <branch> -Title "..." -BodyFile <path>`
   wraps `gh pr create`.
3. `scripts/merge-pr.ps1 -Number <pr-number>` wraps
   `gh pr merge --merge` (a real merge commit, matching this ecosystem's
   existing "Merge pull request #N" history -- never `--squash` or
   `--rebase` unless a task explicitly asks for it).
4. `gh pr merge` deletes the head branch on the remote by default when
   the repo is configured that way; otherwise clean up explicitly with
   `git push origin --delete <branch>` once merged.

## Fallback: gh unavailable

When `gh` truly cannot be made to work (network egress blocks
api.github.com, or a human declines the device-flow auth step), merge
locally instead of leaving the branch un-landed:

```powershell
git checkout main
git pull
git merge --no-ff <branch> -m "Merge branch '<branch>'`n`n<why>"
git push origin main
git push origin --delete <branch>   # cleanup once merged
```

`--no-ff` is required -- a fast-forward merge leaves no merge commit and
loses the "this was reviewed/landed as a unit" shape this repo's history
otherwise has everywhere else. See `references/merge-strategy.md` for
when this fallback is/isn't appropriate to reach for on your own
judgment versus flagging it to a human first.

## What this deliberately does not do

- It does not choose squash or rebase merges by default -- this repo's
  existing history is merge-commit shaped (`git log` shows
  "Merge pull request #N"), and diverging from that silently would make
  history harder to read, not easier.
- It does not auto-delete branches that aren't confirmed merged.
- It does not decide *for* a session whether local-merge-to-main is
  acceptable when gh isn't set up -- that is exactly the kind of
  main-branch, semi-consequential decision this repo's own
  `INSTRUCTIONS.md` Approval protocol says should be confirmed rather
  than assumed, the first time it comes up in a session.

## References

- `references/merge-strategy.md` — merge-commit vs squash vs rebase, and
  when the local-fallback path is/isn't a reasonable default to reach
  for without asking first.

## Scripts

- `scripts/open-pr.ps1` — `gh pr create` wrapper.
- `scripts/merge-pr.ps1` — `gh pr merge` wrapper (merge-commit strategy).
