#!/usr/bin/env bash
# Install Agents Skill Directory layouts into a target project and/or user home.
#
# Usage:
#   ./scripts/install-template.sh [project-root] [--global]
#
# Examples:
#   ./scripts/install-template.sh .              # copy project layout into current dir
#   ./scripts/install-template.sh ./MyApp        # copy into MyApp
#   ./scripts/install-template.sh . --global     # also install global (~/) layout

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_SRC="$ROOT/template/project"
GLOBAL_SRC="$ROOT/template/global"
TARGET="${1:-.}"
DO_GLOBAL=false

for arg in "$@"; do
  case "$arg" in
    --global) DO_GLOBAL=true ;;
  esac
done

if [[ ! -d "$PROJECT_SRC" ]]; then
  echo "[ERROR] Missing template/project at $PROJECT_SRC" >&2
  exit 1
fi

mkdir -p "$TARGET"
echo "[OK] Installing project layout into $TARGET"

# Root project files
cp -f "$PROJECT_SRC/AGENTS.md" "$TARGET/AGENTS.md" 2>/dev/null || true
cp -f "$PROJECT_SRC/.mcp.json" "$TARGET/.mcp.json" 2>/dev/null || true
cp -f "$PROJECT_SRC/.worktreeinclude" "$TARGET/.worktreeinclude" 2>/dev/null || true

# .agents tree (do not overwrite settings.local.json if present)
mkdir -p "$TARGET/.agents"
rsync -a --exclude 'settings.local.json' "$PROJECT_SRC/.agents/" "$TARGET/.agents/" 2>/dev/null \
  || cp -R "$PROJECT_SRC/.agents/." "$TARGET/.agents/"

if [[ -f "$PROJECT_SRC/.agents/settings.local.json" && ! -f "$TARGET/.agents/settings.local.json" ]]; then
  cp "$PROJECT_SRC/.agents/settings.local.json" "$TARGET/.agents/settings.local.json"
fi

echo "[OK] Project layout installed:"
echo "     AGENTS.md  .mcp.json  .worktreeinclude  .agents/{settings,rules,skills,commands,agents,workflows,output-styles,agents-memory}"

if $DO_GLOBAL; then
  HOME_AGENTS="${HOME}/.agents"
  mkdir -p "$HOME_AGENTS"
  rsync -a "$GLOBAL_SRC/.agents/" "$HOME_AGENTS/" 2>/dev/null \
    || cp -R "$GLOBAL_SRC/.agents/." "$HOME_AGENTS/"
  if [[ -f "$GLOBAL_SRC/.agents.json" ]]; then
    if [[ ! -f "${HOME}/.agents.json" ]]; then
      cp "$GLOBAL_SRC/.agents.json" "${HOME}/.agents.json"
      echo "[OK] Wrote ~/.agents.json"
    else
      echo "[SKIP] ~/.agents.json already exists"
    fi
  fi
  echo "[OK] Global layout installed under ~/.agents/"
fi

echo ""
echo "Next:"
echo "  - Edit AGENTS.md and .agents/settings.json for your stack"
echo "  - Add **/.agents/settings.local.json to .gitignore if needed"
echo "  - Commit the committed files; leave settings.local.json untracked"
