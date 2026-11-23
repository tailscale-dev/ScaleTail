#!/usr/bin/env bash
# A container that shares the network of another service, such as the
# Tailscale sidecar, depends on that service with restart: true, and the
# service has a health check. The application waits until it is healthy
# (CONTRIBUTING.md, "Adapt compose.yaml"). Run it from the repository root.
set -euo pipefail

status=0
for dir in services/*/ templates/service-template/; do
  vars=$(grep -ohE '\$\{[A-Za-z0-9_]+:\?' "${dir}compose.yaml" "${dir}.env" | sed -E 's/^\$\{//; s/:\?$/=dummy/' | sort -u || true)
  if [ "$dir" = templates/service-template/ ]; then
    vars+=" SERVICE=dummy IMAGE_URL=dummy"
  fi
  # shellcheck disable=SC2086 # one word per variable
  if ! json=$(cd "$dir" && env $vars docker compose config --format json 2>/dev/null); then
    echo "::warning file=${dir}compose.yaml::Not checked, because docker compose config fails. The step \"Run docker compose config\" shows why."
    continue
  fi
  while IFS= read -r message; do
    echo "::error file=${dir}compose.yaml::${message}"
    status=1
  done < <(jq -r '
    .services as $s
    | $s | to_entries[] | .key as $name | .value as $svc
    | ($svc.network_mode // "") | select(startswith("service:")) | ltrimstr("service:") as $x
    | ($svc.depends_on[$x] // {}) as $dep
    | ($s[$x].healthcheck // {disable: true}) as $hc
    | (if $hc.disable == true or $hc.test[0] == "NONE"
        then "\($x) has no health check, but \($name) uses its network. Keep the health check of \($x)." else empty end),
      (if $dep.restart != true
        then "\($name) uses the network of \($x). Add depends_on: \($x): restart: true to \($name)." else empty end),
      (if $name == "application" and $dep.condition != "service_healthy"
        then "application uses the network of \($x). Add depends_on: \($x): condition: service_healthy to application." else empty end)
  ' <<<"$json")
done

exit "$status"
