# Homebox with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Homebox** with a Tailscale sidecar container, enabling secure access to your self-hosted inventory and asset management system over your private Tailscale network. With this setup, your Homebox instance remains **private and accessible only from authorized devices on your Tailnet**, keeping inventory data and asset metadata protected from public exposure.

## Homebox

[**Homebox**](https://github.com/sysadminsmedia/homebox) is an open-source, self-hosted home inventory and asset management application developed by SysAdmins Media. It allows you to catalog items, assign them to locations, track quantities, warranties, purchase details, and custom metadata through a clean and intuitive web interface.

Homebox is well suited for homelabs, workshops, offices, and households that want a lightweight but structured way to manage physical assets without relying on third-party SaaS platforms.

## Key Features

- 📦 **Item Inventory** – Track items with names, descriptions, quantities, and images
- 📍 **Location Management** – Organize assets by rooms, racks, shelves, or custom locations
- 🏷️ **Custom Fields & Metadata** – Extend items with your own structured data
- 🧾 **Warranty & Purchase Tracking** – Store purchase dates, vendors, and warranty details
- 🔍 **Search & Filtering** – Quickly find items across large inventories
- 👥 **Multi-User Support** – Share access with trusted users
- 🐳 **Docker-Friendly** – Designed for containerized deployments
- 📦 **Open Source** – Fully self-hosted with no external dependencies

## Why Self-Host?

Inventory and asset data often reflects **physical security, infrastructure layout, and ownership details**. Self-hosting Homebox ensures full control over this information, eliminates dependency on cloud services, and allows deployment in restricted or offline environments.

When combined with Tailscale, Homebox becomes a **secure, Tailnet-only inventory system** that is reachable from anywhere you need it, without exposing ports or services to the public internet.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-homebox`) runs the Tailscale client and joins your private Tailscale network. The main `homebox` service uses:

```plain
network_mode: service:tailscale
```

This configuration routes all inbound and outbound traffic through the Tailscale interface, ensuring that the Homebox web UI and API are accessible **only via your Tailscale network**. No public port exposure is required unless explicitly configured.

Homebox listens internally on port **7745**, which is the port that should be referenced if Tailscale Serve is enabled.

## Volume Permissions

Homebox stores all persistent data under `/data` inside the container. When using bind mounts, the host directory **must be pre-created with the correct ownership**, otherwise Docker will create it as `root:root`, which will cause permission issues when running the container as a non-root user.

Before starting the stack, ensure the data directory is owned by UID/GID `65532`:

```plain
chown 65532:65532 homebox-data/
```

This is especially important when using the rootless or hardened Homebox images and when running the service with:

```plain
user: 65532:65532
```
