# Gitea with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [**Gitea**](https://gitea.com/) with Tailscale as a sidecar container, enabling secure access to your self-hosted Git forge via your private Tailnet. With this setup, your Gitea web UI and Git service are kept private to authorized Tailscale devices unless you explicitly expose ports.

## Gitea

[**Gitea**](https://gitea.com/) is a lightweight, self-hosted Git service that provides repository hosting, pull requests, issue tracking, and more. It is designed for easy deployment and minimal operational overhead, making it a great choice for private Git hosting on homelabs and small teams.

## Configuration Overview

In this deployment, the `tailscale` service runs the Tailscale client and the `app-gitea` container uses `network_mode: service:tailscale`. This keeps Gitea accessible through your Tailnet without requiring public host port mappings.

### What this setup does

- Runs Gitea behind a Tailscale sidecar.
- Uses `TS_SERVE_CONFIG` to proxy requests from Tailscale to `http://127.0.0.1:3000`.
- Keeps the service private unless you explicitly enable host network port exposure.

## Prerequisites

- Docker Compose installed on the host.
- User in the `docker` group or root privileges.
- If you want Tailscale networking to work, the host kernel must support `/dev/net/tun`.

## Volumes

- `./gitea-data/data:/data` — Gitea persistent data directory.
- `./config:/config` — Tailscale Serve configuration and state.
- `./ts/state:/var/lib/tailscale` — Tailscale state directory.

> Tip: Pre-create these folders on the host with appropriate permissions to avoid Docker creating root-owned directories.

## Notes

- Gitea listens internally on port `3000` and SSH on port `22`.
- This configuration does not expose either port to the host network by default.
- If you want to use MagicDNS, uncomment `TS_ACCEPT_DNS=true` in the `tailscale` environment and set `TS_CERT_DOMAIN` appropriately.
- The Tailscale Serve config does not automatically read `.env` values for the app port, so the proxy is hardcoded to `127.0.0.1:3000`.

## Service-specific gotchas

- Ensure `Gitea` data is persisted under `./gitea-data/data` for installation and repositories.
- If you expect to use SSH Git over Tailnet, the app container is already on the same Tailscale network and can accept SSH connections on port `22`.
- If you change the image version, confirm the new image still supports the same `/data` path and environment variables.

## Reference Material

- [Gitea Docker Installation](https://docs.gitea.com/installation/install-with-docker/)
- [Gitea](https://gitea.com/)
- [Tailscale Serve](https://tailscale.com/kb/1085/serve)
