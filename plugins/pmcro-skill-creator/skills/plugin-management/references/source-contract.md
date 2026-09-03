# Plugin source contract

Supported source kinds are intentionally small and deterministic.

- `./relative/path`: local plugin already present in the repository.
- `https://...git`: remote Git repository fetched into controlled staging.
- `github:owner/repo`: shorthand for a GitHub repository.

Optional `ref` pins a branch, tag, or commit. Prefer immutable commit SHAs for
production locks. `trust` is provenance metadata, not permission to execute.

## Trust levels

- `first-party`: repository-owned plugin.
- `third-party`: externally maintained plugin.
- `local`: operator-created local plugin.
- `generated`: produced by this repository's generators.

Registration must validate the plugin before it is added to a marketplace.
Third-party scripts are inspected as files and are never run during import.
