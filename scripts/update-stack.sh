#!/usr/bin/env bash
# Check stack folders that you copied out of a ScaleTail clone against the
# latest version in the repository, and update them without losing your edits.
# See --help. This script never starts, stops or restarts containers.
set -eEuo pipefail

PROG=$(basename "$0")
REF=origin/main
APPLY=0
FORCE=0
FETCH=1
SERVICE_OPT=""
BASE_OPT=""
MARKER=.scaletail
STACK_RC=0

usage() {
  cat <<USAGE
Usage: $PROG [OPTIONS] DIR...

Check stack folders that you copied out of a ScaleTail clone against the latest
version in the repository. By default the script only reports. With --apply it
updates the files and keeps your changes. It never starts or restarts containers.

Each DIR is a copy such as ~/stacks/<service>. The clone is the one that holds
this script. It is not changed: the script reads the upstream files with git
and only runs "git fetch". A DIR inside the clone is refused: use "git pull".

Options:
  --apply         Write the changes. Before it changes a file, the script
                  copies the file to a .scaletail-backup-<time> folder in DIR.
                  It then records the commit in DIR/$MARKER.
  --force         Replace files it cannot merge because no base version is
                  known, and apply a changed SERVICE. .env is never replaced.
  --ref REF       Upstream version to compare with (default: origin/main).
  --no-fetch      Do not run "git fetch" first.
  --service NAME  Service name, when the folder name differs from the name in
                  services/. Only valid with one DIR.
  --base COMMIT   The commit the copy was made from, when it is not known.
  -h, --help      Show this help.

How it works:
  Only files tracked under services/<name>/ are looked at. Other files in DIR,
  such as ts/ and the data folders, are never touched. A file that upstream
  deleted is reported, not deleted.

  The base version is the commit the copy was made from. The script takes it
  from DIR/$MARKER, then from --base, then from the newest commit whose
  compose.yaml is identical to the one in DIR. Without a base, .env only gets
  the variables it lacks, and other files that differ are replaced with --force.

  With a base, each file is merged with "git merge-file". A file that you did not
  change takes the upstream version. When your edit and the upstream change
  overlap, the live file stays as it is and the script writes the merge with
  conflict markers to <file>.upstream-merge (only with --apply).

  The script never prints values from .env, only the names of variables. It
  shows a diff for compose.yaml only. It stops and warns when SERVICE changes
  upstream and prints the "Upgrading" section of the README when that changed.

Exit status:
  0  every stack is up to date, or was updated with --apply without conflicts
  1  updates are available (check mode), or a stack has a conflict, was
     skipped or needs a look
  2  usage or runtime error
USAGE
}

die() {
  printf '%s: %s\n' "$PROG" "$*" >&2
  exit 2
}

# Arguments. The directories end up in "$@".
n=$#
while [ "$n" -gt 0 ]; do
  a=$1
  shift
  n=$((n - 1))
  case $a in
    -h | --help)
      usage
      exit 0
      ;;
    --apply) APPLY=1 ;;
    --force) FORCE=1 ;;
    --no-fetch) FETCH=0 ;;
    --ref | --service | --base)
      [ "$n" -gt 0 ] || die "$a needs a value"
      v=$1
      shift
      n=$((n - 1))
      case $a in
        --ref) REF=$v ;;
        --service) SERVICE_OPT=$v ;;
        --base) BASE_OPT=$v ;;
      esac
      ;;
    --ref=*) REF=${a#--ref=} ;;
    --service=*) SERVICE_OPT=${a#--service=} ;;
    --base=*) BASE_OPT=${a#--base=} ;;
    --) break ;;
    -*) die "unknown option: $a (see --help)" ;;
    *) set -- "$@" "$a" ;;
  esac
done
if [ "$#" -eq 0 ]; then
  usage >&2
  exit 2
fi
if [ -n "$SERVICE_OPT" ] && [ "$#" -gt 1 ]; then
  die "--service only works with one DIR"
