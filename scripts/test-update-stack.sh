#!/usr/bin/env bash
# Self-test for update-stack.sh. It builds a fake ScaleTail repository, a clone
# of it and copied stacks in a temporary folder, and never uses the history of
# the real repository. Run it with: bash scripts/test-update-stack.sh
set -uo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
SCRIPT_SRC=$HERE/update-stack.sh
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/test-update-stack.XXXXXX")
trap 'rm -rf "$ROOT"' EXIT

# Keep the git configuration of the person who runs the test out of the fixtures.
export HOME=$ROOT/home
export GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=Test GIT_AUTHOR_EMAIL=test@example.invalid
export GIT_COMMITTER_NAME=Test GIT_COMMITTER_EMAIL=test@example.invalid
mkdir -p "$HOME"
git config --global commit.gpgsign false
git config --global protocol.file.allow always

SECRET=SENTINEL-secret-value-4711
SECRET2=SENTINEL-port-value-9999

FAILS=0
TOTAL=0
CASE_FAILS=0

fail() {
  CASE_FAILS=$((CASE_FAILS + 1))
  printf '      FAILED: %s\n' "$*"
}

assert_eq() { [ "$1" = "$2" ] || fail "$3 (expected '$2', got '$1')"; }
assert_contains() { grep -qF -- "$2" <<<"$1" || fail "$3 (output lacks '$2')"; }
assert_not_contains() { ! grep -qF -- "$2" <<<"$1" || fail "$3 (output contains '$2')"; }
assert_file_has() { grep -qF -- "$2" "$1" 2>/dev/null || fail "$3 ($1 lacks '$2')"; }
assert_file_lacks() { ! grep -qF -- "$2" "$1" 2>/dev/null || fail "$3 ($1 contains '$2')"; }
assert_same() { cmp -s "$1" "$2" || fail "$3 ($1 differs from $2)"; }
assert_missing() { [ ! -e "$1" ] || fail "$2 ($1 exists)"; }
assert_exists() { [ -e "$1" ] || fail "$2 ($1 is missing)"; }

# Print a checksum of every file in a folder, for before/after comparisons.
snapshot() {
  (cd "$1" && find . -type f | LC_ALL=C sort | while IFS= read -r f; do
    printf '%s ' "$f"
    cksum <"$f"
  done)
}

backup_dirs() { find "$1" -maxdepth 1 -name '.scaletail-backup-*' | wc -l | tr -d ' '; }

# Run the script from the clone. Sets OUT and RC.
run() {
  RC=0
  OUT=$(bash "$CLONE/scripts/update-stack.sh" "$@" 2>&1) || RC=$?
}

commit_all() {
  git -C "$WORK" add -A
  git -C "$WORK" commit -q -m "$1"
  git -C "$WORK" push -q origin main
}

# Create origin, the working repository, a clone and an unedited copy of
# services/demo at the first version.
new_world() {
  WORLD=$(mktemp -d "$ROOT/world.XXXXXX")
  ORIGIN=$WORLD/origin.git
  WORK=$WORLD/work
  CLONE=$WORLD/clone
  COPY=$WORLD/stacks/demo
  git init -q --bare "$ORIGIN"
  git -C "$ORIGIN" symbolic-ref HEAD refs/heads/main
  git init -q "$WORK"
  git -C "$WORK" symbolic-ref HEAD refs/heads/main
  git -C "$WORK" remote add origin "$ORIGIN"
  mkdir -p "$WORK/scripts" "$WORK/services/demo"
  cp "$SCRIPT_SRC" "$WORK/scripts/update-stack.sh"
  chmod +x "$WORK/scripts/update-stack.sh"
  cat >"$WORK/services/demo/compose.yaml" <<'YAML'
services:
  tailscale:
    image: tailscale/tailscale:v1
    hostname: ${SERVICE}
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY}
      - TZ=${TZ}
  application:
    image: ${IMAGE_URL}:1
    network_mode: service:tailscale
    environment:
      - PORT=${APP_PORT}
      - COLOR=${APP_COLOR}
YAML
  cat >"$WORK/services/demo/.env" <<'ENV'
SERVICE=demo
IMAGE_URL=example/demo
TS_AUTHKEY=
TZ=Europe/Amsterdam

