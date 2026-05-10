# Pulse with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Pulse](https://hub.docker.com/r/rcourtman/pulse) with Tailscale as a sidecar so the dashboard is reachable only over your Tailnet at `https://pulse.<tailnet-name>.ts.net`.

## Pulse

Pulse is a modern, unified dashboard for monitoring your infrastructure across Proxmox, Docker, and Kubernetes. It consolidates metrics, alerts, and AI-powered insights from all your systems into a single interface, aimed at homelabs, sysadmins, and MSPs who want a "single pane of glass" without the complexity of an enterprise monitoring stack.

## Configuration Overview

The `tailscale-pulse` service runs the Tailscale client to join your Tailnet. The application service uses `network_mode: service:tailscale`, so Pulse listens on TCP `7655` inside the Tailscale container's network namespace and Tailscale Serve proxies HTTPS `443` → `127.0.0.1:7655`. `AllowFunnel` is `false`; the dashboard is **never** exposed to the public internet from this configuration.

## Setup

1. Clone the repository and navigate to the service directory:

   ```bash
   git clone https://github.com/tailscale-dev/ScaleTail.git
   cd ScaleTail/services/pulse
   ```

2. Edit `.env` and paste your Tailscale auth key into `TS_AUTHKEY=`.

3. Pre-create the data directories so Docker does not create them as `root`:

   ```bash
   mkdir -p pulse-data ts/state
   ```

4. Start the stack:

   ```bash
   docker compose up -d
   ```

5. Open `https://pulse.<tailnet-name>.ts.net` from any Tailnet peer.

## Notes

- Pulse stores its state (Proxmox/Docker/Kubernetes credentials, alert rules, cached metrics) in `./pulse-data` mounted at `/data`. Treat this directory like a secrets vault — it contains tokens used to query your infrastructure.
- The original upstream `docker run` uses `-p 7655:7655` to bind the port to all host interfaces. In this configuration that direct port mapping is intentionally **not** used — access is via Tailnet only. Uncomment the `ports:` block in `compose.yaml` only if you also want LAN access from non-Tailnet devices.
- The upstream image's restart policy is `unless-stopped`; this configuration uses `restart: always` to match the rest of the ScaleTail catalog.

## Useful Links

- [rcourtman/pulse on Docker Hub](https://hub.docker.com/r/rcourtman/pulse)
- [Tailscale Serve docs](https://tailscale.com/kb/1242/tailscale-serve)
- [Tailscale Docker guide](https://tailscale.com/blog/docker-tailscale-guide)
