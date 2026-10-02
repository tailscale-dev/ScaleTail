# Traefik with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Traefik](https://github.com/traefik/traefik) with Tailscale as a sidecar container to securely manage and route your traffic over a private Tailscale network. By integrating Tailscale, you can enhance the security and privacy of your Traefik instance, ensuring that access is restricted to devices within your Tailscale network.

## Traefik

[Traefik](https://github.com/traefik/traefik) is a modern, open-source reverse proxy and load balancer that simplifies the deployment and management of services in dynamic environments. It supports a wide range of integrations with container orchestration platforms and cloud providers, offering features like automatic HTTPS, load balancing, and monitoring. By incorporating Tailscale, your Traefik instance is safeguarded, ensuring that only authorized users and devices on your Tailscale network can access your applications and services.

## Configuration Overview

In this setup, the `tailscale-traefik` service runs Tailscale, which manages secure networking for Traefik. The `traefik_proxy` service uses Docker's `network_mode: service:tailscale` configuration. Traefik reads its static configuration from the `command:` flags in `compose.yaml`. Traefik ignores these flags when it finds a static configuration file, so edit the flags instead of adding a `traefik.yml` file.

The Traefik health check calls the ping endpoint, so keep the `--ping=true` flag. Traefik routes only to containers that Docker reports as healthy. The `simpleweb` sample therefore becomes reachable only after its first health check passes.

## Tailnet Access

Tailscale Serve listens on port 443 of the Tailnet address, terminates HTTPS, and forwards requests to Traefik's `web` entrypoint on port 80. Do not add a Traefik entrypoint on port 443. Traefik shares the network of the Tailscale container, so the port is already in use. Traefik then exits, and the container restarts in a loop.

Requests through the Tailnet arrive with the host name `<SERVICE>.<tailnet>.ts.net`. The sample routers match `traefik.domain.local` and `simpleweb.domain.local`, so Traefik answers `404` over the Tailnet. Change a `Host()` rule to the Tailnet name to reach that router through Tailscale Serve.

## Troubleshooting

Traefik writes its log to `./${SERVICE}-data/log/traefik.log`, so `docker logs app-traefik` stays empty. Read that file when the container restarts or a router does not work.
