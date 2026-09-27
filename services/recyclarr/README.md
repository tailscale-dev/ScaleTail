# Recyclarr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Recyclarr** with a Tailscale sidecar container, allowing secure and private synchronization of quality profiles, custom formats, and media settings across your *Radarr* and *Sonarr* instances. With this setup, Recyclarr is **only reachable from within your Tailscale network**, keeping your media automation infrastructure fully private and protected.

## Recyclarr

[**Recyclarr**](https://github.com/recyclarr/recyclarr) is an automation tool designed to **synchronize TRaSH-Guides–based quality profiles and custom formats** to Radarr and Sonarr. Instead of manually configuring and maintaining complex quality rules, Recyclarr allows you to define everything declaratively in YAML and keep your media stack consistent and reproducible.

## Key Features

* ♻️ **TRaSH-Guides Integration** – Automatically syncs recommended quality profiles and custom formats.
* 📐 **Declarative Configuration** – Manage Radarr and Sonarr settings using simple YAML files.
* 🔄 **Consistent Media Rules** – Keep multiple Radarr/Sonarr instances aligned.
* 🧩 **Custom Format Management** – Automatically create, update, and score custom formats.
* 🧪 **Dry-Run Support** – Preview changes before applying them.
* 🐳 **Docker-Friendly** – Lightweight container designed for scheduled or on-demand runs.
* 🛠 **Automation-First** – Ideal for cron jobs, CI pipelines, or homelab orchestration.

## Why Self-Host?

Recyclarr requires **API access to Radarr and Sonarr**, which often exposes sensitive configuration details about your media infrastructure. By self-hosting Recyclarr and restricting access via Tailscale, you ensure:

* Your Radarr/Sonarr APIs are never exposed publicly
* All synchronization traffic stays inside your private network
* Remote management remains secure, even when traveling or managing multiple sites

This is especially valuable in homelabs, seedbox setups, or multi-location media deployments.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example, `tailscale-recyclarr`) runs the Tailscale client and joins your private Tailscale network. The Recyclarr service uses:

```plain
network_mode: service:tailscale
```

This setup ensures that **all Recyclarr traffic flows exclusively through the Tailscale interface**, allowing it to securely reach Radarr and Sonarr instances that are also on your Tailscale network. No ports need to be exposed, and the container remains completely inaccessible from the public Internet.

With this configuration, Recyclarr can safely automate and enforce your media quality standards across your entire media stack — privately, securely, and reproducibly.

## Volume Permissions

The Compose file runs Recyclarr as UID/GID `1000`. Docker creates missing bind-mount directories as `root:root`, and Recyclarr then exits with `Access to the path '/config/state' is denied`. Create the config directory before the first start:

```sh
mkdir -p recyclarr-data/config
sudo chown -R 1000:1000 recyclarr-data
```