fi

# Do not let the environment point git at another repository.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

# Find the clone from the location of this script.
src=${BASH_SOURCE[0]}
while [ -L "$src" ]; do
  t=$(readlink "$src")
  case $t in
    /*) src=$t ;;
    *) src=$(dirname "$src")/$t ;;
  esac
done
script_dir=$(cd "$(dirname "$src")" && pwd -P)
CLONE=$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null) ||
  die "$src is not inside a git clone of ScaleTail"
CLONE=$(cd "$CLONE" && pwd -P)

g() { git -C "$CLONE" "$@"; }

# An unexpected failure is a runtime error (2), not "updates available" (1).
trap 'printf "%s: unexpected error at line %s\n" "$PROG" "$LINENO" >&2; exit 2' ERR

# Check every DIR before anything runs.
for d in "$@"; do
  [ -d "$d" ] || die "$d is not a directory"
  abs=$(cd "$d" && pwd -P)
  case $abs in
    "$CLONE" | "$CLONE"/*)
      die "$d is inside the clone ($CLONE). Update the clone itself with: git pull"
      ;;
  esac
  if [ ! -f "$abs/compose.yaml" ] && [ ! -f "$abs/$MARKER" ]; then
    die "$d has no compose.yaml: it does not look like a copied stack folder"
  fi
done

# Fetch the upstream branch, then resolve REF.
if [ "$FETCH" -eq 1 ]; then
  remote=""
  branch=""
  case $REF in
    refs/remotes/*/*)
      rest=${REF#refs/remotes/}
      remote=${rest%%/*}
      branch=${rest#*/}
      ;;
    */*)
      remote=${REF%%/*}
      branch=${REF#*/}
      ;;
  esac
  if [ -n "$remote" ] && g config --get "remote.$remote.url" >/dev/null 2>&1; then
    if ! g fetch --quiet "$remote" "+refs/heads/$branch:refs/remotes/$remote/$branch" 2>/dev/null; then
      die "cannot fetch $branch from $remote. Check your connection, or use --no-fetch to compare with the commits you already have"
    fi
  fi
fi
REF_SHA=$(g rev-parse --verify --quiet "$REF^{commit}" 2>/dev/null) ||
  die "cannot find $REF in the clone. Check --ref, and run without --no-fetch"

BASE_OPT_SHA=""
if [ -n "$BASE_OPT" ]; then
  BASE_OPT_SHA=$(g rev-parse --verify --quiet "$BASE_OPT^{commit}" 2>/dev/null) ||
    die "cannot find commit $BASE_OPT in the clone. A shallow clone lacks old commits: run 'git fetch --unshallow' in the clone"
fi

TMP=$(mktemp -d "${TMPDIR:-/tmp}/update-stack.XXXXXX")
TMP=$(cd "$TMP" && pwd -P)
trap 'rm -rf "$TMP"' EXIT

short() { printf '%.7s' "$1"; }

# Print the names of the variables that a .env file defines, sorted.
env_names() {
  sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' "$1" | LC_ALL=C sort -u
}

# Print the last line that defines the variable.
env_line() {
  { grep "^$2=" "$1" || true; } | tail -n 1
}

# Print the value of a variable without quotes and trailing comment.
env_value() {
  awk -v k="$2" 'index($0, k "=") == 1 {
    v = substr($0, length(k) + 2)
    sub(/[ \t]+#.*$/, "", v); sub(/[ \t]+$/, "", v)
    gsub(/^["\047]|["\047]$/, "", v)
    print v
    exit
  }' "$1"
}

# Print the comment lines directly above a variable, then the variable.
env_block() {
  awk -v n="$2" '
    /^#/ { buf = buf $0 "\n"; next }
    index($0, n "=") == 1 { printf "%s%s\n", buf, $0; exit }
    { buf = "" }
  ' "$1"
}

