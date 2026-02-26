# Tracktor with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Tracktor** with a Tailscale sidecar container, enabling secure access to your self-hosted tracking and project management interface over your private Tailscale network. With this setup, your Tracktor instance remains **private and accessible only from authorized devices on your Tailnet**, keeping your data protected from public exposure.

## Tracktor

[**Tracktor**](https://github.com/javedh-dev/tracktor) is an open-source, self-hosted web application for comprehensive vehicle management. It provides a clean interface focused on clarity and usability, making it suitable for individuals, small teams, and homelab environments that require private and controlled access.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-tracktor`) runs the Tailscale client and joins your private Tailscale network. The main `tracktor` service uses:

```plain
network_mode: service:tailscale-tracktor
```

This configuration routes all traffic through the Tailscale interface, ensuring that the Tracktor web UI is accessible **only via your Tailscale network**.
