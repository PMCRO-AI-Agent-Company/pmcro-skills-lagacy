# Template Contract

Templates are inert text resources. The renderer substitutes only declared
placeholders and never evaluates their contents as PowerShell or another code
language.

Supported placeholders:

- `{{PROJECT_NAME}}`
- `{{DISPLAY_NAME}}`
- `{{DESCRIPTION}}`
- `{{PLUGIN_NAME}}`
- `{{PLUGIN_DESCRIPTION}}`

A template fails validation if an unknown placeholder remains after rendering.
Output paths must remain beneath the requested destination. Generated JSON
must parse before the generation operation is considered successful.