# Join lines with ", ".
joinl() {
  awk 'NR > 1 { printf ", " } { printf "%s", $0 } END { print "" }'
}

# Print what changes between two .env files, as names only: never values.
env_summary() {
  local cur=$1 new=$2 added removed changed nm out="" cn nn
  cn=$TMP/env.cur
  nn=$TMP/env.new
  env_names "$cur" >"$cn"
  env_names "$new" >"$nn"
  added=$(LC_ALL=C comm -13 "$cn" "$nn" | joinl)
  removed=$(LC_ALL=C comm -23 "$cn" "$nn" | joinl)
  changed=""
  for nm in $(LC_ALL=C comm -12 "$cn" "$nn"); do
    if [ "$(env_line "$cur" "$nm")" != "$(env_line "$new" "$nm")" ]; then
      changed="$changed${changed:+, }$nm"
    fi
  done
  [ -z "$added" ] || out="added: $added"
  [ -z "$removed" ] || out="$out${out:+; }removed upstream: $removed"
  [ -z "$changed" ] || out="$out${out:+; }default changed upstream: $changed"
  printf '%s' "$out"
}

# Add the variables of $2 (upstream) that $1 (your copy) lacks, with the comment
# lines above them. Print the new file to $3. Return 1 when nothing is missing.
env_append() {
  local cur=$1 up=$2 out=$3 nm found=0 miss
  cp "$cur" "$out"
  for nm in $(env_names "$up"); do
    if grep -Eq "^#?[[:space:]]*$nm=" "$cur"; then
      continue
    fi
    if [ "$found" -eq 0 ]; then
      # The command substitution drops a final newline: output means there was none.
      if [ -n "$(tail -c 1 "$out")" ]; then
        printf '\n' >>"$out"
      fi
      found=1
    fi
    miss="$TMP/env.miss"
    env_block "$up" "$nm" >"$miss"
    printf '\n' >>"$out"
    cat "$miss" >>"$out"
  done
  [ "$found" -eq 1 ]
}

# Print the "Upgrading" section of a README, without its heading.
upgrading_section() {
  [ -f "$1" ] || return 0
  awk '/^## /{ p = ($0 == "## Upgrading"); next } p' "$1" |
    awk 'NF { if (blank) print ""; blank = 0; print; next } started { blank = 1 } { started = started }'
}

record() { printf '%s\t%s\n' "$1" "$2" >>"$W/actions"; }

# Work out what to do with one upstream file. $1 is the path inside the stack.
analyze_file() {
  local rel=$1 u b c out conf rc=0 have_b=0
  u=$W/u/$rel
  b=$W/b/$rel
  out=$W/out/$rel
  conf=$W/conf/$rel
  c=$ABS/$rel
  mkdir -p "$(dirname "$u")" "$(dirname "$b")" "$(dirname "$out")" "$(dirname "$conf")"
  g show "$REF_SHA:services/$NAME/$rel" >"$u" 2>/dev/null || die "cannot read services/$NAME/$rel at $REF"
  if [ -n "$BASE" ]; then
    if g show "$BASE:services/$NAME/$rel" >"$b" 2>/dev/null; then
      have_b=1
    else
      rm -f "$b"
    fi
  fi

  if [ ! -e "$c" ]; then
    if [ "$have_b" -eq 1 ]; then
      if ! cmp -s "$u" "$b"; then
        record removed-by-you "$rel"
      fi
    else
      cp "$u" "$out"
      record add "$rel"
    fi
    return 0
  fi
  if [ ! -f "$c" ]; then
    record differs "$rel"
    return 0
  fi
  if cmp -s "$c" "$u"; then
    return 0
  fi

  if [ "$have_b" -eq 1 ]; then
    if cmp -s "$c" "$b"; then
      cp "$u" "$out"
      record update "$rel"
      return 0
    fi
    if cmp -s "$u" "$b"; then
      return 0
    fi
    git -c merge.conflictStyle=merge merge-file -p \
      -L "your copy" -L "base" -L "upstream" "$c" "$b" "$u" >"$W/merge.tmp" 2>/dev/null || rc=$?
    if [ "$rc" -eq 0 ]; then
      if ! cmp -s "$W/merge.tmp" "$c"; then
        cp "$W/merge.tmp" "$out"
        record merge "$rel"
      fi
      return 0
    elif [ "$rc" -lt 128 ]; then
      cp "$W/merge.tmp" "$conf"
      record conflict "$rel"
      return 0
    fi
    # git cannot merge this file (binary, for example): treat it as having no base.
  fi

  if [ "$rel" = ".env" ]; then
    if env_append "$c" "$u" "$out"; then
      record env-append "$rel"
    fi
    env_names "$c" >"$W/names.c"
    env_names "$u" >"$W/names.u"
    LC_ALL=C comm -23 "$W/names.c" "$W/names.u" | joinl >"$W/env-only"
  elif [ "$FORCE" -eq 1 ]; then
    cp "$u" "$out"
    record replace "$rel"
  else
    record differs "$rel"
  fi
}

