#!/usr/bin/env python3
"""Validate marketplace structure: marketplace.json + plugin manifests + skill frontmatter.

Run from the repo root: python3 scripts/validate.py
Exits with non-zero status on any error.
"""
import json
import os
import re
import sys
import glob


def main() -> int:
    errors: list[str] = []

    mp_path = ".claude-plugin/marketplace.json"
    mp = json.load(open(mp_path))
    print(f"Marketplace: {mp['name']} v{mp['version']} — {len(mp['plugins'])} plugins")

    for p in mp["plugins"]:
        src = p["source"].lstrip("./")
        if not os.path.isdir(src):
            errors.append(f"plugin {p['name']}: source dir missing ({src})")
        pj = os.path.join(src, ".claude-plugin", "plugin.json")
        if not os.path.exists(pj):
            errors.append(f"plugin {p['name']}: plugin.json missing at {pj}")

    plugin_jsons = sorted(glob.glob("plugins/*/.claude-plugin/plugin.json"))
    for pj_path in plugin_jsons:
        pj = json.load(open(pj_path))
        plugin_dir = os.path.basename(os.path.dirname(os.path.dirname(pj_path)))
        print(f"  plugin: {plugin_dir} v{pj.get('version', '?')}")
        for required in ("name", "version", "description"):
            if required not in pj:
                errors.append(f"{pj_path}: missing required field '{required}'")
        if pj.get("name") != plugin_dir:
            errors.append(f"{pj_path}: name={pj.get('name')} != dir={plugin_dir}")

    skill_count = 0
    for sm in sorted(glob.glob("plugins/*/skills/*/SKILL.md")):
        skill_count += 1
        skill_dir = os.path.basename(os.path.dirname(sm))
        content = open(sm).read()
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

    print(f"\nValidated {skill_count} skills across {len(plugin_jsons)} plugins")
    print(f"Errors: {len(errors)}")
    for e in errors[:20]:
        print(f"  {e}")
    if len(errors) > 20:
        print(f"  … and {len(errors) - 20} more")

    if errors:
        return 1
    print("\n✓ All checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
