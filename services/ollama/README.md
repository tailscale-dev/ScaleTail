# Ollama

[Ollama](https://ollama.com) runs large language models on your own hardware, such as Llama, Mistral, and Gemma. It offers an API that is compatible with the OpenAI client format.

This stack runs Ollama with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                   |
| ------------- | ------------------------------------------------------- |
| Web interface | None                                                    |
| API           | `https://ollama.<tailnet>.ts.net`                       |
| Service port  | `11434`                                                 |
| Image         | `ollama/ollama`                                         |
| Data          | `./ollama-data` (downloaded models, which can be large) |

## Before you start

Make sure that the disk has enough free space for the models that you want to use.

## Deviations from the standard setup

- **No web interface.** Tailscale Serve publishes the API of Ollama. Use a client such as [Open WebUI](../open-webui/) for a chat interface.
- **Models stay loaded.** `OLLAMA_KEEP_ALIVE=24h` keeps a model in memory for 24 hours after its last use.
- **No authentication.** The API has no login. Everyone who can reach the device on your Tailnet can use your models.
- **Time zone.** `compose.yaml` does not pass `TZ` to the container.

## First run

1. Download a model:

   ```bash
   docker exec app-ollama ollama pull llama3
   ```

2. Send a request from a device on your Tailnet:

   ```bash
   curl https://ollama.<tailnet>.ts.net/api/generate \
     -d '{"model": "llama3", "prompt": "Hello!"}'
   ```

Other containers and devices can also use the plain HTTP port, `http://<Tailscale IP address of ollama>:11434`.

## Configuration

### Local network access

To reach Ollama from devices that are not on your Tailnet, uncomment the `ports` block of the `tailscale` service in `compose.yaml`. It publishes port `11434` on the Docker host.

### Shared Docker network

To let other containers on the Docker host reach Ollama over a Docker network, uncomment both `networks` blocks in `compose.yaml` and replace `yourNetwork` with the name of an existing network. Create the network first if needed:

```bash
docker network create yourNetwork
```

## Links

- [Ollama documentation](https://docs.ollama.com/)
- [Ollama model library](https://ollama.com/library)
- [Ollama source code](https://github.com/ollama/ollama)
