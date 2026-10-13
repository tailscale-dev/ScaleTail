# Miniflux

[Miniflux](https://miniflux.app/) is a minimalist feed reader for RSS, Atom, and JSON feeds. It is fast and has a clean interface without distractions.

This stack runs Miniflux with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                      |
| ------------- | ------------------------------------------ |
| Web interface | `https://miniflux.<tailnet>.ts.net`        |
| Service port  | `8080`                                     |
| Images        | `miniflux/miniflux`                        |
|               | `postgres:15-alpine`                       |
| Data          | `./miniflux-data/db` (PostgreSQL database) |

## Before you start

Set these values in `.env`:

- **`TAILNET_NAME`.** Your Tailnet name with `.ts.net`. `compose.yaml` builds the base address of Miniflux as `https://<SERVICE>.<TAILNET_NAME>`.
- **`ADMIN_USERNAME` and `ADMIN_PASSWORD`.** The administrator account that Miniflux creates at the first start. The password needs at least six characters.
- **`POSTGRES_PASSWORD`.** The password of the database. Use letters and digits only, because the database address contains it. Compose stops with an error if `ADMIN_PASSWORD` or `POSTGRES_PASSWORD` is empty.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with PostgreSQL. It uses the network of the `tailscale` container as well, so Miniflux reaches it at `localhost`. PostgreSQL listens only on the loopback address of the device, so other devices on your Tailnet cannot reach it.
- **Automatic setup.** `RUN_MIGRATIONS=1` and `CREATE_ADMIN=1` make Miniflux prepare the database and create the administrator at the start.

## First run

Open the web interface and log in with the administrator account from `.env`.

## Upgrading

Earlier versions listened on all addresses of the device, so PostgreSQL was reachable from your Tailnet. This version makes it listen on localhost only. Your data stays in place. Run `docker compose up -d` to recreate the `db` container. Any tool that connects to the database from another device stops working.

## Links

- [Miniflux documentation](https://miniflux.app/docs/)
- [Miniflux configuration parameters](https://miniflux.app/docs/configuration.html)
- [Miniflux source code](https://github.com/miniflux/v2)
