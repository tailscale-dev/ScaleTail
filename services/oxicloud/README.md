# OxiCloud

[OxiCloud](https://atalayalabs.github.io/OxiCloud/) is a self-hosted cloud for files, calendars, and contacts, with WebDAV, CalDAV, and CardDAV access.

This stack runs OxiCloud with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://oxicloud.<tailnet>.ts.net` |
| Service port  | `8086`                              |
| Image         | `diocrafts/oxicloud:latest`         |
| Data          | `./oxicloud-data/storage/` (files), `./oxicloud-data/postgres/` (database) |

## Before you start

Set these values in `.env`. Compose stops with an error until both are set:

- **`TAILNET_NAME`.** Your Tailnet name without `.ts.net`, such as `tail1234`. OxiCloud builds its public address, `https://<SERVICE>.<TAILNET_NAME>.ts.net`, from it and uses that address for share links and secure cookies.
- **`POSTGRES_PASSWORD`.** The password of the database. Generate it with `openssl rand -hex 32`. PostgreSQL reads it only at the first start, when it creates the database.

## Deviations from the standard setup

- **Database container.** OxiCloud stores its metadata in PostgreSQL, so the stack runs a third container, `app-<service>-db`, as in the [upstream compose file](https://github.com/AtalayaLabs/OxiCloud/blob/main/docker-compose.yml). OxiCloud reaches it by the Compose service name `postgres`.
- **Public address.** `OXICLOUD_BASE_URL` is built from `SERVICE` and `TAILNET_NAME`, so keep both in line with the name of the Tailnet device. Without it, share links point to `http://0.0.0.0:8086` and the login cookies are not marked secure.
- **Trusted proxy.** `OXICLOUD_TRUST_PROXY_CIDR=127.0.0.1/32` makes OxiCloud read the client address that Tailscale Serve sends. Without it, every request comes from `127.0.0.1`, so all users share one login rate limit.
- **Health check.** The image's own check calls `localhost`, which resolves to `::1` in the Tailscale namespace, while OxiCloud listens on IPv4 only. The stack calls `http://127.0.0.1:8086/ready` instead, which also checks the database.
- **No office editing.** The stack does not start the WOPI office server that upstream offers as an add-on.

## First run

OxiCloud shows a setup page to create the first admin account, which stays available until an admin exists.

## Links

- [OxiCloud documentation](https://atalayalabs.github.io/OxiCloud/)
- [OxiCloud source code](https://github.com/AtalayaLabs/OxiCloud)
