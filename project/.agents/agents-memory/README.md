# agents-memory/

Persistent memory storage, one subdirectory per agent/persona defined
in `../agents/`. Lets a given persona carry state or notes across
runs instead of starting fresh every invocation.

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

```
agents-memory/
└── <agent-name>/
    └── MEMORY.md
```

First persona memory added 2026-08-27: `repo-architect/MEMORY.md`,
written by hand (not yet by a running PMCRO loop) as a stand-in until
the runtime defines its own write path. When one does, create
`<agent-name>/MEMORY.md` matching the persona's name in
`../agents/<agent-name>.md`.

This directory holds runtime-written state, not hand-authored content
— expect it to be gitignored or pruned once the PMCRO runtime defines
its actual memory format. `repo-architect/MEMORY.md` is a deliberate,
flagged exception until then.
