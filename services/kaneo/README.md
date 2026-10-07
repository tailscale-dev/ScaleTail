# Kaneo

[Kaneo](https://kaneo.app/) is a project management tool with boards, tasks, and a clean interface. It is an open-source alternative to tools such as Trello and Linear.

This stack runs Kaneo with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                              |
| ------------- | -------------------------------------------------- |
| Web interface | `https://kaneo.<tailnet>.ts.net`                   |
| Service ports | `5173` (web interface) and `1337` (API)            |
| Images        | `ghcr.io/usekaneo/web`                             |
|               | `ghcr.io/usekaneo/api`                             |
|               | `postgres:16-alpine`                               |
| Data          | `./kaneo-data/postgres_data` (PostgreSQL database) |

## Before you start

Set these values in `.env`:

- **`KANEO_CLIENT_URL` and `KANEO_API_URL`.** The address of the web interface, `https://kaneo.<tailnet>.ts.net`, and the same address with `/api`. The backend does not start with the sample values.
- **`AUTH_SECRET`.** A long random value, for example from `openssl rand -hex 32`.
- **`DB_PASSWORD`.** The password of the database.

## Deviations from the standard setup

- **Three application containers.** The stack has no `application` service. It runs `frontend`, `backend`, and `postgres`, which all use the network of the `tailscale` container and reach each other at `localhost`. PostgreSQL therefore also listens on port `5432` of the Tailscale IP address of the device.
- **Two Serve routes.** Tailscale Serve forwards `/api/` to the backend and everything else to the frontend. The ports come from `SERVICEPORT_BACKEND` and `SERVICEPORT_FRONTEND` in `.env`.
- **Images are set in `.env`.** The stack does not use `IMAGE_URL` and `SERVICEPORT`. `IMAGE_URL_FRONTEND`, `IMAGE_URL_BACKEND`, and `IMAGE_URL_DATABASE` select the images.
- **The containers read the whole `.env` file.** All three containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in their environment.

## First run

Open the web interface and sign up to create the first account. Then create your workspace.

## Links

- [Kaneo documentation](https://kaneo.app/docs)
- [Kaneo source code](https://github.com/usekaneo/kaneo)
