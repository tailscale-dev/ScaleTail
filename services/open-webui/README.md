# Open WebUI

[Open WebUI](https://openwebui.com/) is a chat interface for AI models. It works with Ollama and with every API that is compatible with OpenAI.

This stack runs Open WebUI with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://open-webui.<tailnet>.ts.net` |
| Service port  | `8080`                                |
| Image         | `ghcr.io/open-webui/open-webui:main`  |
| Data          | `./open-webui-data`                   |

## Before you start

Set these values in `.env`:

- **`WEBUI_SECRET_KEY`.** A long random value that Open WebUI uses to sign the login tokens.
- **`OLLAMA_BASE_URL`.** The address of your Ollama instance:
  - On the Docker host: `http://host.docker.internal:11434`. A native Ollama listens only on `127.0.0.1` by default, which containers cannot reach. Set `OLLAMA_HOST=0.0.0.0:11434` for it. This makes Ollama reachable on every network of the host, so limit access with a firewall.
  - In the [Ollama stack](../ollama/) of this repository: `http://<Tailscale IP address of ollama>:11434`. That stack runs on its own Tailnet device and does not publish port `11434` on the Docker host.
  - On a machine in your local network: `http://<local-ip>:11434`
  - On another Tailnet device: `http://<Tailscale IP address>:11434`
  - Leave it empty to add another provider, such as OpenAI, in the web interface later.

## Deviations from the standard setup

- **Host gateway.** The `tailscale` container has an `extra_hosts` entry that maps `host.docker.internal` to the gateway of the Docker host, so that Open WebUI can reach an Ollama instance on the host. The `application` container shares the network of `tailscale`, so the entry is set there.

## First run

Open the web interface and create your account right after the first start. The first account becomes the administrator, and until then everyone who can reach the device on your Tailnet can register it.

After you add models to Ollama, refresh the model list in Open WebUI under **Settings** > **Connections**.

## Configuration

- **MagicDNS.** Uncomment `TS_ACCEPT_DNS=true` in `compose.yaml` only if Open WebUI must resolve MagicDNS names, such as an Ollama instance that you address by its Tailnet name.
- **WebSockets.** Open WebUI needs WebSocket connections. Make sure that nothing between your browser and the device blocks them.

## Links

- [Open WebUI documentation](https://docs.openwebui.com/)
- [Open WebUI source code](https://github.com/open-webui/open-webui)
- [Ollama stack in this repository](../ollama/)