# Application
APP_PORT=8080
APP_NAME=demo
APP_COLOR=blue
APP_MODE=fast
ENV
  printf '# Demo\n\n## At a glance\n\nA demo stack.\n' >"$WORK/services/demo/README.md"
  printf 'old\n' >"$WORK/services/demo/old.conf"
  commit_all "v1"
  git clone -q "$ORIGIN" "$CLONE"
  mkdir -p "$WORLD/stacks"
  cp -R "$CLONE/services/demo" "$COPY"
  mkdir -p "$COPY/ts/state" "$COPY/demo-data"
  printf 'device-key\n' >"$COPY/ts/state/key"
  printf 'data\n' >"$COPY/demo-data/file"
}

# The upstream change that most cases use: a new image tag in compose.yaml, a
# new default and a new variable in .env, a new file and a deleted file.
upstream_v2() {
  local f=$WORK/services/demo
  sed 's/tailscale:v1/tailscale:v2/; s/demo:1$/demo:2/' "$f/compose.yaml" >"$f/c.tmp" && mv "$f/c.tmp" "$f/compose.yaml"
  sed 's/^APP_PORT=8080/APP_PORT=9090/' "$f/.env" >"$f/e.tmp" && mv "$f/e.tmp" "$f/.env"
  printf '\n# Required: the log level. Pick one of debug or info.\nAPP_LOG_LEVEL=info\n' >>"$f/.env"
  printf '\n## Upgrading\n\nSet APP_LOG_LEVEL in .env before you restart.\n' >>"$f/README.md"
  printf 'new\n' >"$f/extra.conf"
  git -C "$WORK" rm -q "services/demo/old.conf"
  commit_all "v2"
  git -C "$CLONE" fetch -q origin
}

head_sha() { git -C "$ORIGIN" rev-parse main; }

# Case: nothing is edited, so a check reports and writes nothing, --apply updates.
case_unchanged_copy() {
  new_world
  upstream_v2
  local before after
  before=$(snapshot "$COPY")
  run "$COPY"
  assert_eq "$RC" 1 "check mode exits 1 when updates exist"
  assert_contains "$OUT" "updates available" "check mode reports updates"
  after=$(snapshot "$COPY")
  assert_eq "$after" "$before" "check mode writes nothing"
  assert_eq "$(backup_dirs "$COPY")" 0 "check mode makes no backup"

  run --apply "$COPY"
  assert_eq "$RC" 0 "--apply exits 0"
  assert_contains "$OUT" "status: updated" "--apply reports the update"
  assert_contains "$OUT" "Upgrading" "the changed Upgrading section is printed"
  assert_contains "$OUT" "Set APP_LOG_LEVEL" "the text of the Upgrading section is printed"
  assert_same "$COPY/compose.yaml" "$WORK/services/demo/compose.yaml" "compose.yaml is upstream"
  assert_same "$COPY/.env" "$WORK/services/demo/.env" ".env is upstream"
  assert_same "$COPY/extra.conf" "$WORK/services/demo/extra.conf" "a new upstream file is added"
  assert_exists "$COPY/old.conf" "a file deleted upstream is not deleted"
  assert_contains "$OUT" "old.conf" "a file deleted upstream is reported"
  assert_file_has "$COPY/.scaletail" "service=demo" "marker names the service"
  assert_file_has "$COPY/.scaletail" "commit=$(head_sha)" "marker records the commit"
  assert_eq "$(backup_dirs "$COPY")" 1 "one backup folder"
  assert_file_has "$(find "$COPY" -maxdepth 2 -path '*scaletail-backup*' -name compose.yaml)" "tailscale:v1" "backup holds the old compose.yaml"
  assert_eq "$(cat "$COPY/ts/state/key")" "device-key" "ts/state is untouched"
  assert_eq "$(cat "$COPY/demo-data/file")" "data" "the data folder is untouched"
  assert_contains "$OUT" "docker compose pull" "the next step is printed"
  assert_eq "$(git -C "$CLONE" status --porcelain)" "" "the clone's working tree is untouched"
  assert_eq "$(git -C "$CLONE" rev-parse HEAD)" "$(git -C "$WORK" rev-parse HEAD~1)" "the clone is not pulled"

  run "$COPY"
  assert_eq "$RC" 0 "a second check exits 0"
  assert_contains "$OUT" "up to date" "a second check says up to date"
  assert_eq "$(snapshot "$COPY")" "$(snapshot "$COPY")" "stable"
}

