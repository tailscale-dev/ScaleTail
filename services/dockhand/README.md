# Dockhand with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Dockhand** with a Tailscale sidecar container, enabling secure access to your self-hosted Docker management interface over your private Tailscale network. With this setup, your Dockhand instance remains private and accessible only from authorized devices on your Tailnet, ensuring that container management and infrastructure controls are never exposed to the public internet.

## Dockhand

[**Dockhand**](https://github.com/Finsys/dockhand) is a modern, lightweight Docker management UI focused on real-time container operations and multi-environment orchestration. It provides an intuitive interface for managing containers, images, volumes, networks, and Docker Compose stacks across local or remote Docker hosts.

Dockhand is designed for operators and homelab environments that want a clean, responsive alternative to heavier container management platforms, while still retaining full control over their infrastructure.

## Key Features

- Container Management – Start, stop, restart, and inspect containers in real time.
- Compose Stack Support – Deploy and manage Docker Compose applications.
- Multi-Environment Support – Connect to and manage multiple Docker hosts.
- Live Logs & Terminal – Stream logs and access container terminals directly from the UI.
- File & Volume Access – Inspect volumes and container file systems.
- Git-Based Deployments – Deploy stacks from Git repositories with optional sync.
- Docker-Native – Built specifically for Docker environments.
- Open Source – Community-driven and self-hostable.

## Why Self-Host?

A Docker management interface has full control over your infrastructure. Exposing such a tool publicly significantly increases risk, as it can allow attackers to manipulate containers, access secrets, or pivot deeper into your network.

Self-hosting Dockhand ensures that you maintain full ownership and operational control. When combined with Tailscale, Dockhand becomes a secure, private control plane for your Docker environments, accessible only from authenticated devices within your Tailnet. This dramatically reduces the attack surface while preserving remote management convenience.

## Configuration Overview

In this deployment, a Tailscale sidecar container (for example `tailscale-dockhand`) runs the Tailscale client and joins your private Tailscale network. The main `dockhand` service uses:

```plain
network_mode: service:tailscale-dockhand
```

This configuration routes all inbound and outbound traffic through the Tailscale interface, ensuring that the Dockhand web interface and Docker API interactions are accessible only via your Tailscale network.

By avoiding public port mappings and relying exclusively on Tailnet access, you create a secure-by-default Docker management setup suitable for homelabs, remote infrastructure, and internal DevOps environments.
