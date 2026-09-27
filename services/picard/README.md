# MusicBrainz Picard with Tailscale Sidecar Configuration

This Docker Compose setup deploys **MusicBrainz Picard** alongside a **Tailscale sidecar container**, allowing secure access to your self-hosted music tagging and metadata management environment over your private **Tailscale network**. With this setup, Picard remains **private and reachable only from trusted devices within your Tailnet**, ensuring your media metadata library stays secure and isolated from the public internet.

## MusicBrainz Picard

[**MusicBrainz Picard**](https://picard.musicbrainz.org/) is the official cross-platform tag editor from [MusicBrainz](https://musicbrainz.org/). It uses the community-maintained MusicBrainz database to identify, tag, and organize your music files with accurate and rich metadata — including artist information, album art, release data, and more.

Picard supports a wide range of audio formats and integrates powerful plugins to streamline batch processing, fingerprinting (via AcoustID), and custom tagging workflows.

## Key Features

- 🎵 **Accurate Tagging** – Automatically identify and tag music files using MusicBrainz metadata.
- 🧠 **AcoustID Matching** – Use audio fingerprints to detect and tag tracks even without metadata.
- 🖼️ **Album Art Integration** – Fetch and embed high-quality cover art automatically.
- ⚙️ **Plugin Support** – Extend functionality with community or custom plugins.
- 📁 **Batch Processing** – Organize entire libraries with flexible renaming and folder rules.
- 🐳 **Docker-Ready** – Simple to deploy and run in containers.
- 🔐 **Private Access via Tailscale** – Keep your tagging environment accessible only on your Tailnet.
- 📦 **Open Source** – Actively maintained and community-driven.

## Why Self-Host?

When you manage large local music libraries, you may prefer **full privacy and control** over which metadata services your files connect to. Self-hosting Picard behind Tailscale offers:

- No exposure of ports to the public internet.  
- Private access to your tagging environment from any authorized Tailscale device.  
- A streamlined tagging workflow fully contained within your home media infrastructure.

With this setup, your tagging process is secured and contained — perfect for privacy-conscious audiophiles and homelab enthusiasts.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-picard`) connects your Picard instance to your private Tailnet. The main `picard` container uses:

```plain
network_mode: service:tailscale
```

This means all Picard traffic — web interface, plugin updates, and library calls — travels securely through Tailscale.
