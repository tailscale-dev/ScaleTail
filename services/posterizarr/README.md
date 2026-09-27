# Posterizarr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Posterizarr** with a Tailscale sidecar container, enabling secure and private access to your automated poster and artwork management service for *Radarr* and *Sonarr*. With this setup, Posterizarr is **only accessible from within your Tailscale network**, keeping your media automation environment clean, private, and secure.

## Posterizarr

[**Posterizarr**](https://github.com/fscorrupt/Posterizarr) is a companion tool for Radarr and Sonarr that **automatically manages posters, backgrounds, and other artwork** based on predefined rules. It ensures a consistent visual style across your media library by automatically applying selected poster sources, resolutions, languages, and artwork types.

## Key Features

* 🖼 **Automated Poster Management** – Automatically updates posters and artwork for movies and series.
* 🎨 **Consistent Library Aesthetics** – Enforce a uniform look across Radarr and Sonarr.
* 🔧 **Rule-Based Configuration** – Define poster sources, languages, resolutions, and priorities.
* 🔄 **Scheduled Syncing** – Periodically checks and updates artwork automatically.
* 📡 **Radarr & Sonarr Integration** – Uses official APIs to manage media artwork.
* 🐳 **Docker-Native** – Lightweight container designed for easy self-hosting.
* 🧩 **Multi-Instance Support** – Manage artwork across multiple Radarr/Sonarr instances.

## Why Self-Host?

Posterizarr requires **API access to Radarr and Sonarr**, which exposes metadata and library structure details. Self-hosting Posterizarr behind Tailscale ensures:

* Radarr and Sonarr APIs are not publicly exposed
* Poster and artwork management stays inside your private network
* Secure remote management without opening firewall ports

This approach is ideal for homelabs, media servers, and multi-location setups where privacy and security matter.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example, `tailscale-posterizarr`) runs the Tailscale client and connects to your private Tailscale network. The Posterizarr service uses:

```plain
network_mode: service:tailscale
```

This configuration ensures that **all Posterizarr traffic is routed exclusively through the Tailscale interface**, allowing it to securely communicate with Radarr and Sonarr instances over your private network. No ports are exposed to the public Internet, and the service remains fully isolated.

With this setup, Posterizarr can reliably enforce consistent artwork standards across your media library — securely, privately, and automatically.

## Volume Permissions

The Compose file runs Posterizarr as UID/GID `1000`. Docker creates missing bind-mount directories as `root:root`, and Posterizarr then fails with `Permission denied: '/config/database'`. Create the data directories before the first start:

```sh
mkdir -p posterizarr-data/config posterizarr-data/assets posterizarr-data/assetsbackup posterizarr-data/manualassets
sudo chown -R 1000:1000 posterizarr-data
```
