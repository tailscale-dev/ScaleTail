# Hytale Server with Tailscale Sidecar Configuration

This Docker Compose configuration sets up a Hytale game server with Tailscale as a sidecar container to place the server directly on your Tailnet. The Hytale container uses the Tailscale network stack via `network_mode: service:tailscale`, so players connect over Tailscale without exposing the UDP port publicly.

## Hytale Server

The Hytale server runs from `deinfreu/hytale-server:experimental` and is configured for UDP port `5520`. The game server data is stored in the `${SERVICE}-data` directory to persist across restarts.

Upstream container details and install notes:
[https://deinfreu.github.io/hytale-server-container/installation/container_installation/](https://deinfreu.github.io/hytale-server-container/installation/container_installation/)

## Key Notes

* First-time authentication should be done attached (do not use `-d` initially).
* Game files, world data, and configuration are stored in the data volume and persist across restarts.

## Configuration Overview

In this setup, the `tailscale` service runs the Tailscale client to join your private mesh network. The `application` service is configured with `network_mode: service:tailscale`, so all network traffic for the game server is routed through the Tailscale container. The sidecar binds UDP `5520` for Tailnet access only.

## Files to check

Please verify the following files and variables before deploying:

* `.env` — define `SERVICE`, `IMAGE_URL`, `SERVICEPORT`, `TS_AUTHKEY`, and the Hytale variables (`SERVER_IP`, `SERVER_PORT`, `PROD`, `DEBUG`, `TZ`).
* `compose.yaml` — confirm environment variables and volume mappings for your server.