# Copy a file that is about to change into the backup folder.
backup_file() {
  local rel=$1
  if [ -z "$BACKUP" ]; then
    BACKUP=.scaletail-backup-$(date +%Y%m%d-%H%M%S)
    local i=1 base=$BACKUP
    while [ -e "$ABS/$BACKUP" ]; do
      i=$((i + 1))
      BACKUP=$base-$i
    done
    mkdir -p "$ABS/$BACKUP"
    if [ -f "$ABS/$MARKER" ]; then
      cp -p "$ABS/$MARKER" "$ABS/$BACKUP/$MARKER"
    fi
  fi
  mkdir -p "$(dirname "$ABS/$BACKUP/$rel")"
  cp -p "$ABS/$rel" "$ABS/$BACKUP/$rel"
}

write_file() {
  local rel=$1 src=$2
  mkdir -p "$(dirname "$ABS/$rel")"
  cat "$src" >"$ABS/$rel" || die "cannot write $D/$rel"
}

# Find the base version. Sets BASE and BASE_HOW.
detect_base() {
  BASE=""
  BASE_HOW=""
  BASE_NOTE=""
  local mk_commit="" sha mine c bl list
  if [ -f "$ABS/$MARKER" ]; then
    mk_commit=$(awk -F= '$1 == "commit" { print $2; exit }' "$ABS/$MARKER")
    case $mk_commit in
      *[!0-9a-f]* | "") mk_commit="" ;;
    esac
  fi
  if [ -n "$mk_commit" ]; then
    if sha=$(g rev-parse --verify --quiet "$mk_commit^{commit}" 2>/dev/null); then
      BASE=$sha
      BASE_HOW="marker $MARKER"
      return 0
    fi
    BASE_NOTE="The commit $(short "$mk_commit") in $MARKER is not in the clone (shallow clone?)."
  fi
  if [ -n "$BASE_OPT_SHA" ]; then
    BASE=$BASE_OPT_SHA
    BASE_HOW="--base"
    return 0
  fi
  if [ -f "$ABS/compose.yaml" ]; then
    mine=$(g hash-object --no-filters "$ABS/compose.yaml" 2>/dev/null) || mine=""
    if [ -n "$mine" ]; then
      list=$(g log --format=%H "$REF_SHA" -- "services/$NAME/compose.yaml" 2>/dev/null) || list=""
      for c in $list; do
        bl=$(g rev-parse --verify --quiet "$c:services/$NAME/compose.yaml" 2>/dev/null) || continue
        if [ "$bl" = "$mine" ]; then
          BASE=$c
          BASE_HOW="compose.yaml matches that commit"
          return 0
        fi
      done
    fi
  fi
  return 0
}

