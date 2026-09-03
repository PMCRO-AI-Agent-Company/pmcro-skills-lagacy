# .mcp.json

Project-scoped MCP server configuration. Keep secrets out of committed configuration; use environment-variable references.

Template: `../assets/templates/mcp.json.template`.

Validation: require valid JSON and an `mcpServers` object. Never fabricate credentials or server commands.