# OxiCloud

[OxiCloud](https://atalayalabs.github.io/OxiCloud/) A fast self-hosted cloud for files, calendars, contacts, with WebDAV, CalDAV and CardDAV access. 

This stack runs Oxicloud with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://oxicloud.<tailnet>.ts.net` |
| Service port  | `8086`                              |
| Image         | `diocrafts/oxicloud:latest`         |
| Data          | `./oxicloud-data/storage/` (files), `./oxicloud-data/postgres/` (database) |

## Before you start

Add values for the mandatory variables : TAILNET_NAME and POSTRGES_PASSWORD in .env file. Otherwise Compose will stop.
Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Database container.** OxiCloud stores its metadata in PostgreSQL, so the stack runs a third container, `app-<service>-db`, as in the [upstream compose file](https://github.com/AtalayaLabs/OxiCloud/blob/main/docker-compose.yml). OxiCloud reaches it by the Compose service name `postgres`.
- **Public address.** `OXICLOUD_BASE_URL` is built from `SERVICE` and `TAILNET_NAME`, so keep both in line with the name of the Tailnet device. Without it, share links point to `http://0.0.0.0:8086` and the login cookies are not marked secure.
- **Trusted proxy.** `OXICLOUD_TRUST_PROXY_CIDR=127.0.0.1/32` makes OxiCloud read the client address that Tailscale Serve sends. Without it, every request comes from `127.0.0.1`, so all users share one login rate limit.
- **Health check.** The image's own check calls `localhost`, which resolves to `::1` in the Tailscale namespace, while OxiCloud listens on IPv4 only. The stack calls `http://127.0.0.1:8086/ready` instead, which also checks the database.
- **No office editing.** The stack does not start the WOPI office server that upstream offers as an add-on.

## First run

OxiCloud shows a setup page to create the first admin account, which stays available until an admin exists.

## Links

- [OxiCloud documentation](https://github.com/AtalayaLabs/OxiCloud)
- [OxiCloud source code](https://github.com/AtalayaLabs/OxiCloud)