report_files() {
  local act rel s
  while IFS=$'\t' read -r act rel; do
    case $act in
      add) printf '  add       %s\n' "$rel" ;;
      update) printf '  update    %s\n' "$rel" ;;
      replace) printf '  replace   %s  (--force)\n' "$rel" ;;
      merge) printf '  merge     %s  (your changes stay)\n' "$rel" ;;
      env-append) printf '  append    %s\n' "$rel" ;;
      conflict) printf '  conflict  %s  (your edit and the upstream change overlap)\n' "$rel" ;;
      differs) printf '  differs   %s  (no base: cannot tell what you changed; --force replaces it)\n' "$rel" ;;
      removed-by-you) printf '  kept      %s  (you removed it; upstream changed it; not restored)\n' "$rel" ;;
    esac
    if [ "$rel" = ".env" ]; then
      case $act in
        update | merge | env-append)
          s=$(env_summary "$ABS/$rel" "$W/out/$rel")
          [ -z "$s" ] || printf '              %s\n' "$s"
          ;;
        conflict)
          env_names "$ABS/$rel" >"$W/names.c"
          env_names "$W/u/$rel" >"$W/names.u"
          s=$(LC_ALL=C comm -13 "$W/names.c" "$W/names.u" | joinl)
          [ -z "$s" ] || printf '              variables upstream has and yours lacks: %s\n' "$s"
          ;;
      esac
    fi
    if [ "$act" = differs ] && [ "$rel" = compose.yaml ] && [ "$APPLY" -eq 0 ]; then
      diff -u -L "your copy" -L "upstream" "$ABS/$rel" "$W/u/$rel" | sed -n '1,80p;81s/.*/  ... (diff cut)/p' | sed 's/^/      /' || true
    fi
  done <"$W/actions"
  s=$(cat "$W/env-only")
  if [ -n "$s" ]; then
    printf '  note      .env variables that upstream does not have: %s\n' "$s"
  fi
}

