#!/usr/bin/env bash
# Every stack in services/ needs one row in the root README.md, every row
# links to a stack that exists, and the rows of each category stay in
# alphabetical order of the bold name, ignoring case (AGENTS.md, "Files that
# change together"). Every stack has compose.yaml, .env, and README.md, and the
# README uses the headings of the template in order (CONTRIBUTING.md, "Complete
# the service README"). Run it from the repository root.
set -euo pipefail

status=0
heading_order='At a glance\|Before you start\|Deviations from the standard setup\|First run(\|Configuration)?(\|Troubleshooting)?(\|Upgrading)?\|Links'
for dir in services/*/; do
  name=${dir#services/}
  name=${name%/}
  if ! grep -qE "\]\(/?services/${name}/?\)" README.md; then
    echo "::error file=README.md::services/${name} has no row in README.md"
    status=1
  fi
  for file in compose.yaml .env README.md; do
    if [ ! -f "${dir}${file}" ]; then
      echo "::error file=${dir}${file}::services/${name} has no ${file}"
      status=1
    fi
  done
  if [ -f "${dir}README.md" ]; then
    headings=$(awk '/^```/ { fence = !fence } !fence && /^## / { sub(/^## /, ""); print }' "${dir}README.md" | paste -sd '|' -)
    if ! grep -qxE "$heading_order" <<<"$headings"; then
      echo "::error file=${dir}README.md::The level-two headings must be those of templates/service-template/README.md, in order, with only Configuration, Troubleshooting, and Upgrading added before Links. Found: ${headings//|/, }"
      status=1
    fi
  fi
done

links=$(grep -oE '\]\(/?services/[^)/]+/?\)' README.md | sed -E 's#^\]\(/?services/##; s#/?\)$##')
while IFS= read -r name; do
  if [ ! -d "services/${name}" ]; then
    echo "::error file=README.md::README.md has a row for services/${name}, which does not exist"
    status=1
  fi
done < <(sort -u <<<"$links")
while IFS= read -r name; do
  echo "::error file=README.md::services/${name} has more than one row in README.md"
  status=1
done < <(sort <<<"$links" | uniq -d)

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
