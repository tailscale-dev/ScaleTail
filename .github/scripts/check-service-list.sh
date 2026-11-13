#!/usr/bin/env bash
# Every stack in services/ needs a row in the root README.md, and the rows of
# each category stay in alphabetical order of the bold name, ignoring case
# (AGENTS.md, "Files that change together"). Run it from the repository root.
set -euo pipefail

status=0
for dir in services/*/; do
  name=${dir#services/}
  name=${name%/}
  if ! grep -qE "\]\(/?services/${name}/?\)" README.md; then
    echo "::error file=README.md::services/${name} has no row in README.md"
    status=1
  fi
done

while IFS= read -r line; do
  echo "::error file=README.md::${line}"
  status=1
done < <(LC_ALL=C awk '
  /^#+ / { prev = "" }
  /^\| \*\*/ {
    n = $0; sub(/^\| \*\*/, "", n); sub(/\*\*.*/, "", n)
    l = tolower(n)
    if (prev != "" && l < prev) print "\"" n "\" is not in alphabetical order (after \"" prev "\")"
    prev = l
  }' README.md)

exit "$status"
