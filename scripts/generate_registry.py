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
TAG_MAX_LEN = 32
NAME_MAX_LEN = 80
TAG_SANITIZE_RE = re.compile(r"[^A-Za-z0-9 _.-]")
NAME_SANITIZE_RE = re.compile(r"[\x00-\x1f\x7f<>]")
STANDARD_TAGS = ("ScaleTail", "Tailscale")
TAILSCALE_SUFFIX_RES = (
    re.compile(r"\s+with\s+Tailscale\s+Sidecar\s+Configuration\s*$", re.IGNORECASE),
    re.compile(r"\s+with\s+Tailscale\s+Sidecar\s*$", re.IGNORECASE),
    re.compile(r"\s+with\s+Tailscale\s+Configuration\s*$", re.IGNORECASE),
    re.compile(r"\s+with\s+Tailscale\s*$", re.IGNORECASE),
    re.compile(r"\s+Tailscale\s+Sidecar\s+Configuration\s*$", re.IGNORECASE),
    re.compile(r"\s+Tailscale\s+Sidecar\s*$", re.IGNORECASE),
    re.compile(r"\s+Sidecar\s+Configuration\s*$", re.IGNORECASE),
)
FRONTMATTER_TAG_RE = re.compile(r"^(tags|tag)\s*:\s*(.*)$", re.IGNORECASE)
FRONTMATTER_LIST_ITEM_RE = re.compile(r"^-\s+(.+)$")


def title_from_id(value: str) -> str:
    parts = re.split(r"[-_]+", value)
    return " ".join(p.capitalize() for p in parts if p)


def strip_tailscale_suffix(value: str) -> str:
    base = value.strip()
    for pattern in TAILSCALE_SUFFIX_RES:
        base = pattern.sub("", base)
    base = base.strip(" -")
    if not base:
        base = value.strip()
    return base


def normalize_service_name(value: str) -> str:
    return strip_tailscale_suffix(value)


def first_heading(text: str) -> Optional[str]:
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("# "):
            return line[2:].strip()
    return None


def sanitize_name(value: str) -> str:
    cleaned = NAME_SANITIZE_RE.sub("", value)
    cleaned = re.sub(r"\s+", " ", cleaned).strip()
    if not cleaned:
        cleaned = "Service"
    return cleaned[:NAME_MAX_LEN]


def sanitize_tag(value: str) -> Optional[str]:
    cleaned = TAG_SANITIZE_RE.sub("", value)
    cleaned = re.sub(r"\s+", " ", cleaned).strip()
    if not cleaned:
        return None
    return cleaned[:TAG_MAX_LEN]


def strip_wrapping_quotes(value: str) -> str:
    if len(value) > 1 and value[0] == value[-1] and value[0] in {"'", '"'}:
        return value[1:-1].strip()
    return value


def _parse_tag_values(raw: str) -> List[str]:
    value = raw.strip()
    value = strip_wrapping_quotes(value)
    if value.startswith("[") and value.endswith("]") and len(value) > 1:
        value = value[1:-1].strip()
    parts = [part.strip() for part in value.split(",")]
    tags: List[str] = []
    for part in parts:
        if not part:
            continue
        part = strip_wrapping_quotes(part)
        cleaned = sanitize_tag(part)
        if cleaned:
            tags.append(cleaned)
    return tags


def extract_frontmatter(lines: List[str]) -> List[str]:
    idx = 0
    while idx < len(lines) and not lines[idx].strip():
        idx += 1
    if idx >= len(lines) or lines[idx].strip() != "---":
        return []
    idx += 1
    frontmatter: List[str] = []
    while idx < len(lines) and lines[idx].strip() != "---":
        frontmatter.append(lines[idx])
        idx += 1
    if idx >= len(lines):
        return []
    return frontmatter


def extract_frontmatter_tags(text: str) -> List[str]:
    lines = text.splitlines()
    frontmatter = extract_frontmatter(lines)
    idx = 0
    while idx < len(frontmatter):
        line = frontmatter[idx].strip()
        match = FRONTMATTER_TAG_RE.match(line)
        if not match:
            idx += 1
            continue
        raw_value = match.group(2).strip()
        if raw_value:
            return _parse_tag_values(raw_value)

        idx += 1
        tags: List[str] = []
        while idx < len(frontmatter):
            item = frontmatter[idx].strip()
            if not item:
                idx += 1
                continue
            list_match = FRONTMATTER_LIST_ITEM_RE.match(item)
            if not list_match:
                break
            cleaned = sanitize_tag(strip_wrapping_quotes(list_match.group(1).strip()))
            if cleaned:
                tags.append(cleaned)
            idx += 1
        return tags
    return []


def dedupe_tags(tags: List[str]) -> List[str]:
    seen: set[str] = set()
    result: List[str] = []
    for tag in tags:
        key = tag.lower()
        if key in seen:
            continue
        seen.add(key)
        result.append(tag)
    return result


def ensure_standard_tags(tags: List[str]) -> List[str]:
    deduped = dedupe_tags(tags)
    seen = {tag.lower() for tag in deduped}
    required = [tag for tag in STANDARD_TAGS if tag.lower() not in seen]
    return dedupe_tags([*required, *deduped])


def read_text(path: Path) -> Optional[str]:
    try:
        return path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return None
    except (OSError, UnicodeDecodeError) as exc:
        raise SystemExit(f"Failed to read '{path}': {exc}") from exc


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
        url = subprocess.check_output(
            ["git", "remote", "get-url", "origin"],
            cwd=REPO_ROOT,
            text=True,
        ).strip()
    except (OSError, subprocess.SubprocessError):
        return None
    remote = url.rstrip("/")
    repo: Optional[str] = None
    ssh_match = re.match(r"^git@github\.com:([^/]+/[^/]+?)(?:\.git)?$", remote)
    https_match = re.match(r"^https://github\.com/([^/]+/[^/]+?)(?:\.git)?$", remote)
    if ssh_match:
        repo = ssh_match.group(1)
    elif https_match:
        repo = https_match.group(1)
    if not repo:
        return None
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
    name = sanitize_name(title_from_id(template_id))
    raw_base = build_raw_base(repo, ref)

    readme_path, parent_readme = pick_readme(compose_path.parent)
    tag_values = list(STANDARD_TAGS)
    if readme_path:
        readme_text = read_text(readme_path)
        if readme_text:
            heading = first_heading(readme_text)
            if heading and not (parent_readme and "/" in service_rel):
                name = sanitize_name(heading)
            tags = extract_frontmatter_tags(readme_text)
            if tags:
                tag_values = tags
    tag_values = ensure_standard_tags(tag_values)

    name = normalize_service_name(name)
    description_name = strip_tailscale_suffix(name)
    description = (
        f"ScaleTail configuration for {description_name} running a Tailscale sidecar."
    )

    env_path = compose_path.parent / ".env"
    rel_env = env_path.relative_to(REPO_ROOT).as_posix()

    documentation_url = None
    if readme_path:
        documentation_url = raw_base + "/" + readme_path.relative_to(REPO_ROOT).as_posix()

    template = {
        "id": template_id,
        "name": name,
        "description": description,
        "version": "1.0.0",
        "author": "ScaleTail",
        "compose_url": raw_base + "/" + rel_compose,
        "env_url": raw_base + "/" + rel_env,
        "documentation_url": documentation_url or raw_base + "/" + rel_compose,
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
        templates.append(build_template(compose_path, repo, ref))

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