# Case: edits to .env survive an upstream change to other lines.
case_env_edit_survives() {
  new_world
  sed "s/^TS_AUTHKEY=.*/TS_AUTHKEY=$SECRET/; s/^APP_COLOR=.*/APP_COLOR=red/" "$COPY/.env" >"$COPY/e.tmp" && mv "$COPY/e.tmp" "$COPY/.env"
  upstream_v2
  run --apply "$COPY"
  assert_eq "$RC" 0 "--apply exits 0"
  assert_file_has "$COPY/.env" "TS_AUTHKEY=$SECRET" "the auth key stays"
  assert_file_has "$COPY/.env" "APP_COLOR=red" "the edited value stays"
  assert_file_has "$COPY/.env" "APP_PORT=9090" "the upstream default is applied"
  assert_file_has "$COPY/.env" "APP_LOG_LEVEL=info" "the new variable is added"
  assert_same "$COPY/compose.yaml" "$WORK/services/demo/compose.yaml" "compose.yaml is upstream"
  assert_contains "$OUT" "APP_LOG_LEVEL" "the new variable is named"
  assert_contains "$OUT" "APP_PORT" "the changed default is named"
}

# Case: a base from the marker lets an edited compose.yaml merge.
case_marker_merge() {
  new_world
  upstream_v2
  run --apply "$COPY"
  # The user edits one line, upstream changes another.
  sed 's/network_mode: service:tailscale/network_mode: service:tailscale # mine/' "$COPY/compose.yaml" >"$COPY/c.tmp" && mv "$COPY/c.tmp" "$COPY/compose.yaml"
  sed 's/tailscale:v2/tailscale:v3/' "$WORK/services/demo/compose.yaml" >"$WORK/c.tmp" && mv "$WORK/c.tmp" "$WORK/services/demo/compose.yaml"
  commit_all "v3"
  run "$COPY"
  assert_eq "$RC" 1 "check exits 1"
  assert_contains "$OUT" "marker .scaletail" "the base comes from the marker"
  assert_contains "$OUT" "merge" "check reports a merge"
  run --apply "$COPY"
  assert_eq "$RC" 0 "--apply exits 0"
  assert_file_has "$COPY/compose.yaml" "tailscale:v3" "the upstream change is merged"
  assert_file_has "$COPY/compose.yaml" "service:tailscale # mine" "the edit stays"
  assert_file_lacks "$COPY/compose.yaml" "<<<<<<<" "no conflict markers"
}

# Case: the user and upstream change the same line.
case_conflict() {
  new_world
  sed 's/tailscale:v1/tailscale:custom/' "$COPY/compose.yaml" >"$COPY/c.tmp" && mv "$COPY/c.tmp" "$COPY/compose.yaml"
  # The blob of compose.yaml no longer matches, so give the base explicitly.
  local v1
  v1=$(git -C "$CLONE" rev-parse HEAD)
  upstream_v2
  cp "$COPY/compose.yaml" "$ROOT/mine.yaml"
  local before
  before=$(snapshot "$COPY")
  run --base "$v1" "$COPY"
  assert_eq "$RC" 1 "check exits 1"
  assert_contains "$OUT" "status: conflict" "check reports the conflict"
  assert_eq "$(snapshot "$COPY")" "$before" "check mode writes nothing, not even the merge file"
  assert_missing "$COPY/.scaletail" "check mode writes no marker"
  assert_eq "$(backup_dirs "$COPY")" 0 "check mode makes no backup"

  run --apply --base "$v1" "$COPY"
  assert_eq "$RC" 1 "--apply exits 1 with a conflict"
  assert_same "$COPY/compose.yaml" "$ROOT/mine.yaml" "the live file is untouched"
  assert_file_lacks "$COPY/compose.yaml" "<<<<<<<" "no markers in the live file"
  assert_exists "$COPY/compose.yaml.upstream-merge" "the merge file is written"
  assert_file_has "$COPY/compose.yaml.upstream-merge" "<<<<<<<" "the merge file has markers"
  assert_file_lacks "$COPY/compose.yaml.upstream-merge" "|||||||" "the merge file is not diff3"
  assert_missing "$COPY/.scaletail" "no marker after a conflict"
  assert_same "$COPY/.env" "$WORK/services/demo/.env" "the clean files are still updated"
  assert_contains "$OUT" "--base" "the way out is printed"

  # The way out: merge by hand, then record the update.
  cp "$WORK/services/demo/compose.yaml" "$COPY/compose.yaml"
  rm "$COPY/compose.yaml.upstream-merge"
  run --apply --base "$(head_sha)" "$COPY"
  assert_eq "$RC" 0 "after merging by hand the update is recorded"
  assert_file_has "$COPY/.scaletail" "commit=$(head_sha)" "marker records the commit"
}

