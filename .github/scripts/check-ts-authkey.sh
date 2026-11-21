#!/usr/bin/env bash
# TS_AUTHKEY stays empty in every .env (AGENTS.md, "Secrets and local data").
# GitHub secret scanning looks for known key formats. This check also rejects
# placeholders and other values. The errors name the file and line, never the
# value. Run it from the repository root.
set -euo pipefail

status=0
while IFS=: read -r file line _; do
  echo "::error file=${file},line=${line}::TS_AUTHKEY has a value. Leave it empty, and revoke the key if it is real."
  status=1
done < <(git grep -nIE -e '^[[:space:]]*TS_AUTHKEY=[[:space:]]*[^[:space:]]' -- '*.env' || true)

exit "$status"
