# commands/

Slash-command definitions — short, explicitly-invoked tasks (as
opposed to `../skills/`, which are meant to auto-trigger from
conversational context).

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

One Markdown file per command, named after it
(`fix-issue.md` → `/fix-issue`). Frontmatter fields in use:

| Field | Required | Notes |
|---|---|---|
| `argument-hint` | No | Shown to the user as the expected argument shape, e.g. `<issue-number>` |

Body can embed a shell command with `` !`command $ARGUMENTS` `` to
inject live output before the instructions, same pattern used in
`fix-issue.md`.

## Current commands

- `fix-issue.md` — looks up a GitHub issue by number and works through
  fixing it.