process_dir() {
  D=$1
  ABS=$(cd "$D" && pwd -P)
  local mk_service="" name_ok status="" act rel u_svc b_svc s did=0
  W=$TMP/stack
  rm -rf "$W"
  mkdir -p "$W"
  : >"$W/actions"
  : >"$W/env-only"
  BACKUP=""

  NAME=""
  if [ -f "$ABS/$MARKER" ]; then
    mk_service=$(awk -F= '$1 == "service" { print $2; exit }' "$ABS/$MARKER")
  fi
  if [ -n "$mk_service" ]; then
    NAME=$mk_service
  elif [ -n "$SERVICE_OPT" ]; then
    NAME=$SERVICE_OPT
  else
    NAME=$(basename "$ABS")
  fi
  printf '\n== %s (service: %s)\n' "$D" "$NAME"
  case $NAME in
    "" | . | .. | *[!A-Za-z0-9._-]*) name_ok=0 ;;
    *) name_ok=1 ;;
  esac
  if [ "$name_ok" -eq 0 ] || ! g rev-parse --verify --quiet "$REF_SHA:services/$NAME" >/dev/null 2>&1; then
    printf '  status: skipped\n  services/%s not found upstream (removed or renamed?).\n' "$NAME"
    printf '  If the folder name differs from the service name, pass --service NAME.\n'
    STACK_RC=1
    return 0
  fi

  detect_base
  if [ -n "$BASE" ]; then
    printf '  base:   %s (%s)\n' "$(short "$BASE")" "$BASE_HOW"
  else
    printf '  base:   none (the commit this copy was made from is unknown)\n'
    [ -z "$BASE_NOTE" ] || printf '          %s\n' "$BASE_NOTE"
  fi

  g ls-tree -r -z --name-only "$REF_SHA" -- "services/$NAME/" | tr '\0' '\n' >"$W/ulist"
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    analyze_file "${p#services/"$NAME"/}"
  done <"$W/ulist"

  # Files that upstream deleted since the base.
  : >"$W/gone"
  if [ -n "$BASE" ]; then
    g ls-tree -r -z --name-only "$BASE" -- "services/$NAME/" 2>/dev/null | tr '\0' '\n' >"$W/blist" || : >"$W/blist"
    while IFS= read -r p; do
      [ -n "$p" ] || continue
      rel=${p#services/"$NAME"/}
      if ! grep -qxF "services/$NAME/$rel" "$W/ulist" && [ -e "$ABS/$rel" ]; then
        printf '%s\n' "$rel" >>"$W/gone"
      fi
    done <"$W/blist"
  fi

  # SERVICE renames the device, the containers and the data folders.
  local svc_block=0
  if [ -n "$BASE" ] && [ -f "$W/u/.env" ] && [ -f "$W/b/.env" ]; then
    u_svc=$(env_value "$W/u/.env" SERVICE)
    b_svc=$(env_value "$W/b/.env" SERVICE)
    if [ "$u_svc" != "$b_svc" ]; then
      svc_block=1
    fi
  elif [ -z "$BASE" ] && [ -f "$W/u/.env" ] && [ -f "$ABS/.env" ]; then
    u_svc=$(env_value "$W/u/.env" SERVICE)
    if [ "$u_svc" != "$(env_value "$ABS/.env" SERVICE)" ]; then
      printf '  note:   SERVICE in your .env differs from upstream (%s). If you did not choose that, read the Upgrading section.\n' "${u_svc:-empty}"
    fi
  fi

  local n_apply=0 n_conf=0 n_diff=0 cc_bad=0 cc_rc cc_vars
  while IFS=$'\t' read -r act rel; do
    case $act in
      add | update | replace | merge | env-append) n_apply=$((n_apply + 1)) ;;
      conflict) n_conf=$((n_conf + 1)) ;;
      differs) n_diff=$((n_diff + 1)) ;;
    esac
  done <"$W/actions"

  if [ "$svc_block" -eq 1 ] && [ "$FORCE" -eq 0 ]; then
    status="skipped"
  elif [ "$n_conf" -gt 0 ]; then
    status="conflict"
  elif [ "$n_diff" -gt 0 ]; then
    status="differs"
  elif [ "$n_apply" -gt 0 ]; then
    if [ "$APPLY" -eq 1 ]; then status="updated"; else status="updates available"; fi
  else
    status="up to date"
  fi
  printf '  status: %s\n' "$status"

  if [ "$svc_block" -eq 1 ]; then
    printf '  !! SERVICE changes upstream from "%s" to "%s".\n' "$b_svc" "$u_svc"
    printf '     That renames the Tailnet device, the containers and the data folders.\n'
    if [ "$FORCE" -eq 0 ]; then
      printf '     Nothing was changed. Read the Upgrading section of the README, then use --force.\n'
    else
      printf '     --force is set: read the Upgrading section of the README before you restart.\n'
    fi
  fi

  if [ "$status" != "up to date" ]; then
    upgrading_section "$W/u/README.md" >"$W/up.u"
    upgrading_section "$W/b/README.md" >"$W/up.b"
    if [ -s "$W/up.u" ] && { [ -z "$BASE" ] || ! cmp -s "$W/up.u" "$W/up.b"; }; then
      if [ -n "$BASE" ]; then
        printf '  !! The Upgrading section of the README changed:\n'
      else
        printf '  !! The README has an Upgrading section (no base: it may not be new):\n'
      fi
      sed -n '1,40p' "$W/up.u" | sed 's/^/     | /'
    fi
  fi

  report_files
  while IFS= read -r rel; do
    [ -z "$rel" ] || printf '  gone      %s  (removed upstream; still in your copy, not deleted)\n' "$rel"
  done <"$W/gone"

  if [ "$status" = "skipped" ]; then
    STACK_RC=1
    return 0
  fi

  # Apply.
  if [ "$APPLY" -eq 1 ]; then
    while IFS=$'\t' read -r act rel; do
      case $act in
        add | update | replace | merge | env-append)
          if [ -e "$ABS/$rel" ]; then backup_file "$rel"; fi
          write_file "$rel" "$W/out/$rel"
          did=1
          ;;
        conflict)
          cp -p "$ABS/$rel" "$ABS/$rel.upstream-merge"
          cat "$W/conf/$rel" >"$ABS/$rel.upstream-merge"
          printf '  wrote     %s.upstream-merge\n' "$rel"
          ;;
      esac
    done <"$W/actions"
    [ -z "$BACKUP" ] || printf '  backup:   %s/ (files as they were before this run)\n' "$BACKUP"

    if [ "$status" = "updated" ] || [ "$status" = "up to date" ]; then
      if ! { [ -f "$ABS/$MARKER" ] && grep -qx "commit=$REF_SHA" "$ABS/$MARKER" &&
        grep -qx "service=$NAME" "$ABS/$MARKER"; }; then
        printf '# Written by update-stack.sh: the ScaleTail commit this folder was last updated to.\nservice=%s\ncommit=%s\n' \
          "$NAME" "$REF_SHA" >"$ABS/$MARKER"
        printf '  marker:   %s records commit %s\n' "$MARKER" "$(short "$REF_SHA")"
      fi
    fi

    if [ "$did" -eq 1 ]; then
      if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
        # Docker's messages can quote paths and lines of .env: print variable names only.
        cc_rc=0
        (cd "$ABS" && docker compose config --quiet) >"$W/cc.out" 2>&1 || cc_rc=$?
        {
          sed -n 's/.*required variable \([A-Za-z0-9_]*\) is missing.*/\1/p' "$W/cc.out"
          sed -n 's/.*The "\([A-Za-z0-9_]*\)" variable is not set.*/\1/p' "$W/cc.out"
        } | LC_ALL=C sort -u | joinl >"$W/cc.vars"
        cc_vars=$(cat "$W/cc.vars")
        if [ "$cc_rc" -ne 0 ]; then
          if [ -n "$cc_vars" ]; then
            printf '  compose:  docker compose config FAILED. Set in .env: %s\n' "$cc_vars"
          else
            printf '  compose:  docker compose config FAILED. Run it in that folder to see why.\n'
          fi
          cc_bad=1
        elif [ -n "$cc_vars" ]; then
          printf '  compose:  docker compose config warns. Not set in .env: %s\n' "$cc_vars"
          cc_bad=1
        else
          printf '  compose:  docker compose config is valid\n'
        fi
      else
        printf '  compose:  not checked (docker compose not found)\n'
      fi
    fi
  else
    case $status in
      conflict) printf '  Run with --apply to write the merge with conflict markers to <file>.upstream-merge.\n' ;;
    esac
  fi

  case $status in
    "updated")
      printf '  Next: read the Upgrading section of the README, then run in %s:\n' "$D"
      printf '        docker compose pull && docker compose up -d\n'
      printf '  (This script does not restart containers.)\n'
      ;;
    "conflict")
      if [ "$APPLY" -eq 1 ]; then
        printf '  Next: merge each conflict by hand with its .upstream-merge file and delete that file.\n'
        printf '        Then remove %s if it exists and run again: %s --apply --base %s %s\n' \
          "$MARKER" "$PROG" "$(printf '%.12s' "$REF_SHA")" "$D"
      fi
      ;;
    "differs")
      printf '  Next: compare the files yourself, or use --force to replace them (a backup is made with --apply).\n'
      ;;
  esac

  case $status in
    "up to date" | "updated") STACK_RC=$cc_bad ;;
    *) STACK_RC=1 ;;
  esac
}

printf 'Upstream: %s at %s\n' "$REF" "$(short "$REF_SHA")"
rc=0
for d in "$@"; do
  STACK_RC=0
  process_dir "$d"
  [ "$STACK_RC" -le "$rc" ] || rc=$STACK_RC
done
exit "$rc"
