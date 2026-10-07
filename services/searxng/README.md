# SearXNG

[SearXNG](https://github.com/searxng/searxng) is a metasearch engine. It combines the results of many search engines and does not track or profile its users.

This stack runs SearXNG with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://searxng.<tailnet>.ts.net`          |
| Service port  | `8080`                                      |
| Images        | `docker.io/searxng/searxng`                 |
|               | `docker.io/valkey/valkey:8-alpine`          |
| Data          | `./searxng` (configuration, `settings.yml`) |
|               | Docker volume `valkey-data2` (Valkey data)  |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`. `compose.yaml` builds the base address `https://<SERVICE>.<TAILNET_NAME>.ts.net/` from it, which SearXNG uses for its links.
- **`SEARXNG_SECRET`.** A random value. Generate one with `openssl rand -hex 32`.

## Deviations from the standard setup

- **Settings file.** This directory contains `searxng/settings.yml`, a copy of the [default settings of SearXNG](https://github.com/searxng/searxng/blob/master/searx/settings.yml). The stack mounts the folder at `/etc/searxng`. Edit that file to change the engines and other settings.
- **Extra container.** The stack runs a `valkey` container on the default Compose network. `SEARXNG_VALKEY_URL` in `.env` points SearXNG at it, because the default settings do not use Valkey. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve the name `valkey`.
- **Reduced privileges.** Both containers drop all capabilities and add back only the few that they need.
- **Log size.** Both containers limit their log to one file of 1 MB.

## First run

Nothing to set up. Open the web interface and search. SearXNG has no login.

## Links

- [SearXNG documentation](https://docs.searxng.org/)
- [SearXNG source code](https://github.com/searxng/searxng)
- [Video: replace Google with SearXNG](https://www.youtube.com/watch?v=cg9d87PuanE)
