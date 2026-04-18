# Dockge with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Dockge](https://github.com/louislam/dockge) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Dockge

[Dockge](https://github.com/louislam/dockge) is fancy, easy-to-use and reactive self-hosted docker compose.yaml stack-oriented manager.

## Key Features

- Manage your compose.yaml files
- Create/Edit/Start/Stop/Restart/Delete
- Update Docker Images
- Interactive Editor for compose.yaml
- Interactive Web Terminal
- Convert docker run ... commands into compose.yaml
- File based structure - Dockge won't kidnap your compose files, they are stored on your drive as usual. You can interact with them using normal docker compose commands
- Reactive - Everything is just responsive. Progress (Pull/Up/Down) and terminal output are in real-time
- Easy-to-use & fancy UI - If you love Uptime Kuma's UI/UX, you will love this one too

## Configuration Overview

In this setup, the `tailscale-dockge` service runs Tailscale, which manages secure networking for Dockge. The `dockge` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

