# Kaneo

[Kaneo](https://kaneo.app/) is a project management tool with boards, tasks, and a clean interface. It is an open-source alternative to tools such as Trello and Linear.

This stack runs Kaneo with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                              |
| ------------- | -------------------------------------------------- |
| Web interface | `https://kaneo.<tailnet>.ts.net`                   |
| Service port  | `5173`                                             |
| Images        | `ghcr.io/usekaneo/kaneo`                           |
|               | `postgres:16-alpine`                               |
| Data          | `./kaneo-data/postgres_data` (PostgreSQL database) |

## Before you start

Set these values in `.env`:

- **`KANEO_CLIENT_URL`.** The address of the web interface, `https://kaneo.<tailnet>.ts.net`. Kaneo derives the address of its API from it and does not start with the sample value. Recreate the container after you change it.
- **`AUTH_SECRET` and `DB_PASSWORD`.** Two different random values. Generate each with `openssl rand -hex 32`.

## Deviations from the standard setup

- **Extra container.** The stack runs a `postgres` container. It uses the network of the `tailscale` container as well, so Kaneo reaches it at `localhost`. PostgreSQL therefore also listens on port `5432` of the Tailscale IP address of the device.
- **Serve port from `.env`.** The Tailscale Serve configuration in `compose.yaml` takes its port from `SERVICEPORT`.
- **Database image.** `IMAGE_URL_DATABASE` in `.env` selects the PostgreSQL image.
- **The containers read the whole `.env` file.** Both containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in their environment.

## First run

Open the web interface and sign up to create the first account. Then create your workspace.

## Upgrading

Since [release v2.7.0](https://github.com/usekaneo/kaneo/releases/tag/v2.7.0), Kaneo is a single image. Earlier versions of this stack ran a `frontend` and a `backend` container. See [Upgrade Kaneo](https://kaneo.app/docs/core/operations/upgrades) in the upstream documentation.

When you update from such a version, start the stack with `docker compose up -d --remove-orphans`. Compose then removes the old `frontend` and `backend` containers, which use the same ports as the new container.

## Links

- [Kaneo documentation](https://kaneo.app/docs)
- [Kaneo Docker Compose installation](https://kaneo.app/docs/core/installation/docker-compose)
- [Kaneo source code](https://github.com/usekaneo/kaneo)
