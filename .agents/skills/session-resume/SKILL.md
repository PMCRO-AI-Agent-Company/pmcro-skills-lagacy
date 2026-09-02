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
