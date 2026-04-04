# Open WebUI with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Open WebUI](https://openwebui.com/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Open WebUI

[Open WebUI](https://openwebui.com/) is a feature-rich, self-hosted AI platform that provides a ChatGPT-style interface for interacting with local and cloud-based AI models. It supports Ollama and any OpenAI-compatible API. Pairing it with Tailscale means your private AI interface is securely accessible from any of your devices — phone, laptop, or otherwise — without exposing it to the public internet.

## Configuration Overview

In this setup, the `tailscale-open-webui` service runs Tailscale, which manages secure networking for Open WebUI. The `app-open-webui` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## Prerequisites

- A Tailscale account with an auth key ([generate one here](https://login.tailscale.com/admin/settings/keys))
- MagicDNS and HTTPS enabled in your [Tailscale admin console](https://login.tailscale.com/admin/dns)
- Docker and Docker Compose installed
- An AI backend — Ollama running locally, on another machine, or an OpenAI-compatible API

## Setup

1. Copy `.env.example` to `.env` and fill in your values
2. Set `OLLAMA_BASE_URL` to point at your Ollama instance (see `.env.example` for examples), or leave it blank and configure a different API provider in the Open WebUI settings after first launch
3. Copy `serve.json` into `ts/config/serve.json` — it is mounted into the Tailscale container
4. Pre-create the data directory to avoid Docker creating it as root-owned: `mkdir -p ./data`
5. Run `docker compose config` to validate before deploying
6. Start the stack: `docker compose up -d`
7. On first launch, navigate to `https://<TS_HOSTNAME>.<tailnet>.ts.net` and create your admin account — the server is open until the first user registers

## Gotchas

- **First-run security**: Create your admin account immediately after deployment
- **WebSocket support**: Open WebUI requires WebSocket connections — ensure nothing in your network path blocks them
- **Ollama on the same host**: Use `host.docker.internal:11434` as the `OLLAMA_BASE_URL` to reach Ollama running on the Docker host
- **Ollama over Tailnet**: If Ollama runs on a different machine, use its Tailscale IP (e.g. `http://100.x.x.x:11434`)
- **No Ollama**: Leave `OLLAMA_BASE_URL` blank and configure OpenAI or another provider in the UI after first launch
- **Health check**: The compose uses `tailscale status` for the health check. The `41234/healthz` endpoint is not available in userspace mode (`TS_USERSPACE=true`)
- **MagicDNS**: `TS_CERT_DOMAIN` in `serve.json` is populated automatically by Tailscale at runtime — you do not set it manually
- **LAN access**: Ports are commented out by default. Uncomment `SERVICEPORT` in `compose.yaml` if you also want LAN access alongside Tailnet access

## Resources

- [Open WebUI Documentation](https://docs.openwebui.com/)
- [Open WebUI GitHub](https://github.com/open-webui/open-webui)
- [Tailscale Serve docs](https://tailscale.com/kb/1242/tailscale-serve)
- [Tailscale Docker guide](https://tailscale.com/blog/docker-tailscale-guide)
