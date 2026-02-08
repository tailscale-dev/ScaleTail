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
REPO_SLUG_RE = re.compile(r"^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$")
REF_RE = re.compile(r"^[A-Za-z0-9._/-]+$")


def title_from_id(value: str) -> str:
    parts = re.split(r"[-_]+", value)
    return " ".join(p.capitalize() for p in parts if p)


def strip_tailscale_suffix(value: str) -> str:
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


def normalize_service_name(value: str) -> str:
    base = strip_tailscale_suffix(value)
    if re.search(r"tailscale", base, re.IGNORECASE):
        return base
    return f"{base} with Tailscale"


def first_heading(text: str) -> Optional[str]:
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("# "):
            return line[2:].strip()
    return None


def _parse_tag_values(raw: str) -> List[str]:
    value = raw.strip()
    if value.startswith(("'", '"')) and value.endswith(("'", '"')) and len(value) > 1:
        value = value[1:-1].strip()
    if value.startswith("[") and value.endswith("]") and len(value) > 1:
        value = value[1:-1].strip()
    parts = [part.strip() for part in value.split(",")]
    tags: List[str] = []
    for part in parts:
        if not part:
            continue
        if part.startswith(("'", '"')) and part.endswith(("'", '"')) and len(part) > 1:
            part = part[1:-1].strip()
        if part:
            tags.append(part)
    return tags


def extract_frontmatter_tags(text: str) -> List[str]:
    lines = text.splitlines()
    idx = 0
    while idx < len(lines) and not lines[idx].strip():
        idx += 1
    if idx >= len(lines) or lines[idx].strip() != "---":
        return []
    idx += 1
    tags_value: Optional[str] = None
    tag_value: Optional[str] = None
    while idx < len(lines) and lines[idx].strip() != "---":
        if tags_value is None:
            match_tags = re.match(
                r"^tags\s*:\s*(.+)\s*$", lines[idx], flags=re.IGNORECASE
            )
            if match_tags:
                tags_value = match_tags.group(1).strip()
        if tag_value is None:
            match_tag = re.match(r"^tag\s*:\s*(.+)\s*$", lines[idx], flags=re.IGNORECASE)
            if match_tag:
                tag_value = match_tag.group(1).strip()
        idx += 1
    if tags_value:
        return _parse_tag_values(tags_value)
    if tag_value:
        return _parse_tag_values(tag_value)
    return []


def ensure_scaletail_tag(tags: List[str]) -> List[str]:
    if any(tag.lower() == "scaletail" for tag in tags):
        return tags
    return ["ScaleTail", *tags]


def read_text(path: Path) -> Optional[str]:
    if not path.exists():
        return None
    return path.read_text(encoding="utf-8")


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
) -> Dict[str, object]:
    rel_compose = compose_path.relative_to(REPO_ROOT).as_posix()
    service_rel = compose_path.parent.relative_to(SERVICES_DIR).as_posix()
    template_id = service_rel.replace("/", "-")
    name = title_from_id(template_id)

    readme_path, parent_readme = pick_readme(compose_path.parent)
    tag_values = ["ScaleTail"]
    if readme_path:
        readme_text = read_text(readme_path)
        if readme_text:
            heading = first_heading(readme_text)
            if heading and not (parent_readme and "/" in service_rel):
                name = heading
            tags = extract_frontmatter_tags(readme_text)
            if tags:
                tag_values = tags
    tag_values = ensure_scaletail_tag(tag_values)

    name = normalize_service_name(name)
    description_name = strip_tailscale_suffix(name)
    description = (
        f"ScaleTail configuration for {description_name} running a Tailscale sidecar."
    )

    env_path = compose_path.parent / ".env"
    rel_env = env_path.relative_to(REPO_ROOT).as_posix()

    documentation_url = None
    if readme_path:
        documentation_url = (
            build_raw_base(repo, ref) + "/" + readme_path.relative_to(REPO_ROOT).as_posix()
        )

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
        "tags": tag_values,
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

    templates: List[Dict[str, object]] = []
    for compose_path in sorted(SERVICES_DIR.rglob("compose.yaml")):
        env_path = compose_path.parent / ".env"
        if not env_path.exists():
            raise SystemExit(f"Missing .env for {compose_path}")
        templates.append(build_template(compose_path, repo, args.ref))

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
