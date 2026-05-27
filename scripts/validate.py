#!/usr/bin/env python3
"""Validate marketplace structure: marketplace.json + plugin manifests + skill frontmatter.

Also checks for merge-conflict markers in tracked files and for duplicate
skill names across plugins.

Run from the repo root: python3 scripts/validate.py
Exits with non-zero status on any error.
"""
import json
import os
import re
import subprocess
import sys
import glob


# Real conflict markers are at column 0 of a line. This anchoring excludes
# the marker strings appearing inside string literals (like this file).
CONFLICT_REGEX = re.compile(r"^(<{7}|>{7}|={7})\s", re.M)


def check_conflict_markers() -> list[str]:
    """Scan tracked text files for git merge conflict markers (line-anchored)."""
    errors: list[str] = []
    try:
        result = subprocess.run(
            ["git", "ls-files"], capture_output=True, text=True, check=True
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return errors
    seen: set[str] = set()
    for f in result.stdout.strip().split("\n"):
        if not f or f in seen or not os.path.isfile(f):
            continue
        seen.add(f)
        try:
            content = open(f, encoding="utf-8", errors="replace").read()
        except OSError:
            continue
        if CONFLICT_REGEX.search(content):
            errors.append(f"CONFLICT MARKER in {f}")
    return errors


def main() -> int:
    errors: list[str] = []

    mp_path = ".claude-plugin/marketplace.json"
    mp = None
    try:
        mp = json.load(open(mp_path, encoding="utf-8"))
        print(f"Marketplace: {mp['name']} v{mp['version']} - {len(mp['plugins'])} plugins")
    except json.JSONDecodeError as e:
        errors.append(f"{mp_path}: invalid JSON - {e}")
    except FileNotFoundError:
        errors.append(f"{mp_path}: not found")

    for p in (mp["plugins"] if mp else []):
        src = p["source"].lstrip("./")
        if not os.path.isdir(src):
            errors.append(f"plugin {p['name']}: source dir missing ({src})")
        pj = os.path.join(src, ".claude-plugin", "plugin.json")
        if not os.path.exists(pj):
            errors.append(f"plugin {p['name']}: plugin.json missing at {pj}")

    plugin_jsons = sorted(glob.glob("plugins/*/.claude-plugin/plugin.json"))
    for pj_path in plugin_jsons:
        pj = json.load(open(pj_path, encoding="utf-8"))
        plugin_dir = os.path.basename(os.path.dirname(os.path.dirname(pj_path)))
        print(f"  plugin: {plugin_dir} v{pj.get('version', '?')}")
        for required in ("name", "version", "description"):
            if required not in pj:
                errors.append(f"{pj_path}: missing required field '{required}'")
        if pj.get("name") != plugin_dir:
            errors.append(f"{pj_path}: name={pj.get('name')} != dir={plugin_dir}")

    skill_count = 0
    names_seen: dict[str, list[str]] = {}
    for sm in sorted(glob.glob("plugins/*/skills/*/SKILL.md")):
        # Skip vendored upstream content
        if "upstream" in sm.split(os.sep):
            continue
        skill_count += 1
        skill_dir = os.path.basename(os.path.dirname(sm))
        content = open(sm, encoding="utf-8").read()
        if not content.startswith("---"):
            errors.append(f"{sm}: no frontmatter")
            continue
        parts = content.split("---", 2)
        if len(parts) < 3:
            errors.append(f"{sm}: malformed frontmatter")
            continue
        fm = parts[1]
        name_match = re.search(r"^name:\s*[\"']?([^\"'\n]+)[\"']?\s*$", fm, re.M)
        name = name_match.group(1).strip() if name_match else None
        desc_match = re.search(r"^description:\s*(\S.*)", fm, re.M)
        if name != skill_dir:
            errors.append(f"NAME MISMATCH dir={skill_dir} name={name} ({sm})")
        if not desc_match:
            errors.append(f"NO DESCRIPTION: {sm}")
        if name:
            names_seen.setdefault(name, []).append(sm)

    # Cross-plugin duplicate detection
    for name, paths in names_seen.items():
        if len(paths) > 1:
            errors.append(
                f"DUPLICATE SKILL NAME '{name}' in {len(paths)} places: "
                + ", ".join(paths)
            )

    # Merge conflict markers
    conflict_errors = check_conflict_markers()
    errors.extend(conflict_errors)

    print(f"\nValidated {skill_count} skills across {len(plugin_jsons)} plugins")
    print(f"Conflict-marker scan: {len(conflict_errors)} finding(s)")
    print(f"Errors: {len(errors)}")
    for e in errors[:20]:
        print(f"  {e}")
    if len(errors) > 20:
        print(f"  ... and {len(errors) - 20} more")

    if errors:
        return 1
    print("\n[OK] All checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
