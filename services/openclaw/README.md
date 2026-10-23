# OpenClaw

[OpenClaw](https://openclaw.ai) is a self-hosted personal AI assistant. Its Gateway runs the agents, connects chat channels, and serves the Control UI web interface.

This stack runs OpenClaw with a Tailscale sidecar, as described in [the standard setup](https://github.com/tailscale-dev/ScaleTail/blob/main/documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://openclaw.<tailnet>.ts.net`  |
| Service port  | `18789`                              |
| Image         | `ghcr.io/openclaw/openclaw:latest`   |
| Data          | `./openclaw-data/`                   |

## Before you start

- Set `OPENCLAW_GATEWAY_TOKEN` in `.env`. It is the token that signs in to the web interface. Generate it with `openssl rand -hex 32`. Compose stops with an error until it is set.
- Create the data folder before the first start, so that it is owned by you and not by root:

  ```sh
  mkdir -p openclaw-data/state
  ```

  The image runs as user `node` (uid 1000). If your user has another uid, run `sudo chown -R 1000:1000 openclaw-data` too. Without this, Docker creates the folder as root and the application restarts in a loop, logging `GatewayLockError: failed to acquire gateway state ownership`.

## Deviations from the standard setup

- **Gateway token.** OpenClaw refuses connections without authentication, so `OPENCLAW_GATEWAY_TOKEN` is required.
- **Sidecar instead of OpenClaw's own Tailscale mode.** OpenClaw can manage Tailscale Serve itself, but it runs the `tailscale` command on the host. The image contains no Tailscale, so `gateway.tailscale.mode` stays `off` and the sidecar provides Serve. For the same reason, signing in with the Tailscale identity (`gateway.auth.allowTailscale`) does not work, and you sign in with the token.
- **Trusted proxy and start without setup.** Tailscale Serve connects to the Gateway from `127.0.0.1`. Without `gateway.trustedProxies`, the Gateway answers `403 proxy_attribution_required`. The command therefore sets `gateway.trustedProxies` to `127.0.0.1` and `gateway.mode` to `local` each time the container starts, so the Gateway runs without `openclaw onboard` first. Any other process in the shared network namespace is trusted the same way, which is why the token stays required. It binds with `--bind lan`, as the upstream Docker setup does.
- **Hardening.** The application drops `NET_RAW` and `NET_ADMIN` and sets `no-new-privileges`, as upstream's `docker-compose.yml` does.
- **No CLI container.** Upstream's compose file has a separate `openclaw-cli` container. Run the CLI in the application container instead, for example `docker exec app-openclaw node dist/index.js <command>`.
- **Gateway port on the Tailnet.** The Gateway also listens on `18789` without HTTPS, reachable at the Tailscale IP address of the device, when your Tailnet policy allows it. It requires the token.

## First run

1. Open the web interface and enter the value of `OPENCLAW_GATEWAY_TOKEN` in the settings.
2. Each new browser connects as a new device, and the Gateway asks you to approve it once. List the request and approve it:

   ```sh
   docker exec app-openclaw node dist/index.js devices list
   docker exec app-openclaw node dist/index.js devices approve <request-id>
   ```

3. Add a model provider, for example with an API key, before you chat with an agent. See the [OpenClaw documentation](https://docs.openclaw.ai).

## Links

- [OpenClaw documentation](https://docs.openclaw.ai)
- [OpenClaw source code](https://github.com/openclaw/openclaw)
