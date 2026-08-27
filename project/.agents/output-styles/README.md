# output-styles/

Response/output style presets — reusable tone, format, or structure
overrides the runtime can apply to a task independent of which
persona or skill is handling it.

Part of the `.agents/` PMCRO runtime spec — see `../README.md`.

## Convention

One Markdown file per style. Frontmatter:

```yaml
---
name: <style-name>
description: >
  What this style optimizes for and when to reach for it.
---
```

Body is plain prose — the formatting/tone rules to apply. Keep it to
a short bullet list; a style that needs paragraphs of caveats is
probably actually a rule or an agent persona instead.

## Current styles

- `concise.md` — terse, code/answer-first, minimal preamble. The
  reference style the convention above was written against.
