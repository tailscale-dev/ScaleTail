# Swing Music with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Swing Music** with a Tailscale sidecar container, enabling secure access to your self-hosted music streaming server over your private Tailscale network. With this setup, your Swing Music instance remains **private and accessible only from authorized devices on your Tailnet**.

## Swing Music

[**Swing Music**](https://github.com/swingmx/swingmusic) is a fast, beautiful, self-hosted music player and streaming server for your **local audio collection**. It offers a modern browser-based interface to browse, search, and stream your own music—without relying on third-party cloud services or exposing your library publicly.

## Key Features

- 🎧 **Daily Mixes** – Automatically generated mixes based on your listening habits.
- 🎼 **Local Music Streaming** – Stream your own audio files directly from your server.
- 🧹 **Metadata Normalization** – Keeps your music library clean and consistent.
- 💿 **Album Version Grouping** – Smart grouping of deluxe, remastered, or alternate album versions.
- 🧭 **Related Artists & Albums** – Discover similar music within your own library.
- 📁 **Folder-Based Browsing** – Explore your collection by folder structure.
- 📝 **Playlist Management** – Create and manage playlists from the web interface.
- ✨ **Modern Web UI** – Clean, fast, and responsive interface for desktop and mobile browsers.
- 🔎 **Fuzzy Search & Duplicate Detection** – Quickly find music and handle duplicates.

## Why Self-Host?

Self-hosting Swing Music gives you **full ownership of your music library**, complete privacy, and independence from subscription-based streaming services. When paired with Tailscale, your music server is never exposed to the public internet, yet remains securely accessible from anywhere.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-swingmusic`) runs the Tailscale client and joins your private Tailscale network. The main `swingmusic` service uses:

```plain
network_mode: service:tailscale-swingmusic
```

This configuration routes all traffic through the Tailscale interface, ensuring the Swing Music web UI and streaming endpoints are accessible **only via your Tailscale network**. This keeps your music library secure while allowing seamless access from all your trusted devices.
