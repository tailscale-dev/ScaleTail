#!/usr/bin/env bash
# The fixtures contain Compose variables such as ${TZ} on purpose.
# shellcheck disable=SC2016
# Self-test for update-stack.sh. It serves a fake ScaleTail archive from a
# temporary folder, so it needs no network. Run it with:
#   bash scripts/test-update-stack.sh
set -uo pipefail

SCRIPT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/update-stack.sh
ROOT=$(mktemp -d)
trap 'rm -rf "$ROOT"' EXIT
export SCALETAIL_URL=file://$ROOT/repo.tar.gz
SECRET=SENTINEL-secret-4711
FAILS=0

fail() {
  FAILS=$((FAILS + 1))
  printf '  FAILED: %s\n' "$*"
}
check() { "$@" || fail "$*"; }
has() { grep -qF -- "$2" "$1"; }

# Run the script in the folder $1. Sets OUT and RC.
run() {
  local dir=$1
  shift
  RC=0
  OUT=$(cd "$dir" && bash "$SCRIPT" "$@" 2>&1) || RC=$?
  if grep -qF "$SECRET" <<<"$OUT"; then fail "the output contains a value from .env"; fi
}

# Publish version $1 of services/demo as the upstream archive.
publish() {
  local d=$ROOT/repo/ScaleTail-main/services/demo
  rm -rf "$ROOT/repo"
  mkdir -p "$d"
  cat >"$d/compose.yaml" <<YAML
services:
  tailscale:
    image: tailscale/tailscale:latest
    container_name: tailscale-\${SERVICE}
  application:
    image: \${IMAGE_URL}
    container_name: app-\${SERVICE}
    environment:
      - TZ=\${TZ}$([ "$1" -lt 2 ] || printf '\n      - LOG_LEVEL=${LOG_LEVEL}')
    restart: always
YAML
  {
    printf 'SERVICE=%s\nIMAGE_URL=demo/demo:latest\n\n# Tailscale auth key.\nTS_AUTHKEY=\n\nTZ=Europe/Amsterdam\n' \
      "$([ "$1" -lt 3 ] && echo demo || echo demo2)"
    [ "$1" -lt 2 ] || printf '\n# Log level of the application.\nLOG_LEVEL=info\n'
  } >"$d/.env"
  printf '# Demo\n\n## Upgrading\n\nVersion %s notes.\n\n## Troubleshooting\n\nNone.\n' "$1" >"$d/README.md"
  tar -czf "$ROOT/repo.tar.gz" -C "$ROOT/repo" ScaleTail-main
}

# Copy the published version to a new stack folder. Sets STACK.
copy() {
  STACK=$ROOT/stacks/$1
  rm -rf "$STACK"
  mkdir -p "$ROOT/stacks"
  cp -R "$ROOT/repo/ScaleTail-main/services/demo" "$STACK"
  sed -i "s/^TS_AUTHKEY=.*/TS_AUTHKEY=$SECRET/" "$STACK/.env"
}

state() { find "$1" -type f -exec md5sum {} + | sort; }

case_() { printf '%s\n' "$*"; }

case_ "first run with current files: check writes nothing, --apply saves the upstream files"
publish 1
copy demo
before=$(state "$STACK")
run "$STACK"
check [ "$RC" -eq 0 ]
check [ "$before" = "$(state "$STACK")" ]
run "$STACK" --apply
check [ "$RC" -eq 0 ]
check cmp -s "$STACK/.scaletail/compose.yaml" "$STACK/compose.yaml"
check has "$STACK/.env" "$SECRET"
check [ -z "$(find "$STACK/.scaletail" -name 'backup-*')" ]

case_ "first run with an old copy: .env gets the new variable, compose.yaml is replaced"
publish 1
copy demo
publish 2
echo '# my note' >>"$STACK/compose.yaml"
run "$STACK"
check [ "$RC" -eq 1 ]
check has <(echo "$OUT") "added: LOG_LEVEL"
check has <(echo "$OUT") "Version 2 notes."
run "$STACK" --apply
check [ "$RC" -eq 0 ]
check has "$STACK/.env" "$SECRET"
check has "$STACK/.env" "# Log level of the application."
check cmp -s "$STACK/compose.yaml" "$ROOT/repo/ScaleTail-main/services/demo/compose.yaml"
check has "$STACK"/.scaletail/backup-*/compose.yaml "# my note"

case_ "with a saved copy: your edits and the upstream change are merged"
publish 1
copy demo
run "$STACK" --apply
sed -i 's/tailscale:latest/tailscale:stable/' "$STACK/compose.yaml"
publish 2
before=$(state "$STACK")
run "$STACK"
check [ "$RC" -eq 1 ]
check [ "$before" = "$(state "$STACK")" ]
run "$STACK" --apply
check [ "$RC" -eq 0 ]
check has "$STACK/compose.yaml" "tailscale:stable"
check has "$STACK/compose.yaml" "LOG_LEVEL"
check has "$STACK/.env" "$SECRET"
check has "$STACK/.env" "LOG_LEVEL=info"
run "$STACK"
check [ "$RC" -eq 0 ]
check has <(echo "$OUT") "up to date"

case_ "a conflict writes markers, keeps a backup, and blocks the next run"
publish 1
copy demo
run "$STACK" --apply
sed -i 's/- TZ=${TZ}/- TZ=UTC/' "$STACK/compose.yaml"
publish 2
run "$STACK" --apply
check [ "$RC" -eq 1 ]
check has <(echo "$OUT") "conflict"
check has "$STACK/compose.yaml" "<<<<<<<"
check has "$STACK"/.scaletail/backup-*/compose.yaml "TZ=UTC"
run "$STACK"
check [ "$RC" -eq 1 ]
check has <(echo "$OUT") "conflict markers"
sed -i '/^<<<<<<<\|^=======\|^>>>>>>>/d; /- TZ=\${TZ}/d' "$STACK/compose.yaml"
run "$STACK"
check [ "$RC" -eq 0 ]

case_ "a changed SERVICE needs --force"
publish 2
copy demo
run "$STACK" --apply
publish 3
run "$STACK" --apply
check [ "$RC" -eq 1 ]
check has <(echo "$OUT") "SERVICE changes upstream"
check has "$STACK/.env" "SERVICE=demo"
run "$STACK" --apply --force
check [ "$RC" -eq 0 ]
check has "$STACK/.env" "SERVICE=demo2"

case_ "the service name comes from the folder, or from --service"
publish 1
copy other
run "$STACK"
check [ "$RC" -eq 1 ]
check has <(echo "$OUT") "does not exist upstream"
run "$STACK" --service demo
check [ "$RC" -eq 0 ]

case_ "a folder without compose.yaml is an error"
run "$ROOT"
check [ "$RC" -eq 2 ]

if [ "$FAILS" -gt 0 ]; then
  printf '%s checks failed\n' "$FAILS"
  exit 1
fi
echo "All checks passed"
