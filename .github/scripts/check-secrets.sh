#!/usr/bin/env bash
# No tracked file may hold a Tailscale key or a private key, and TS_AUTHKEY
# stays empty in every .env (AGENTS.md, "Secrets and local data"). The errors
# name the file, line, and rule, never the value. Run it from the repository
# root.
set -euo pipefail

status=0
check() { # check RULE PATTERN PATHSPEC...
  local rule=$1 pattern=$2
  shift 2
  while IFS=: read -r file line _; do
    echo "::error file=${file},line=${line}::${rule}. Remove it, and revoke it if it is a real credential."
    status=1
  done < <(git grep -nIE -e "$pattern" -- "$@" || true)
}

check "Tailscale key" 'tskey-[a-z]+-[A-Za-z0-9]' .
check "Private key" '-----BEGIN ([A-Z0-9]+ )*PRIVATE KEY-----' .
check "Value for TS_AUTHKEY in .env" '^[[:space:]]*TS_AUTHKEY=[[:space:]]*[^[:space:]]' '*.env'

exit "$status"
