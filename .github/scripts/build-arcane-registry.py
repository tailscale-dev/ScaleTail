#!/usr/bin/env python3
"""Write arcane-registry.json, the Arcane template registry of ScaleTail.

Run it from the repository root, after git add, whenever a stack is added,
renamed, or removed, its row in README.md changes, or it gains or loses a file
other than compose.yaml, .env, and README.md. Name, description, and category
come from the service rows in README.md. Templates point to the files on main,
so changes to compose.yaml and .env reach Arcane without a new registry.
Arcane copies only compose.yaml and .env into a project, so stacks that need
other files are left out, and so are the Arcane stacks themselves.
"""
import hashlib
import json
import re
import subprocess
import sys

OUTPUT = "arcane-registry.json"
REPO = "https://github.com/tailscale-dev/ScaleTail"
RAW = "https://raw.githubusercontent.com/tailscale-dev/ScaleTail/main/services"
SKIP = {"arcane", "arcane-agent"}
# Category in README.md -> tag. Arcane's community registry uses the same tags.
TAGS = {
    "Networking and security": "networking",
    "Media and entertainment": "media",
    "Productivity and collaboration": "productivity",
    "Dashboards and visualization": "dashboard",
    "Development tools": "development",
    "Monitoring and analytics": "monitoring",
    "Smart home": "home-automation",
    "Utilities": "tools",
    "Food and wellness": "household",
}
ROW = re.compile(r"^\| \*\*(.+?)\*\* *\| *(.+?) *\| .*\]\(/?services/([^)/]+)/?\)")
SLUG = re.compile(r"^[a-z0-9-]+$")


def fail(message):
    print(f"::error file={OUTPUT}::{message}")
    sys.exit(1)


def plain(text):
    """Drop Markdown links and code marks from a README description."""
    return re.sub(r"\[([^\]]+)\]\([^)]*\)", r"\1", text).replace("`", "")


rows, category = {}, None
for line in open("README.md", encoding="utf-8"):
    if line.startswith("### "):
        category = line[4:].strip()
    elif match := ROW.match(line):
        rows[match[3]] = (match[1], plain(match[2]), category)

files = {}
tracked = subprocess.run(["git", "ls-files", "services"], capture_output=True, text=True, check=True)
for path in tracked.stdout.splitlines():
    _, name, rest = path.split("/", 2)
    files.setdefault(name, []).append(rest)

templates, left_out = [], []
for name in sorted(files):
    if "compose.yaml" not in files[name]:
        fail(f"services/{name} has no compose.yaml")
    extra = [f for f in files[name] if f not in ("compose.yaml", ".env", "README.md") and not f.startswith("images/")]
    compose = open(f"services/{name}/compose.yaml", encoding="utf-8").read()
    if name in SKIP or extra or re.search(r"^\s+build:", compose, re.M):
        left_out.append(name)
        continue
    if name not in rows:
        fail(f"services/{name} has no row in README.md")
    if not SLUG.match(name):
        fail(f"services/{name}: Arcane needs a folder name of lowercase letters, digits, and hyphens")
    title, description, category = rows[name]
    if category not in TAGS:
        fail(f'README.md category "{category}" has no tag. Add it to TAGS in .github/scripts/build-arcane-registry.py')
    tags = ["tailscale", TAGS[category]]
    # Required by the registry schema, unused by Arcane. It covers the entry only,
    # so that edits to compose.yaml and .env leave this file unchanged.
    digest = hashlib.sha256("\n".join([name, title, description, *tags]).encode()).hexdigest()
    templates.append({
        "id": name,
        "name": title,
        "description": description,
        "version": "1.0.0",
        "author": "ScaleTail",
        "compose_url": f"{RAW}/{name}/compose.yaml",
        "env_url": f"{RAW}/{name}/.env",
        "documentation_url": f"{REPO}/tree/main/services/{name}",
        "content_hash": digest,
        "tags": tags,
    })

registry = {
    "$schema": "https://registry.getarcane.app/schema.json",
    "name": "ScaleTail",
    "description": "Self-hosted applications that join your tailnet through a Tailscale sidecar.",
    "version": "1.0.0",
    "author": "ScaleTail",
    "url": REPO,
    "templates": templates,
}
with open(OUTPUT, "w", encoding="utf-8") as out:
    out.write(json.dumps(registry, indent=2, ensure_ascii=False) + "\n")
print(f"Templates: {len(templates)}")
print(f"Left out: {', '.join(left_out)}")
