# Traefik

[Traefik](https://traefik.io/traefik/) is a reverse proxy and load balancer. It discovers your containers through Docker and routes requests to them by rules that you set as labels.

This stack runs Traefik with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                           |
| ------------- | ------------------------------------------------------------------------------- |
| Web interface | `https://traefik.<tailnet>.ts.net` (routes to your services, see the first run) |
| Service port  | `80`                                                                            |
| Images        | `traefik`                                                                       |
|               | `yeasy/simple-web` (sample site)                                                |
| Data          | `./traefik-data/log` (Traefik log and access log)                               |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Published host port.** The `ports` block is active and publishes port `80` of the Docker host. Devices in your local network can therefore reach Traefik without Tailscale.
- **Service name.** The application service is called `traefik_proxy`, not `application`.
- **Docker socket.** Traefik mounts `/var/run/docker.sock` to discover containers and their labels.
- **Configuration through flags.** The `command` block in `compose.yaml` is the static configuration. Traefik ignores these flags when it finds a static configuration file, so edit the flags and do not add a `traefik.yml` file.
- **Sample site.** The stack runs a `simpleweb` container with routing labels as an example. Replace it with your own services.
- **Only port 80.** Tailscale Serve listens on port `443` of the Tailnet address and forwards to the `web` entrypoint of Traefik on port `80`. Do not add a Traefik entrypoint on port `443`. Traefik shares the network of the `tailscale` container, where that port is in use, so Traefik would exit and restart in a loop.
- **Health check.** The health check calls the ping endpoint, so keep the `--ping=true` flag. Traefik only routes to containers that Docker reports as healthy, so the sample site is reachable only after its first health check passes.

## First run

Requests through your Tailnet arrive with the host name `traefik.<tailnet>.ts.net`. The sample routers match `traefik.domain.local` and `simpleweb.domain.local`, so Traefik answers `404` over the Tailnet at first.

Change a `Host()` rule in the labels in `compose.yaml` to `traefik.<tailnet>.ts.net` and restart the stack. That router is then reachable at `https://traefik.<tailnet>.ts.net`.

## Troubleshooting

Traefik writes its log to `./traefik-data/log/traefik.log`, so `docker logs` shows nothing for the Traefik container. Read that file when the container restarts or a router does not work.

## Links

- [Traefik documentation](https://doc.traefik.io/traefik/)
- [Traefik Docker provider](https://doc.traefik.io/traefik/providers/docker/)
- [Traefik source code](https://github.com/traefik/traefik)
