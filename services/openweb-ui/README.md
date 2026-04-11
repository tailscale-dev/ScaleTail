# openweb-ui stack

This folder defines a Docker Compose stack that runs:

- **tailscale** as the network boundary and HTTPS entrypoint
- **ollama** for local model serving
- **open-webui** for the UI connected to Ollama

## Files

- `docker-compose.yml`: stack definition for all services and Tailscale serve config.
- `stack.env.example`: example environment variables (safe placeholders).

## How the compose setup works

### `configs.ts-serve`
Embeds Tailscale Serve JSON as an inline Docker config:

- Enables HTTPS on TCP 443.
- Publishes `${TS_CERT_DOMAIN}:443`.
- Proxies `/` traffic to `http://127.0.0.1:8080` inside the shared network namespace.
- Explicitly disables Funnel for that domain.

`$${TS_CERT_DOMAIN}` uses double-dollar escaping so Compose passes `${TS_CERT_DOMAIN}` literally into the config payload.

### `tailscale` service
- Uses `tailscale/tailscale:latest`.
- Authenticates with `TS_AUTHKEY`.
- Stores state at `/var/lib/tailscale` (mapped to `/mnt/appdata/tailscale/${SERVICE}/state`).
- Loads serve config from `/config/serve.json` via Compose `configs`.
- Requires `/dev/net/tun` and `NET_ADMIN` capability.
- Exposes host ports:
  - `3000 -> 8080`
  - `11434 -> 11434`
- Healthcheck probes `http://127.0.0.1:41234/healthz`.

### `ollama` service
- Uses `ollama/ollama:latest`.
- Shares network namespace with Tailscale via `network_mode: service:tailscale`.
- Starts only after Tailscale is healthy.
- Loads variables from `stack.env`.
- Mounts model storage at `/mnt/ai_models/ollama`.
- Requests GPU access with `gpus: all`.

### `open-webui` service
- Uses `ghcr.io/open-webui/open-webui:main`.
- Shares Tailscale network namespace.
- Depends on `ollama`.
- Uses `stack.env` and points to Ollama at `http://127.0.0.1:11434`.
- Stores WebUI data in `/mnt/appdata/open-webui`.

## Usage

1. Copy the env template and fill in real secrets:

```bash
cp stack.env.example stack.env
```

2. Edit `stack.env` with your actual values.

3. Start the stack:

```bash
docker compose up -d
```

4. Check status:

```bash
docker compose ps
```

## Notes

- Keep `stack.env` out of git (contains secrets).
- Ensure the host supports GPU passthrough and has `/dev/net/tun` available.
- `WEBUI_AUTH`, admin email, and admin password are set through environment variables in `stack.env`.
