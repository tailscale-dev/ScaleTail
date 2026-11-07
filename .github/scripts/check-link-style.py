#!/usr/bin/env python3
"""Check the link style of CONTRIBUTING.md, "Links in Markdown".

Links to repository files must be paths from the repository root, such as
/documentation/standard-setup.md: no ./, ../ or other relative paths, and no
github.com blob/tree URLs of this repository. Code spans and code blocks are
skipped. Files in .github/ keep full URLs and are not checked.

Usage: check-link-style.py [FILE...]  (default: all tracked Markdown files)
Exits 1 when a link breaks the style.
"""
import re
import subprocess
import sys

FENCE = re.compile(r"^\s*(`{3,}|~{3,})")
CODE_SPAN = re.compile(r"(`+).*?\1")
TARGETS = [
    re.compile(r"\]\(\s*<([^>]*)>"),  # [text](<target>)
    # [text](target "title"); text with spaces, such as the template's
    # placeholders, is not a link.
    re.compile(r"""\]\(\s*([^\s)<]+)(?=\s*\)|\s+["'(])"""),
    re.compile(r"^ {0,3}\[(?!\^)[^\]]+\]:\s*<?([^\s>]+)"),  # [ref]: target, not [^footnote]:
    re.compile(r"""\b(?:href|src)\s*=\s*["']([^"']+)"""),  # HTML
]
SCHEME = re.compile(r"^[A-Za-z][A-Za-z0-9+.-]*:")
REPO_URL = re.compile(r"github\.com/tailscale-dev/scaletail/(blob|tree)/", re.I)


def problem(target):
    if REPO_URL.search(target):
        return "github.com URL of this repository"
    if not (target.startswith(("/", "#")) or SCHEME.match(target)):
        return "relative path"
    return None


def check(path):
    found = 0
    fence = None
    with open(path, encoding="utf-8") as f:
        for number, line in enumerate(f, 1):
            m = FENCE.match(line)
            if fence:
                if m and m.group(1)[0] == fence[0] and len(m.group(1)) >= len(fence):
                    fence = None
                continue
            if m:
                fence = m.group(1)
                continue
            line = CODE_SPAN.sub("", line)
            targets = [t for p in TARGETS for t in p.findall(line)]
            # Bare URLs and autolinks are not link targets, so check the text too.
            if not any(REPO_URL.search(t) for t in targets):
                targets += [m.group(0) for m in REPO_URL.finditer(line)]
            for target in targets:
                reason = problem(target)
                if reason:
                    found += 1
                    print(f"::error file={path},line={number}::{reason}: {target}")
    return found


if __name__ == "__main__":
    files = sys.argv[1:] or subprocess.run(
        ["git", "ls-files", "-z", "*.md", ":!.github/*"],
        check=True, capture_output=True, text=True,
    ).stdout.split("\0")[:-1]
    if sum(check(p) for p in files):
        print(
            "Link to repository files with a path from the repository root, such as "
            "/documentation/standard-setup.md. See CONTRIBUTING.md, 'Links in Markdown'."
        )
        sys.exit(1)
