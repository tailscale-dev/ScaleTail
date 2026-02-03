#!/usr/bin/env python3
"""Generate Arcane registry.json from /services."""
from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Tuple

REPO_ROOT = Path(__file__).resolve().parents[1]
SERVICES_DIR = REPO_ROOT / "services"
ROOT_README = REPO_ROOT / "README.md"
REPO_SLUG_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
REF_RE = re.compile(r"^[A-Za-z0-9._/-]+$")


def slugify(value: str) -> str:
    value = value.encode("ascii", "ignore").decode()
    value = value.lower()
    value = value.replace("&", "and")
    value = re.sub(r"[^a-z0-9]+", "-", value)
    return value.strip("-")


def title_from_id(value: str) -> str:
    parts = re.split(r"[-_]+", value)
    return " ".join(p.capitalize() for p in parts if p)


def normalize_service_name(value: str) -> str:
    base = value.strip()
    patterns = [
        r"\s+with\s+Tailscale\s+Sidecar\s+Configuration\s*$",
        r"\s+with\s+Tailscale\s+Sidecar\s*$",
        r"\s+with\s+Tailscale\s+Configuration\s*$",
        r"\s+with\s+Tailscale\s*$",
        r"\s+Tailscale\s+Sidecar\s+Configuration\s*$",
        r"\s+Tailscale\s+Sidecar\s*$",
        r"\s+Sidecar\s+Configuration\s*$",
    ]
    for pattern in patterns:
        base = re.sub(pattern, "", base, flags=re.IGNORECASE)
    base = base.strip(" -")
    if not base:
        base = value.strip()
    return base


def first_heading(text: str) -> Optional[str]:
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("# "):
            return line[2:].strip()
    return None


def first_paragraph(text: str) -> Optional[str]:
    lines = text.splitlines()
    idx = 0
    # skip leading empty lines
    while idx < len(lines) and not lines[idx].strip():
        idx += 1
    # skip first heading line if present
    if idx < len(lines) and lines[idx].lstrip().startswith("#"):
        idx += 1
        while idx < len(lines) and not lines[idx].strip():
            idx += 1
    if idx >= len(lines):
        return None
    paragraph: List[str] = []
    while idx < len(lines) and lines[idx].strip():
        paragraph.append(lines[idx].strip())
        idx += 1
    if not paragraph:
        return None
    return " ".join(paragraph)


def read_text(path: Path) -> Optional[str]:
    if not path.exists():
        return None
    return path.read_text(encoding="utf-8")


def parse_category_map(readme_path: Path) -> Dict[str, str]:
    text = read_text(readme_path)
    if not text:
        return {}
    category = None
    mapping: Dict[str, str] = {}
    for line in text.splitlines():
        heading = re.match(r"^###\s+(.+)$", line.strip())
        if heading:
            category = heading.group(1).strip()
            continue
        if not category:
            continue
        for match in re.finditer(r"\[Details\]\((services/[^)]+)\)", line):
            service_path = match.group(1)
            service_key = service_path.replace("services/", "", 1).strip("/")
            mapping[service_key] = slugify(category)
    return mapping


def validate_repo_slug(repo: str) -> str:
    if not REPO_SLUG_RE.match(repo):
        raise SystemExit(f"Invalid repo slug '{repo}'; expected owner/name")
    return repo


def validate_ref(ref: str) -> str:
    if not ref or not REF_RE.match(ref):
        raise SystemExit(f"Invalid ref '{ref}'")
    if ref.startswith("/") or ref.endswith("/") or ".." in ref or "//" in ref:
        raise SystemExit(f"Invalid ref '{ref}'")
    return ref


def infer_repo_slug(repo_arg: Optional[str]) -> Optional[str]:
    if repo_arg:
        return validate_repo_slug(repo_arg)
    env_repo = os.environ.get("GITHUB_REPOSITORY")
    if env_repo:
        return validate_repo_slug(env_repo)
    try:
        url = (
            subprocess.check_output(
                ["git", "remote", "get-url", "origin"],
                cwd=REPO_ROOT,
                text=True,
            )
            .strip()
            .rstrip("/")
        )
    except Exception:
        return None
    if url.startswith("git@"):
        # git@github.com:owner/repo.git
        repo = url.split(":", 1)[-1]
    else:
        # https://github.com/owner/repo.git
        repo = url.split("github.com/", 1)[-1]
    if repo.endswith(".git"):
        repo = repo[:-4]
    return validate_repo_slug(repo)


