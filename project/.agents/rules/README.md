# rules/

Path-scoped conventions — automatically relevant whenever a matching
file is being touched, rather than something explicitly invoked like
a command or triggered like a skill.

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

One Markdown file per rule set. Frontmatter:

```yaml
---
paths:
  - "glob/pattern/**/*.ts"
---
```

`paths` is a list of glob patterns; the rule applies whenever the
runtime is working on a file matching one of them. Body is plain
prose listing the actual conventions.

## Current rules

- `api-design.md` — applies to `src/api/**/*.ts`; endpoint validation,
  response shape, rate limiting.
- `testing.md` — applies to `**/*.test.ts` and `**/*.test.tsx`; test
  naming, mocking, cleanup conventions.
