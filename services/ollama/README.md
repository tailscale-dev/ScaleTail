# Ollama with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Ollama](https://ollama.com) with Tailscale as a sidecar container to keep the API reachable securely over your Tailnet.

## Ollama

[Ollama](https://ollama.com) lets you run large language models (LLMs) locally — such as Llama 3, Mistral, and Gemma — with a simple API compatible with the OpenAI client format. Pairing it with Tailscale means you can access your local models from any device on your Tailnet (phone, laptop, remote machine) without exposing the API to the public internet.

## Configuration Overview

In this setup, the `tailscale-ollama` service runs Tailscale, which manages secure networking for Ollama. The `app-ollama` service uses Docker's `network_mode: service:tailscale` so all traffic is routed through the Tailscale network stack. The Ollama API remains Tailnet-only by default unless you explicitly expose the port to your LAN.

An optional `yourNetwork` external Docker network is attached to the `tailscale` container. This allows other containers on the same host (such as Open WebUI or other LLM frontends) to reach Ollama via its Tailscale IP, keeping inter-container communication on the same overlay network.

## Prerequisites

- The host user must be in the `docker` group.
- The `/dev/net/tun` device must be available on the host (standard on most Linux systems).
- Pre-create the bind-mount directories before starting the stack to avoid Docker creating root-owned folders:

```bash
mkdir -p config ts/state ollama-data
```

- If you use the optional `yourNetwork` network, create it first if it does not already exist:

```bash
docker network create yourNetwork
```

If you don't use a shared proxy network, remove the `networks:` sections from `compose.yaml`.

## Volumes

| Path            | Purpose                                                            |
| --------------- | ------------------------------------------------------------------ |
| `./config`      | Tailscale serve config (`serve.json`)                              |
| `./ts/state`    | Tailscale persistent state                                         |
| `./ollama-data` | Downloaded Ollama models (can be large — ensure enough disk space) |

## MagicDNS and HTTPS

Tailscale Serve is pre-configured to proxy HTTPS on port 443 to Ollama's internal port 11434. To enable it:

1. Uncomment `TS_ACCEPT_DNS=true` in the `tailscale` service environment.
2. Ensure your Tailnet has MagicDNS and HTTPS certificates enabled in the [Tailscale admin console](https://login.tailscale.com/admin/dns).
3. The `serve.json` config in `compose.yaml` uses `$TS_CERT_DOMAIN` automatically — no manual editing needed.

You can then reach Ollama at `https://ollama.<your-tailnet-name>.ts.net`.

## Port Exposure (LAN access)

By default, the `ports:` section is commented out — Ollama is only accessible over your Tailnet. If you also want LAN access (e.g. from devices not on Tailscale), uncomment it in `compose.yaml`:

```yaml
ports:
  - 0.0.0.0:11434:11434
```

This is optional and not required for Tailnet-only usage.

## API Key (Optional)

Ollama supports a simple bearer token for API access. Set `OLLAMA_API_KEY` in your `.env` file to enable it. Leave it blank to allow unauthenticated access (safe when Tailnet-only).

## First-time Setup

After starting the stack, pull a model to get started:

```bash
docker exec app-ollama ollama pull llama3
```

You can then send requests to the API:

```bash
curl http://<tailscale-ip>:11434/api/generate \
  -d '{"model": "llama3", "prompt": "Hello!"}'
```

Or if using HTTPS via Tailscale Serve:

```bash
curl https://ollama.<your-tailnet-name>.ts.net/api/generate \
  -d '{"model": "llama3", "prompt": "Hello!"}'
```

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` — Set `TS_AUTHKEY` (required). Optionally set `OLLAMA_API_KEY`.

## Useful Links

- [Ollama official site](https://ollama.com)
- [Ollama model library](https://ollama.com/library)
- [Ollama GitHub](https://github.com/ollama/ollama)
- [Tailscale auth keys](https://tailscale.com/kb/1085/auth-keys)
- [Tailscale Serve docs](https://tailscale.com/kb/1312/serve)
- [Open WebUI](https://github.com/open-webui/open-webui) — a popular browser-based UI for Ollama