def resolve_output_path(output_arg: str) -> Path:
    output_path = Path(output_arg)
    if not output_path.is_absolute():
        output_path = REPO_ROOT / output_path
    resolved = output_path.resolve()
    try:
        resolved.relative_to(REPO_ROOT)
    except ValueError:
        raise SystemExit(
            f"Output path '{resolved}' must be inside repository {REPO_ROOT}"
        )
    return resolved


def build_raw_base(repo: str, ref: str) -> str:
    return f"https://raw.githubusercontent.com/{repo}/{ref}"


def pick_readme(compose_dir: Path) -> Tuple[Optional[Path], bool]:
    local_readme = compose_dir / "README.md"
    if local_readme.exists():
        return local_readme, False
    parent_readme = compose_dir.parent / "README.md"
    if parent_readme.exists():
        return parent_readme, True
    return None, False


def build_template(
    compose_path: Path,
    repo: str,
    ref: str,
    category_map: Dict[str, str],
) -> Dict[str, object]:
    rel_compose = compose_path.relative_to(REPO_ROOT).as_posix()
    service_rel = compose_path.parent.relative_to(SERVICES_DIR).as_posix()
    template_id = service_rel.replace("/", "-")
    name = title_from_id(template_id)

    readme_path, parent_readme = pick_readme(compose_path.parent)
    description = None
    if readme_path:
        readme_text = read_text(readme_path)
        if readme_text:
            heading = first_heading(readme_text)
            if heading and not (parent_readme and "/" in service_rel):
                name = heading
            description = first_paragraph(readme_text)

    if not description:
        description = f"Self-hosted {name} template."

    name = normalize_service_name(name)

    env_path = compose_path.parent / ".env"
    rel_env = env_path.relative_to(REPO_ROOT).as_posix()

    documentation_url = None
    if readme_path:
        documentation_url = (
            build_raw_base(repo, ref) + "/" + readme_path.relative_to(REPO_ROOT).as_posix()
        )

    category_tag = None
    if service_rel in category_map:
        category_tag = category_map[service_rel]
    else:
        parent_key = service_rel.split("/", 1)[0]
        category_tag = category_map.get(parent_key, "scaletail")

    template = {
        "id": template_id,
        "name": name,
        "description": description,
        "version": "1.0.0",
        "author": "ScaleTail",
        "compose_url": build_raw_base(repo, ref) + "/" + rel_compose,
        "env_url": build_raw_base(repo, ref) + "/" + rel_env,
        "documentation_url": documentation_url
        or build_raw_base(repo, ref) + "/" + rel_compose,
        "tags": [category_tag],
    }
    return template


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate registry.json")
    parser.add_argument("--repo", help="GitHub repo in owner/name format")
    parser.add_argument("--ref", default=os.environ.get("GITHUB_REF_NAME", "main"))
    parser.add_argument(
        "--output",
        default=str(REPO_ROOT / "registry.json"),
        help="Output path for registry.json",
    )
    args = parser.parse_args()

    repo = infer_repo_slug(args.repo)
    if not repo:
        raise SystemExit("Unable to determine repo slug; pass --repo owner/name")
    ref = validate_ref(args.ref)

    category_map = parse_category_map(ROOT_README)

    templates: List[Dict[str, object]] = []
    for compose_path in sorted(SERVICES_DIR.rglob("compose.yaml")):
        env_path = compose_path.parent / ".env"
        if not env_path.exists():
            raise SystemExit(f"Missing .env for {compose_path}")
        templates.append(build_template(compose_path, repo, ref, category_map))

    templates.sort(key=lambda t: str(t["id"]))

    registry = {
        "name": "ScaleTail Templates",
        "description": "Curated Tailscale sidecar Docker configurations for self-hosted services.",
        "version": "1.0.0",
        "author": "ScaleTail",
        "url": f"https://github.com/{repo}",
        "templates": templates,
    }

    output_path = resolve_output_path(args.output)
    output_path.write_text(json.dumps(registry, indent=2) + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
