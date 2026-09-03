# github-skills

Getting a working `gh` CLI on a machine that has none, and using it (or a
documented fallback) to open and merge pull requests, without guessing or
re-discovering the same friction every session.

## Skills

`setup-gh-cli` · `pr-lifecycle`

## Why this plugin exists

Born directly from a real gap: a session working on this repo needed to
open and merge two PRs, found `gh` not installed and `winget`
unavailable, and found that extracting a token from the existing git
credential helper to call the GitHub API directly did not work through
automated (non-TTY) stdin, even though plain `git push`/`git pull`
authenticated fine through the same helper. `setup-gh-cli` documents a
portable (no-admin, no-winget) install path and the auth options that
actually work non-interactively; `pr-lifecycle` wraps
`gh pr create`/`gh pr merge` and documents the local-git-merge fallback
(`--no-ff`, matching this ecosystem's "Merge pull request #N" history
convention) for when `gh` genuinely isn't available.
