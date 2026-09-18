# Arcane with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Arcane** with a Tailscale sidecar container, enabling secure access to your self-hosted Docker management interface over your private Tailscale network. With this setup, your Arcane instance remains **private and accessible only from authorized devices on your Tailnet**, keeping your Docker environment and operations shielded from public exposure.

## Arcane

[**Arcane**](https://getarcane.app/docs) is an open-source, self-hosted platform for **Docker container and Compose stack management** with a modern web interface. It allows users to manage containers, images, networks, volumes, remote environments, and projects—all without needing to rely on the Docker CLI. Arcane makes container operations approachable while providing powerful features for both homelab and production use.

## Key Features

* 🐳 **Containers** – Start, stop, inspect, and monitor containers from a unified web UI.
* 📦 **Images** – List, pull, and manage container images.
* 🌐 **Networks** – View and create Docker networks with driver and subnet information.
* 🗂 **Projects** – Manage Docker Compose stacks as first-class resources, with a Projects UI and Git syncing.
* 🔄 **Remote Environments** – Control containers on other hosts using Arcane Agents.
* 💾 **Volumes** – Browse and manage Docker volumes.
* 🧰 **Templates & Guides** – Built-in support for templates and guides to streamline deployment patterns.
* 🔐 **Extensible Configuration** – Support for environment variables, OIDC single sign-on, notifications, HTTP proxies, and analytics.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-arcane`) runs the Tailscale client and joins your private Tailscale network. The main `arcane` service uses:

```plain
network_mode: service:tailscale
```

This configuration routes all traffic through the Tailscale interface, ensuring that the Arcane web UI and API are accessible **only via your Tailscale network**. This provides a simple and secure way to access your Docker management console from all trusted devices while preventing public access to container controls.

## Default Credentials

* Username: `arcane`
* Password: `arcane-admin`
