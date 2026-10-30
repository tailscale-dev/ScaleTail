#!/usr/bin/env bash
# Compare stack folders that you copied out of ScaleTail with the latest version
# on GitHub, and update compose.yaml and .env without losing your changes.
# See --help. This script never starts, stops or restarts containers.
set -euo pipefail

PROG=$(basename "$0")
URL=${SCALETAIL_URL:-https://codeload.github.com/tailscale-dev/ScaleTail/tar.gz/refs/heads/main}
FILES="compose.yaml .env"
SNAP=.scaletail
APPLY=0
FORCE=0
SERVICE_OPT=""

usage() {
  cat <<USAGE
Usage: $PROG [--apply] [--force] [--service NAME] [DIR...]

Compare each stack folder DIR (default: the current folder) with the latest
version of its service in ScaleTail, and update compose.yaml and .env. Without
--apply the script only reports. It needs curl or wget, tar, and git.

Options:
  --apply         Write the changes. Each file that changes is first copied to
                  DIR/$SNAP/backup-<time>/.
  --force         Apply even when SERVICE changes upstream.
  --service NAME  The service name, when it differs from the folder name.
  -h, --help      Show this help.

How it works:
  --apply saves the upstream compose.yaml and .env in DIR/$SNAP/. The next run
  merges three versions with "git merge-file": your file, that saved copy, and
  the new upstream file. Upstream changes are added and your changes stay.
  When both changed the same lines, the file gets conflict markers (<<<<<<<)
  for you to resolve by hand.

  On the first run there is no saved copy, so the script cannot tell your
  changes from upstream changes. It then adds the variables that your .env
  lacks, and replaces compose.yaml with the upstream version. It shows the diff
  first, and --apply keeps your old compose.yaml in the backup: copy your own
  edits back once, and later runs merge them.

  The script never prints values from .env, only names of variables. It does
  print diffs of compose.yaml. It does not touch other files, such as the
  Tailscale state and the data folders.

Exit status: 0 up to date or updated, 1 updates available, a conflict, or a
stack was skipped, 2 error.

The archive comes from \$SCALETAIL_URL (default: the main branch on GitHub).
USAGE
}

die() {
  printf '%s: %s\n' "$PROG" "$*" >&2
  exit 2
}

dirs=()
while [ "$#" -gt 0 ]; do
  case $1 in
    -h | --help) usage; exit 0 ;;
    --apply) APPLY=1 ;;
    --force) FORCE=1 ;;
    --service) [ "$#" -gt 1 ] || die "--service needs a value"; SERVICE_OPT=$2; shift ;;
    --service=*) SERVICE_OPT=${1#--service=} ;;
    -*) die "unknown option: $1 (see --help)" ;;
    *) dirs+=("$1") ;;
  esac
  shift
done
[ "${#dirs[@]}" -gt 0 ] || dirs=(.)
[ -z "$SERVICE_OPT" ] || [ "${#dirs[@]}" -eq 1 ] || die "--service only works with one DIR"
for d in "${dirs[@]}"; do
  [ -f "$d/compose.yaml" ] || [ ! -f "$d/compose.yml" ] || die "$d has compose.yml: rename it to compose.yaml first, as upstream did"
  [ -f "$d/compose.yaml" ] || die "$d has no compose.yaml: it is not a stack folder"
done
command -v git >/dev/null || die "git is needed to merge files: install it"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# Download the repository once.
if command -v curl >/dev/null; then
  curl -fsSL "$URL" -o "$TMP/repo.tar.gz" || die "cannot download $URL"
elif command -v wget >/dev/null; then
  wget -qO "$TMP/repo.tar.gz" "$URL" || die "cannot download $URL"
else
  die "curl or wget is needed: install one"
fi
mkdir "$TMP/repo"
tar -xzf "$TMP/repo.tar.gz" -C "$TMP/repo" --strip-components=1 || die "cannot unpack $URL"
# GitHub archives record the commit. gzip stops early, so ignore its status.
COMMIT=$(gzip -dc "$TMP/repo.tar.gz" 2>/dev/null | git get-tar-commit-id) || true
printf 'Upstream: %s%s\n' "${COMMIT:+commit ${COMMIT:0:7} from }" "$URL"