case_inside_clone() {
  new_world
  upstream_v2
  run "$CLONE/services/demo"
  assert_eq "$RC" 2 "a folder inside the clone is refused"
  assert_contains "$OUT" "inside the clone" "the reason is given"
  assert_contains "$OUT" "git pull" "git pull is suggested"
  run "$COPY" "$CLONE/services/demo"
  assert_eq "$RC" 2 "one bad folder refuses the whole run"
  run --service demo "$COPY" "$COPY"
  assert_eq "$RC" 2 "--service needs one folder"
}

# Case: the copy was made at v1 and compose.yaml was edited, with no marker.
case_no_base() {
  new_world
  printf '# my note\n' >>"$COPY/compose.yaml"
  printf 'MY_EXTRA=%s\n' "$SECRET" >>"$COPY/.env"
  upstream_v2
  cp "$COPY/compose.yaml" "$ROOT/mine.yaml"
  local before
  before=$(snapshot "$COPY")
  run "$COPY"
  assert_eq "$RC" 1 "check exits 1"
  assert_contains "$OUT" "base:   none" "no base is reported"
  assert_contains "$OUT" "differs   compose.yaml" "compose.yaml is reported as different"
  assert_contains "$OUT" "tailscale:v2" "the diff of compose.yaml is shown in check mode"
  assert_eq "$(snapshot "$COPY")" "$before" "check mode writes nothing"

  run --apply "$COPY"
  assert_eq "$RC" 1 "--apply exits 1: compose.yaml is not replaced"
  assert_same "$COPY/compose.yaml" "$ROOT/mine.yaml" "compose.yaml is not replaced without --force"
  assert_file_has "$COPY/.env" "APP_LOG_LEVEL=info" "the new variable is appended"
  assert_file_has "$COPY/.env" "# Required: the log level" "its comment comes with it"
  assert_file_has "$COPY/.env" "MY_EXTRA=$SECRET" "your variable stays"
  assert_file_has "$COPY/.env" "APP_PORT=8080" "existing variables are not changed"
  assert_contains "$OUT" "MY_EXTRA" "a variable that only you have is listed"
  assert_missing "$COPY/.scaletail" "no marker while files differ"
  assert_same "$COPY/extra.conf" "$WORK/services/demo/extra.conf" "a new file is added"

  run --apply --force "$COPY"
  assert_eq "$RC" 0 "--force --apply exits 0"
  assert_same "$COPY/compose.yaml" "$WORK/services/demo/compose.yaml" "--force replaces compose.yaml"
  assert_file_has "$COPY/.env" "MY_EXTRA=$SECRET" ".env is never replaced"
  assert_eq "$(backup_dirs "$COPY")" 2 "a second apply makes a second backup folder"
  assert_same "$(find "$COPY" -maxdepth 2 -path '*scaletail-backup*' -name compose.yaml | LC_ALL=C sort | head -n 1)" "$ROOT/mine.yaml" "the backup holds your compose.yaml"
}

# Case: a shallow clone has no history, so there is no base. No crash.
case_shallow() {
  new_world
  upstream_v2
  git clone -q --depth 1 "file://$ORIGIN" "$WORLD/shallow"
  CLONE=$WORLD/shallow
  assert_eq "$(git -C "$CLONE" rev-parse --is-shallow-repository)" true "the fixture is shallow"
  printf 'service=demo\ncommit=%s\n' "$(git -C "$WORK" rev-list --max-parents=0 HEAD)" >"$COPY/.scaletail"
  run "$COPY"
  assert_eq "$RC" 1 "check exits 1"
  assert_contains "$OUT" "base:   none" "no base without history"
  assert_contains "$OUT" "is not in the clone" "the marker commit is reported as missing"
  assert_not_contains "$OUT" "fatal" "no git error leaks through"
  assert_not_contains "$OUT" "unexpected error" "no crash"
  run --apply "$COPY"
  assert_eq "$RC" 1 "--apply exits 1"
  assert_file_has "$COPY/.env" "APP_LOG_LEVEL=info" "the new variable is appended"
  run --no-fetch "$COPY"
  assert_not_contains "$OUT" "unexpected error" "no crash with --no-fetch"
  # The copy without a marker.
  rm "$COPY/.scaletail"
  run --no-fetch --ref origin/main "$COPY"
  assert_eq "$RC" 1 "check exits 1 without a marker"
  assert_not_contains "$OUT" "unexpected error" "no crash without a marker"
}

