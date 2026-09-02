---
name: session-resume
description: Resumes work on this repository from its current documented state. Use when starting or resuming a session so the agent reads the repository source of truth, operating instructions, and roadmap before editing. Do not use as a substitute for reading the live files.
---

# Session Resume

Follow the repository's current entry-point instructions exactly:

1. Resolve the repository root from the checkout; never hardcode a
   machine-specific drive letter into committed content.
2. Verify the available filesystem/connector tool with a read-only call
   before any write.
3. Read `AGENTS.md`, then the repository's documented context,
   instructions, and roadmap files when those paths exist.
4. Check current git status before making changes.
5. Follow the active instructions and preserve the repository's existing
   architecture and conventions.

This skill is a pointer, not a duplicate. Re-read the live files each
session because they are authoritative and can change.

## Validation

Run `scripts/verify-entrypoints.ps1 -RepoRoot <path>` to confirm this
repo's required entry points (`AGENTS.md`, `README.md`) exist before
relying on step 3. It also reports, non-blockingly, whether the
optional `.agents/skills/README.md` and `LAYOUTS.md` are present. Use
`assets/resume-report.md.template` as the starting shape for
recording what was read and what work is in progress.

## References

- [references/resume-order.md](references/resume-order.md) — deterministic resume ordering and entrypoint checks.