# Print the names of the variables that a .env file sets.
env_names() { sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' "$1" | sort -u; }

# Print the names that are only in $1, then only in $2, as "added: ...; removed: ...".
env_changes() {
  local added removed
  added=$(comm -13 <(env_names "$1") <(env_names "$2") | paste -sd, - | sed 's/,/, /g')
  removed=$(comm -23 <(env_names "$1") <(env_names "$2") | paste -sd, - | sed 's/,/, /g')
  printf '%s%s%s' "${added:+added: $added}" "${added:+${removed:+; }}" "${removed:+removed upstream: $removed}"
}

# Copy .env file $1 to $3 and append the variables of $2 that $1 lacks, with
# the comment lines above them.
env_append() {
  cp "$1" "$3"
  [ -z "$(tail -c 1 "$3")" ] || echo >>"$3"
  local nm
  for nm in $(comm -13 <(env_names "$1") <(env_names "$2")); do
    grep -Eq "^#[[:space:]]*$nm=" "$1" && continue
    echo >>"$3"
    awk -v n="$nm" '/^#/ { b = b $0 "\n"; next } index($0, n "=") == 1 { printf "%s%s\n", b, $0; exit } { b = "" }' "$2" >>"$3"
  done
}

service_line() { grep '^SERVICE=' "$1" 2>/dev/null | tail -n 1; }

update_stack() {
  local dir=$1 name up w f mine base new rc status="up to date" changed=0 conflict=0 s backup=""
  name=${SERVICE_OPT:-$(basename "$(cd "$dir" && pwd -P)")}
  up=$TMP/repo/services/$name
  printf '\n== %s (service: %s)\n' "$dir" "$name"
  case $name in
    "" | . | .. | *[!A-Za-z0-9._-]*) up=/nonexistent ;;
  esac
  if [ ! -f "$up/compose.yaml" ]; then
    printf '  skipped: services/%s does not exist upstream. Use --service NAME if the folder has another name.\n' "$name"
    RC=1
    return
  fi
  for f in $FILES; do
    if [ -f "$dir/$f" ] && grep -qE '^(<<<<<<<|>>>>>>>)( |$)' "$dir/$f"; then
      printf '  skipped: %s has conflict markers. Resolve them first (backups are in %s/).\n' "$f" "$SNAP"
      RC=1
      return
    fi
  done

  # SERVICE names the Tailnet device, the containers and the data folders.
  if [ -f "$dir/$SNAP/.env" ] && [ "$(service_line "$dir/$SNAP/.env")" != "$(service_line "$up/.env")" ]; then
    printf '  !! SERVICE changes upstream: "%s" becomes "%s".\n' "$(service_line "$dir/$SNAP/.env")" "$(service_line "$up/.env")"
    printf '     That renames the Tailnet device, the containers and the data folders.\n'
    if [ "$FORCE" -eq 0 ]; then
      printf '  skipped: read the Upgrading section of the service README, then run again with --force.\n'
      RC=1
      return
    fi
  fi

  w=$(mktemp -d -p "$TMP")
  for f in $FILES; do
    [ -f "$up/$f" ] || continue
    mine=$dir/$f
    base=$dir/$SNAP/$f
    new=$w/$f
    if [ ! -f "$mine" ]; then
      cp "$up/$f" "$new"
      printf '  %-13s add\n' "$f"
    elif cmp -s "$mine" "$up/$f" || { [ -f "$base" ] && cmp -s "$base" "$up/$f"; }; then
      continue
    elif [ -f "$base" ]; then
      rc=0
      git merge-file -p -L "your copy" -L "last update" -L upstream "$mine" "$base" "$up/$f" >"$new" || rc=$?
      [ "$rc" -lt 128 ] || die "git merge-file failed on $dir/$f"
      if [ "$rc" -gt 0 ]; then
        conflict=1
        printf '  %-13s conflict (your edit and the upstream change overlap)\n' "$f"
      elif cmp -s "$mine" "$base"; then
        printf '  %-13s update\n' "$f"
      else
        printf '  %-13s merge    (your changes stay)\n' "$f"
      fi
    elif [ "$f" = .env ]; then
      env_append "$mine" "$up/$f" "$new"
      if cmp -s "$mine" "$new"; then
        rm "$new"
      else
        printf '  %-13s append\n' "$f"
      fi
    else
      cp "$up/$f" "$new"
      printf '  %-13s replace  (first update: your version goes to the backup, copy your edits back from there)\n' "$f"
      diff -u -L "your copy" -L upstream "$mine" "$up/$f" | sed 's/^/      /' || true
    fi
    if [ "$f" = .env ] && [ -f "$mine" ] && [ -f "$new" ]; then
      s=$(env_changes "$mine" "$new")
      [ -z "$s" ] || printf '                %s\n' "$s"
    fi
  done

  [ -z "$(ls -A "$w")" ] || changed=1
  if [ "$conflict" -eq 1 ]; then status=conflict
  elif [ "$changed" -eq 1 ] && [ "$APPLY" -eq 1 ]; then status=updated
  elif [ "$changed" -eq 1 ]; then status="updates available"
  fi
  printf '  status: %s\n' "$status"
  if [ "$changed" -eq 1 ] && [ -f "$up/README.md" ]; then
    # The section without its heading and without blank lines around it.
    awk '/^## / { p = ($0 == "## Upgrading"); next } !p { next }
      NF { if (s) for (; n; n--) print ""; s = 1; n = 0; print; next } { n++ }' "$up/README.md" >"$w.upgrading"
    if [ -s "$w.upgrading" ]; then
      printf '  Upgrading section of the README:\n'
      sed 's/^/     | /' "$w.upgrading"
    fi
  fi

  if [ "$conflict" -eq 1 ] || { [ "$APPLY" -eq 0 ] && [ "$changed" -eq 1 ]; }; then RC=1; fi
  if [ "$APPLY" -eq 0 ]; then
    if [ "$changed" -eq 1 ] || [ ! -d "$dir/$SNAP" ]; then
      printf '  Run with --apply to write the changes%s.\n' "$([ -d "$dir/$SNAP" ] || echo ' and save the upstream files')"
    fi
    return
  fi

  for f in $FILES; do
    [ -f "$w/$f" ] || continue
    if [ -f "$dir/$f" ]; then
      [ -n "$backup" ] || backup=$SNAP/backup-$(date +%Y%m%d-%H%M%S)
      mkdir -p "$dir/$backup"
      cp -p "$dir/$f" "$dir/$backup/$f"
    fi
    cat "$w/$f" >"$dir/$f"
  done
  mkdir -p "$dir/$SNAP"
  for f in $FILES; do
    [ ! -f "$up/$f" ] || cp "$up/$f" "$dir/$SNAP/$f"
  done
  printf '  saved:  the upstream files in %s/%s\n' "$SNAP" "${COMMIT:+ (commit ${COMMIT:0:7})}"
  [ -z "$backup" ] || printf '  backup: %s/\n' "$backup"

  if [ "$conflict" -eq 1 ]; then
    printf '  Next:   resolve the conflict markers (<<<<<<< to >>>>>>>) in the files above, then run\n'
    printf '          docker compose pull && docker compose up -d   (in %s)\n' "$dir"
    return
  fi
  if [ "$changed" -eq 1 ]; then
    # Docker can quote lines of .env in its errors, so print none of them.
    if ! command -v docker >/dev/null; then
      printf '  compose: not checked (docker not found)\n'
    elif (cd "$dir" && docker compose config --quiet) >/dev/null 2>&1; then
      printf '  compose: docker compose config is valid\n'
      printf '  Next:   docker compose pull && docker compose up -d   (in %s)\n' "$dir"
    else
      printf '  compose: docker compose config FAILED. Run it in %s to see why, for example a new required variable.\n' "$dir"
      RC=1
    fi
  fi
}

RC=0
for d in "${dirs[@]}"; do
  update_stack "$d"
done
exit "$RC"
