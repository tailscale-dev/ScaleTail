# Hytale Server

This stack runs a [Hytale](https://hytale.com/) game server with the community image [`deinfreu/hytale-server`](https://deinfreu.github.io/hytale-server-container/installation/container_installation/). Players connect to it over your Tailnet.

This stack runs Hytale Server with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                   |
| ------------- | ------------------------------------------------------- |
| Web interface | None                                                    |
| Game server   | `hytale.<tailnet>.ts.net`, UDP port `5520`              |
| Image         | `deinfreu/hytale-server:experimental`                   |
| Data          | `./hytale-data` (game files, worlds, and configuration) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No Tailscale Serve.** The game uses UDP, which Tailscale Serve does not forward. The server listens on UDP port `5520` of the Tailscale IP address of the device, and the stack has no Serve configuration.
- **Machine ID.** The stack mounts `/etc/machine-id` of the Docker host read-only.
- **Interactive console.** The `application` container has `tty` and `stdin_open` enabled, so that you can attach to the server console.
- **Server settings.** `SERVER_IP`, `SERVER_PORT`, `PROD`, and `DEBUG` in `.env` are passed to the server.

## First run

1. Start the stack in the foreground the first time, without `-d`, because the server asks you to authenticate:

   ```bash
   docker compose up
   ```

2. Follow the authentication steps that the server prints. See the [installation notes of the image](https://deinfreu.github.io/hytale-server-container/installation/container_installation/).
3. Stop the stack with `Ctrl+C` and start it in the background with `docker compose up -d`.
4. In the game, connect to `hytale.<tailnet>.ts.net`. All players must be on your Tailnet, or you must share the device with them.

## Links

- [Hytale server container documentation](https://deinfreu.github.io/hytale-server-container/installation/container_installation/)
