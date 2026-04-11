# FlareSolverr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up FlareSolverr with Tailscale as a sidecar container to securely manage and route traffic for your Cloudflare bypass proxy over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security of your FlareSolverr instance, ensuring that its API is only accessible within your Tailscale network.

## FlareSolverr

FlareSolverr is an open-source proxy server to bypass Cloudflare and other anti-bot protections. It acts as a transparent bridge between your media automation tools (like Prowlarr or Jackett) and indexers that use Cloudflare, silently solving browser challenges in the background. This configuration leverages Tailscale to securely connect to your FlareSolverr API, ensuring that the proxy endpoint is protected from unauthorized access and that your instance is only accessible via your private Tailscale network.

## Configuration Overview

In this setup, the tailscale-flaresolverr service runs Tailscale, which manages secure networking for the FlareSolverr service. The flaresolverr service uses the Tailscale network stack via Docker's network_mode: service: configuration. This setup ensures that FlareSolverr’s API (typically running on port 8191) is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted anti-bot proxy.
