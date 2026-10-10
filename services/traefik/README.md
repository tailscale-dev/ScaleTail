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
- **Docker socket.** Traefik mounts `/var/run/docker.sock` with write access to discover containers and their labels. Treat access to the socket as root access to the Docker host.
- **Configuration through flags.** The `command` block in `compose.yaml` is the static configuration. Traefik ignores these flags when it finds a static configuration file, so edit the flags and do not add a `traefik.yml` file.
- **Sample site.** The stack runs a `simpleweb` container with routing labels as an example. Replace it with your own services.
- **Only port 80.** Tailscale Serve listens on port `443` of the Tailnet address and forwards to the `web` entrypoint of Traefik on port `80`. Do not add a Traefik entrypoint on port `443`. Traefik shares the network of the `tailscale` container, where that port is in use, so Traefik would exit and restart in a loop.
- **Health check.** The health check calls the ping endpoint, so keep the `--ping=true` flag. Traefik only routes to containers that Docker reports as healthy, so the sample site is reachable only after its first health check passes.
- **Dashboard.** The stack does not serve the Traefik dashboard or its API. Serving them needs a router with a password, which is described in [Configuration](#configuration).

## First run

Requests through your Tailnet arrive with the host name `traefik.<tailnet>.ts.net`. The sample router matches `simpleweb.domain.local`, so Traefik answers `404` over the Tailnet at first.

Change the `Host()` rule of the `simpleweb` router in the labels in `compose.yaml` to `traefik.<tailnet>.ts.net` and restart the stack. The sample site is then reachable at `https://traefik.<tailnet>.ts.net`.

## Configuration

**Dashboard.** Add a router that uses the `api@internal` service, and protect it with a basic-auth middleware. Create the password entry with `htpasswd -nB <user>`, and write each `$` of the hash as `$$`, because Compose reads `$` in labels as a variable. Add these labels to the `traefik_proxy` service in `compose.yaml`:

```yaml
    labels:
      - traefik.enable=true
      - traefik.http.routers.dashboard.rule=Host(`traefik.<tailnet>.ts.net`) && (PathPrefix(`/api`) || PathPrefix(`/dashboard`))
      - traefik.http.routers.dashboard.entrypoints=web
      - traefik.http.routers.dashboard.service=api@internal
      - traefik.http.services.dashboard.loadbalancer.server.port=8080 # Traefik drops the labels of a container without a port - this label gives it one
      - traefik.http.routers.dashboard.middlewares=dashboard-auth
      - traefik.http.middlewares.dashboard-auth.basicauth.users=<user>:<escaped hash>
```

Restart the stack, then open `https://traefik.<tailnet>.ts.net/dashboard/` and sign in with the user from the hash. Without a router, the dashboard and the API are not served.

Sign in through the Tailnet address only. The `ports` block publishes port `80` of the Docker host over plain HTTP, so a device on your local network that sends the Tailnet host name to that port reaches the sign-in prompt without TLS.

## Troubleshooting

Traefik writes its log to `./traefik-data/log/traefik.log`, so `docker logs` shows nothing for the Traefik container. Read that file when the container restarts or a router does not work.

## Upgrading

Earlier versions of this stack served the Traefik dashboard and API without a password. They were reachable on port `8080` of the Tailscale IP address, and on port `80` of the Docker host for the host name `traefik.domain.local`. This version serves neither. The dashboard router and the geoblock plugin flags are removed. Start the stack with `docker compose up -d`. No new variable is required. If you used the dashboard, add the router from [Configuration](#configuration).

## Links

- [Traefik documentation](https://doc.traefik.io/traefik/)
- [Traefik Docker provider](https://doc.traefik.io/traefik/providers/docker/)
- [Traefik source code](https://github.com/traefik/traefik)
