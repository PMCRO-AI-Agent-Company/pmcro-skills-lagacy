---
name: setup-gh-cli
description: Detects, installs (portable, no admin/winget required), and authenticates the GitHub CLI (gh) on a Windows machine so PR operations can use the real GitHub API instead of local-only git. Use before any task that needs to open/merge a PR, check CI status, or otherwise touch GitHub beyond plain push/pull.
license: MIT
---

# Setup gh CLI

Discovering, at the moment a PR needs opening, that `gh` isn't installed
and `winget` isn't available either, is a recurring, avoidable delay.
This skill makes that a one-script check instead of a fresh
investigation every session.

## When to use this

Before any task that needs more than plain `git push`/`git pull` against
GitHub: opening or merging a PR, checking a check-run/CI status,
commenting on an issue or PR, etc. Plain git operations do not need this
skill — the existing git credential helper already authenticates those.

## Workflow

1. Run `scripts/install-gh-portable.ps1`. It is idempotent: if `gh` is
   already on `PATH` and runs, it does nothing but report the version
   and exit. Otherwise it downloads the current Windows portable (zip)
   release from `https://api.github.com/repos/cli/cli/releases/latest`,
   extracts it under `$env:LOCALAPPDATA\pmcro-skills-tools\gh` (outside
   any repo working tree — never commit the extracted binary), and adds
   that directory to the current session's `PATH`. It does **not**
   require admin rights or `winget`/`choco`/any package manager.
2. Check auth: `gh auth status`. If not authenticated, see
   `references/gh-cli-setup.md` for the two auth paths that actually
   work from an automated/non-interactive shell, and why the obvious
   third option (reusing the existing git credential helper's stored
   token) does not.
3. Once `gh auth status` reports logged in, `pr-lifecycle`'s scripts (or
   any direct `gh` invocation) work normally.

## What this deliberately does not do

- It does not silently fall back to committing straight to `main` if
  install/auth fails — that decision belongs to `pr-lifecycle`'s
  documented fallback, and to whoever is running the task, not to a
  install script.
- It does not store or print an auth token anywhere. `gh auth login`
  manages its own credential storage; this skill never touches it
  directly.

## References

- `references/gh-cli-setup.md` — the portable-install rationale, the two
  working non-interactive auth paths, and the credential-extraction
  dead end found and documented so it is not re-investigated.

## Scripts

- `scripts/install-gh-portable.ps1` — idempotent, no-admin `gh` install.
