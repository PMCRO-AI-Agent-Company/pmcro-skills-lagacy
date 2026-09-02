# Project Topology

The canonical Agent Skills application separates authoring tools from
marketplace products.

```text
.agents/skills/       repository authoring/session skills
plugins/              distributable plugins
plugins/<name>/skills/ distributable skills
tests/<plugin>/<skill>/ evaluation contracts
```

A generated marketplace may contain any domain-specific plugin names. The
project generator supplies the structure; domain skills supply their content.

For an existing repository, manifests are authoritative for plugin identity
and filesystem inspection is authoritative for whether referenced artifacts
actually exist.
