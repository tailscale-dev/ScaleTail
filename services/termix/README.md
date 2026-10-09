# Termix with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Termix](https://github.com/Termix-SSH/Termix) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Termix

[Termix](https://github.com/Termix-SSH/Termix) is a free, open-source, self-hosted server management platform and Termius alternative. It puts SSH terminals, remote desktops (RDP, VNC, Telnet), file transfers, tunnels, Docker management, metrics, and automations in one web interface. Pairing it with Tailscale keeps shell access to your infrastructure off the public internet while remaining reachable from all your Tailnet devices.

## Configuration Overview

In this setup, the `tailscale` service (container `tailscale-termix`) runs Tailscale, which manages secure networking for Termix. The `application` service (container `app-termix`) uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## Prerequisites

- Docker Compose and host user membership in the `docker` group.
- A Tailscale auth key in `.env` (`TS_AUTHKEY`).
- On first launch, create the admin account in the web UI. Registration settings can then be locked in Admin Settings or via `ALLOW_REGISTRATION` (see [environment variables](https://docs.termix.site/setup/environment-variables)).

## Volumes

- `./termix-data/data:/app/data` holds the SQLite database, auto-generated secrets (`JWT_SECRET`, `DATABASE_KEY`, and others in `/app/data/.env`), SSL certificates, encryption keys, and session recordings. Back it up: it is your only restore point.
- Pre-create the directory so Docker does not create a root-owned folder (the container runs as `PUID`/`PGID` `1000:1000`):

  ```sh
  mkdir -p termix-data/data
  sudo chown -R 1000:1000 termix-data
  ```

## Tailnet access

- Serve proxies `https://<termix-tailnet-name>.<tailnet>.ts.net` to `http://127.0.0.1:8080`.
- The web UI is available at the Tailnet HTTPS URL once the stack is up.

## Ports

The commented `0.0.0.0:${SERVICEPORT}:${SERVICEPORT}` mapping stays removed for Tailnet-only access. The server listens on internal port 8080 (`PORT`). Expose it on LAN only for deliberate local testing.

## Service-specific notes

- SQLite is the default and needs no setup. For PostgreSQL or MySQL, set `DATABASE_DIALECT` and `DATABASE_URL` in `.env` (see [database setup](https://docs.termix.site/setup/database)). Keep the data volume either way: Termix still uses it for keys, certificates, and recordings.
- Remote desktop (RDP/VNC/Telnet) needs the Guacamole daemon: uncomment the `guacd` service and its `depends_on` entry in `compose.yaml`, set `ENABLE_GUACAMOLE=true` in `.env`, then turn on the RDP/VNC/Telnet toggle in Admin Settings with guacd URL `localhost:4822` (the daemon shares the Tailscale network namespace). It is disabled by default; SSH and terminal features work standalone.
- Security keys are auto-generated on first startup into `/app/data/.env`. Do not set them manually unless restoring from backup.
- The image defines its own `HEALTHCHECK` (`wget` against `http://localhost:30001/health`), so this stack does not override it.

## Upstream documentation

- [Termix Docker install](https://docs.termix.site/install/server/docker)
- [Environment variables](https://docs.termix.site/setup/environment-variables)
- [Database setup](https://docs.termix.site/setup/database)
- [Remote desktop setup](https://docs.termix.site/setup/remote-desktop)
- [Termix repository](https://github.com/Termix-SSH/Termix)

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variables `TS_AUTHKEY`, `PORT`, `ENABLE_GUACAMOLE`
