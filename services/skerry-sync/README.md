# Skerry Sync with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Skerry Sync](https://github.com/SeCherkasov/SkerrySSH) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Skerry Sync

[Skerry Sync](https://github.com/SeCherkasov/SkerrySSH) is the optional self-hosted sync server for the Skerry SSH client (Linux, Windows, macOS, Android). It stores only ciphertext and sync metadata, verifies passwords with SRP-6a without ever receiving them, and pushes live updates over WebSocket. Pairing it with Tailscale keeps vault sync off the public internet while remaining reachable from all your Tailnet devices.

## Configuration Overview

In this setup, the `tailscale` service (container `tailscale-skerry-sync`) runs Tailscale, which manages secure networking for Skerry Sync. The `application` service (container `app-skerry-sync`) uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

Tailscale Serve terminates HTTPS for the Tailnet and proxies to the server's plain HTTP port 8080. That satisfies the upstream requirement to put a TLS-terminating reverse proxy in front of any non-local deployment: the admin token and account metadata never cross the public internet unencrypted.

## Prerequisites

- Docker Compose and host user membership in the `docker` group.
- A Tailscale auth key in `.env` (`TS_AUTHKEY`).
- A stable `SKERRY_JWT_SECRET`, for example generated with `openssl rand -base64 48`. Keep it stable across restarts or all issued tokens are invalidated.
- An optional `SKERRY_ADMIN_TOKEN`, for example generated with `openssl rand -hex 16`. Empty leaves the operator console (`/console`) and `/admin/*` endpoints closed.

## Volumes

- `./skerry-sync-data/data:/data` holds the SQLite database (`skerry-sync.db`).
- The image runs as unprivileged UID/GID `999:999`. Pre-create the directory so Docker does not create a root-owned folder:

  ```sh
  mkdir -p skerry-sync-data/data
  sudo chown -R 999:999 skerry-sync-data
  ```

- Back up the SQLite file (or a PostgreSQL dump if you switch databases). The data is encrypted, but it is your only restore point.

## Tailnet access

- Serve proxies `https://<skerry-sync-tailnet-name>.<tailnet>.ts.net` to `http://127.0.0.1:8080`.
- Public page: `/`, account area: `/account`, operator console: `/console` (requires `SKERRY_ADMIN_TOKEN`).
- Liveness: `/healthz`, readiness: `/readyz`. Prometheus `/metrics` stays off unless you configure `SKERRY_METRICS` upstream.
- In the Skerry app, go to Settings, Sync, enter the Tailnet HTTPS URL, then register or sign in. The `/sync` WebSocket switches to `wss://` automatically.

## Ports

The commented `0.0.0.0:${SERVICEPORT}:${SERVICEPORT}` mapping stays removed for Tailnet-only access. The server itself speaks plain HTTP on internal port 8080. Expose it on LAN only for deliberate local testing, and note that upstream treats trusted-LAN cleartext as acceptable because payloads are end-to-end encrypted.

## Service-specific notes

- SQLite is the default with zero configuration (`SKERRY_DB_URL=jdbc:sqlite:/data/skerry-sync.db`). For PostgreSQL, uncomment the `db` service and its `depends_on` entry in `compose.yaml`, then set `SKERRY_DB_URL=jdbc:postgresql://localhost:5432/skerry` plus `SKERRY_DB_USER`, `SKERRY_DB_PASSWORD`, and `POSTGRES_PASSWORD` in `.env` (the database shares the Tailscale network namespace, so the app reaches it at `localhost`).
- The server refuses to start with the upstream default JWT secret unless `SKERRY_DEV=1`. Always set a real `SKERRY_JWT_SECRET`.
- The bundled `skerry-admin` CLI is available inside the app container: `docker exec app-skerry-sync skerry-admin --help`.
- The image defines its own `HEALTHCHECK` (`wget -qO- http://localhost:8080/healthz`), so this stack does not override it.

## Troubleshooting

- `SQLiteException: [SQLITE_CANTOPEN] Unable to open the database file` at startup means the bind-mounted `/data` directory is not writable by the container's unprivileged user (`999:999`). This happens when Docker auto-creates `skerry-sync-data/data` as root. Fix it with:

  ```sh
  docker compose down
  sudo rm -rf skerry-sync-data/data
  mkdir -p skerry-sync-data/data
  sudo chown -R 999:999 skerry-sync-data
  docker compose up -d
  ```

## Upstream documentation

- [Skerry Sync server README](https://github.com/SeCherkasov/SkerrySSH/blob/main/server/README.md)
- [Skerry SSH repository](https://github.com/SeCherkasov/SkerrySSH)
- [Skerry install and first run guide](https://skerry.sech.uk/guide/)
- [Docker Hub image](https://hub.docker.com/r/secherkasov/skerry-sync)

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variables `TS_AUTHKEY`, `SKERRY_JWT_SECRET`, `SKERRY_ADMIN_TOKEN` (plus `SKERRY_DB_*`/`POSTGRES_PASSWORD` when using PostgreSQL)
