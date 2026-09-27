# Configarr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Configarr** with a Tailscale sidecar container, enabling secure and private management of configuration files for your *Radarr*, *Sonarr*, and broader media automation stack. With this setup, Configarr is **only accessible from within your Tailscale network**, keeping your configuration workflows fully private and under your control.

## Configarr

[**Configarr**](https://github.com/raydak-labs/configarr) is a configuration management tool designed to **declaratively manage and synchronize settings** for Radarr, Sonarr, and related media services. By defining your desired state in version-controlled YAML files, Configarr ensures your media applications remain consistent, reproducible, and easy to maintain.

## Key Features

* ⚙️ **Declarative Configuration Management** – Define Radarr and Sonarr settings in YAML.
* 🔁 **Idempotent Syncing** – Apply configurations safely and repeatedly without drift.
* 📦 **Multi-Instance Support** – Manage multiple Radarr/Sonarr instances from a single config.
* 🧩 **Profile & Root Folder Management** – Keep paths, profiles, and settings aligned.
* 🛠 **Automation-Friendly** – Ideal for cron jobs, CI pipelines, or GitOps-style workflows.
* 🧪 **Dry-Run Mode** – Preview configuration changes before applying them.
* 🐳 **Docker-Native** – Lightweight and easy to deploy in containerized environments.

## Why Self-Host?

Configarr requires **API access to Radarr and Sonarr**, exposing configuration and library metadata that should not be publicly reachable. By self-hosting Configarr behind Tailscale, you gain:

* Private, encrypted access to all Radarr/Sonarr APIs
* No need to expose management endpoints to the public Internet
* Secure remote configuration management across locations

This is especially useful for homelabs, shared servers, and environments where consistent configuration and security are critical.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example, `tailscale-configarr`) runs the Tailscale client and joins your private Tailscale network. The Configarr service uses:

```plain
network_mode: service:tailscale
```

This setup ensures that **all Configarr network traffic flows exclusively through the Tailscale interface**, allowing it to securely communicate with Radarr and Sonarr instances that are also connected via Tailscale. No ports need to be exposed, and the service remains completely inaccessible from the public Internet.

The Configarr container runs one sync and then exits, so the Compose file uses `restart: "no"`. To run it on a schedule, trigger `docker compose up application` from cron or another scheduler.

With this configuration, Configarr can safely enforce and maintain your desired media configuration state — privately, securely, and reproducibly.
