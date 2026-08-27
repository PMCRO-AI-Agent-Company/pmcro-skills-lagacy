#!/usr/bin/env python3
"""Structural quality gate for this repo's skills, plugins, and evals.

Scoped-down cousin of dotnet/skills' eng/eval-quality checker: same idea
(catch structural defects before they masquerade as skill regressions),
much smaller surface, no external dependencies.

Usage:
    python eng/eval-quality/check_eval_quality.py           # errors only
    python eng/eval-quality/check_eval_quality.py --strict  # warnings fail too

Run from the repository root.
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

try:
    import yaml  # type: ignore
    HAVE_YAML = True
except ImportError:
    HAVE_YAML = False

ROOT = Path(__file__).resolve().parents[2]
MAX_DESCRIPTION_CHARS = 1024

errors: list[str] = []
warnings: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def warn(msg: str) -> None:
    warnings.append(msg)


def read_frontmatter(skill_md: Path) -> dict:
    """Extract the YAML frontmatter block between the first two '---' lines."""
    text = skill_md.read_text(encoding="utf-8")
    m = re.match(r"^---\s*\n(.*?)\n---\s*\n", text, re.DOTALL)
    if not m:
        err(f"{rel(skill_md)}: missing '---' frontmatter block")
        return {}
    block = m.group(1)
    if HAVE_YAML:
        try:
            data = yaml.safe_load(block) or {}
            if not isinstance(data, dict):
                err(f"{rel(skill_md)}: frontmatter did not parse to a mapping")
                return {}
            return data
        except yaml.YAMLError as e:
            err(f"{rel(skill_md)}: frontmatter is not valid YAML ({e})")
            return {}
    # Fallback: crude key: value line scan, good enough for our checks.
    data = {}
    for line in block.splitlines():
        m2 = re.match(r"^([A-Za-z_-]+):\s*(.*)$", line)
        if m2:
            data.setdefault(m2.group(1), m2.group(2).strip())
    return data


def rel(p: Path) -> str:
    try:
        return str(p.relative_to(ROOT))
    except ValueError:
        return str(p)


def check_skill(skill_dir: Path) -> None:
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.exists():
        err(f"{rel(skill_dir)}: no SKILL.md")
        return
    fm = read_frontmatter(skill_md)

    name = fm.get("name")
    if not name:
        err(f"{rel(skill_md)}: frontmatter missing required 'name'")
    elif name != skill_dir.name:
        err(f"{rel(skill_md)}: frontmatter name '{name}' != folder name '{skill_dir.name}'")

    description = fm.get("description")
    if not description:
        err(f"{rel(skill_md)}: frontmatter missing required 'description'")
    elif len(str(description)) > MAX_DESCRIPTION_CHARS:
        err(f"{rel(skill_md)}: description is {len(str(description))} chars, "
            f"over the {MAX_DESCRIPTION_CHARS}-char budget")

    # Structured-layout convention: only scripts/, references/, assets/
    # subfolders are recognized alongside SKILL.md — anything else at
    # this level, or an empty recognized subfolder, is a defect.
    known_dirs = {"scripts", "references", "assets"}
    for child in sorted(skill_dir.iterdir()):
        if child.name in (".git",) or child == skill_md:
            continue
        if child.is_dir():
            if child.name not in known_dirs:
                err(f"{rel(skill_dir)}: unrecognized subfolder '{child.name}/' "
                    f"(expected one of scripts/, references/, assets/ — see skills/README.md)")
            elif not any(child.iterdir()):
                err(f"{rel(child)}: empty — remove it until there's a real file to put here "
                    f"(see skills/README.md)")

    references_dir = skill_dir / "references"
    if references_dir.is_dir():
        skill_text = skill_md.read_text(encoding="utf-8")
        for ref_file in sorted(references_dir.glob("*.md")):
            link_target = f"references/{ref_file.name}"
            if link_target not in skill_text:
                warn(f"{rel(skill_dir)}: {link_target} exists but isn't linked from SKILL.md "
                     f"(add a '## References' entry)")

    # Every skill should have a matching eval somewhere under tests/.
    matches = list((ROOT / "tests").rglob(f"{skill_dir.name}/eval.yaml")) if (ROOT / "tests").exists() else []
    if not matches:
        warn(f"{rel(skill_dir)}: no tests/**/{skill_dir.name}/eval.yaml found")


def check_eval(eval_yaml: Path) -> None:
    if not HAVE_YAML:
        warn(f"{rel(eval_yaml)}: PyYAML not installed, skipping deep validation")
        return
    try:
        data = yaml.safe_load(eval_yaml.read_text(encoding="utf-8"))
    except yaml.YAMLError as e:
        err(f"{rel(eval_yaml)}: invalid YAML ({e})")
        return
    if not isinstance(data, dict):
        err(f"{rel(eval_yaml)}: root is not a mapping")
        return
    for required in ("name", "stimuli"):
        if required not in data:
            err(f"{rel(eval_yaml)}: missing required top-level key '{required}'")
    stimuli = data.get("stimuli") or []
    if not isinstance(stimuli, list) or len(stimuli) == 0:
        err(f"{rel(eval_yaml)}: 'stimuli' must be a non-empty list")
        return
    for i, s in enumerate(stimuli):
        if not isinstance(s, dict):
            err(f"{rel(eval_yaml)}: stimuli[{i}] is not a mapping")
            continue
        if not s.get("prompt"):
            err(f"{rel(eval_yaml)}: stimuli[{i}] missing 'prompt'")
        graders = s.get("graders")
        if not graders:
            err(f"{rel(eval_yaml)}: stimuli[{i}] has no graders — nothing verifies success")


def check_plugin(plugin_dir: Path) -> None:
    plugin_json = plugin_dir / "plugin.json"
    claude_json = plugin_dir / ".claude-plugin" / "plugin.json"
    if not plugin_json.exists():
        err(f"{rel(plugin_dir)}: missing plugin.json")
        return
    try:
        canonical = json.loads(plugin_json.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        err(f"{rel(plugin_json)}: invalid JSON ({e})")
        return
    if not claude_json.exists():
        err(f"{rel(plugin_dir)}: missing .claude-plugin/plugin.json (Claude Code won't see this plugin)")
    else:
        try:
            mirror = json.loads(claude_json.read_text(encoding="utf-8"))
            if mirror.get("name") != canonical.get("name") or mirror.get("version") != canonical.get("version"):
                err(f"{rel(claude_json)}: name/version out of sync with {rel(plugin_json)}")
        except json.JSONDecodeError as e:
            err(f"{rel(claude_json)}: invalid JSON ({e})")

    if not (plugin_dir / "version.json").exists():
        warn(f"{rel(plugin_dir)}: no version.json")


def check_marketplace() -> None:
    mp_path = ROOT / ".claude-plugin" / "marketplace.json"
    if not mp_path.exists():
        warn("no root .claude-plugin/marketplace.json")
        return
    try:
        data = json.loads(mp_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        err(f"{rel(mp_path)}: invalid JSON ({e})")
        return
    for p in data.get("plugins", []):
        source = p.get("source", "")
        plugin_path = (ROOT / source).resolve()
        if not plugin_path.is_dir():
            err(f"{rel(mp_path)}: plugin '{p.get('name')}' source '{source}' does not exist")
        else:
            check_plugin(plugin_path)


def main() -> int:
    strict = "--strict" in sys.argv

    check_marketplace()

    for eval_yaml in sorted((ROOT / "tests").rglob("eval.yaml")) if (ROOT / "tests").exists() else []:
        check_eval(eval_yaml)

    for skill_md in sorted(ROOT.rglob("SKILL.md")):
        if "/.git/" in str(skill_md) or "\\.git\\" in str(skill_md):
            continue
        check_skill(skill_md.parent)

    for msg in warnings:
        print(f"WARNING: {msg}")
    for msg in errors:
        print(f"ERROR: {msg}")

    print(f"\n{len(errors)} error(s), {len(warnings)} warning(s)")
    if errors or (strict and warnings):
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
