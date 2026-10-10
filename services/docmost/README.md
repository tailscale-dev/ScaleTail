# Docmost

[Docmost](https://docmost.com/) is a wiki and documentation tool for teams. Several people edit a page at the same time, and it supports diagrams, comments, page history, and permissions.

This stack runs Docmost with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                          |
| ------------- | ---------------------------------------------- |
| Web interface | `https://docmost.<tailnet>.ts.net`             |
| Service port  | `3000`                                         |
| Images        | `docmost/docmost`                              |
|               | `postgres:16-alpine`                           |
|               | `redis:7.2-alpine`                             |
| Data          | `./docmost-data/docmost` (uploaded files)      |
|               | `./docmost-data/db-data` (PostgreSQL database) |
|               | `./docmost-data/redis-data` (Redis data)       |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`APP_SECRET`.** A random value of at least 32 characters. Generate one with `openssl rand -hex 32`.
- **`DB_PASSWORD`.** The password of the database. Use letters and digits only, because the value is part of the database address. PostgreSQL applies it only when it first creates the database.

## Deviations from the standard setup

- **Extra containers.** The stack runs `db` (PostgreSQL) and `redis`. Both use the network of the `tailscale` container as well, so Docmost reaches them at `localhost`. PostgreSQL and Redis listen only on the loopback address of the device, so other devices on your Tailnet cannot reach them.
- **Application address.** `APP_URL` in `compose.yaml` is `http://localhost:3000`. Docmost uses this value for the links that it generates, for example in emails. Change it to `https://docmost.<tailnet>.ts.net` if you use such links.

## First run

Open the web interface. Docmost shows its setup page, where you create your workspace and your account.

## Upgrading

If your `compose.yaml` contained the secret and the database password before, set `APP_SECRET` and `DB_PASSWORD` in `.env` to those same values.

Earlier versions listened on all addresses of the device, so PostgreSQL and Redis were reachable from your Tailnet. This version makes them listen on localhost only. Your data stays in place. Run `docker compose up -d` to recreate the `db` and `redis` containers. Any tool that connects to the database or to Redis from another device stops working.

## Links

- [Docmost documentation](https://docmost.com/docs/)
- [Docmost source code](https://github.com/docmost/docmost)