# Case: no value of .env may appear in the output.
case_no_secrets() {
  new_world
  # The edited line 5 is not a valid variable: docker compose quotes such a line
  # in its error message, and the script must not pass that on.
  edit_env() {
    sed "s/^TS_AUTHKEY=.*/TS_AUTHKEY=$SECRET/; s/^APP_PORT=.*/APP_PORT=$SECRET2/" "$1" |
      awk -v s="$SECRET" 'NR == 5 { print "BAD NAME=" s } { print }'
  }
  edit_env "$COPY/.env" >"$COPY/e.tmp" && mv "$COPY/e.tmp" "$COPY/.env"
  edit_env "$CLONE/services/demo/.env" >"$ROOT/env.expected"
  upstream_v2
  local all=""
  run "$COPY"
  all="$OUT"
  assert_eq "$RC" 1 "check exits 1"
  assert_contains "$OUT" "conflict" "the .env conflict is reported"
  assert_contains "$OUT" "APP_LOG_LEVEL" "names are shown"
  run --apply "$COPY"
  all="$all$OUT"
  assert_exists "$COPY/.env.upstream-merge" "the .env merge file is written"
  assert_same "$COPY/.env" "$ROOT/env.expected" ".env stays as it was"
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    assert_contains "$OUT" "docker compose config FAILED" "the compose check ran and failed on the bad line"
  else
    printf '      (docker compose not found: the compose check part is skipped)\n'
  fi
  # No base: a different copy, with compose.yaml edited.
  rm -f "$COPY/.env.upstream-merge"
  printf '# note\n' >>"$COPY/compose.yaml"
  rm -rf "$COPY"/.scaletail*
  run "$COPY"
  all="$all$OUT"
  run --apply "$COPY"
  all="$all$OUT"
  run --apply --force "$COPY"
  all="$all$OUT"
  assert_not_contains "$all" "$SECRET" "no .env value is printed"
  assert_not_contains "$all" "$SECRET2" "no .env value is printed (conflict)"
  assert_not_contains "$all" "tskey" "no key is printed"
  assert_not_contains "$all" "validating" "docker's own messages are not passed on"
}

# Case: a changed SERVICE is reported and the stack is skipped.
case_service_change() {
  new_world
  sed 's/^SERVICE=demo/SERVICE=demo2/' "$WORK/services/demo/.env" >"$WORK/e.tmp" && mv "$WORK/e.tmp" "$WORK/services/demo/.env"
  upstream_v2
  local before
  before=$(snapshot "$COPY")
  run --apply "$COPY"
  assert_eq "$RC" 1 "the stack is skipped"
  assert_contains "$OUT" "SERVICE changes upstream" "the change is reported"
  assert_contains "$OUT" "status: skipped" "the status is skipped"
  assert_eq "$(snapshot "$COPY")" "$before" "nothing is written"
  run --apply --force "$COPY"
  assert_eq "$RC" 0 "--force applies it"
  assert_file_has "$COPY/.env" "SERVICE=demo2" "the new SERVICE is applied"
}

# Case: the folder name differs from the service name.
case_service_option() {
  new_world
  upstream_v2
  mv "$COPY" "$WORLD/stacks/mydemo"
  run "$WORLD/stacks/mydemo"
  assert_eq "$RC" 1 "an unknown service is a skip"
  assert_contains "$OUT" "not found upstream" "the reason is given"
  run --service demo "$WORLD/stacks/mydemo"
  assert_eq "$RC" 1 "--service finds the service"
  assert_contains "$OUT" "updates available" "updates are found"
  run --apply --service demo "$WORLD/stacks/mydemo"
  assert_eq "$RC" 0 "--apply works"
  run "$WORLD/stacks/mydemo"
  assert_eq "$RC" 0 "the marker remembers the service"
}

run_case() {
  TOTAL=$((TOTAL + 1))
  CASE_FAILS=0
  "$1"
  if [ "$CASE_FAILS" -eq 0 ]; then
    printf 'PASS  %s\n' "$2"
  else
    printf 'FAIL  %s\n' "$2"
    FAILS=$((FAILS + 1))
  fi
}

run_case case_unchanged_copy "unchanged copy: check writes nothing, --apply updates"
run_case case_env_edit_survives "edited .env survives an upstream change"
run_case case_marker_merge "marker base merges an edited compose.yaml"
run_case case_conflict "conflict leaves the live file and writes .upstream-merge"
run_case case_inside_clone "a folder inside the clone is refused"
run_case case_no_base "no base: .env appended, compose.yaml kept without --force"
run_case case_shallow "shallow clone falls back without a crash"
run_case case_no_secrets ".env values never appear in the output"
run_case case_service_change "a changed SERVICE is skipped without --force"
run_case case_service_option "--service and the marker"

printf '\n%s of %s cases failed\n' "$FAILS" "$TOTAL"
[ "$FAILS" -eq 0 ]
