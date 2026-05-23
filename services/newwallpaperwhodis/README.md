# NewWallpaperWhoDis with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [NewWallpaperWhoDis](https://github.com/upioneer/NewWallpaperWhoDis) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## NewWallpaperWhoDis

[NewWallpaperWhoDis](https://github.com/upioneer/NewWallpaperWhoDis) is the ultimate self-hosted wallpaper manager that turns any endpoint into a Smart Display with dynamic, zero-maintenance wallpapers. Operating on a "flat file" architecture, it allows you to manage collections simply by dropping images into a directory, auto-syncing, and serving them via GPU-accelerated Web Players. 

Pairing it with Tailscale allows you to securely access the Web UI from anywhere to manage your endpoints and rotation profiles. You can also reliably serve dynamic wallpapers to smart TVs or tablets across remote physical locations purely over your private Tailnet without having to open ports or expose a public reverse proxy.

## Configuration Overview

In this setup, the `tailscale-NewWallpaperWhoDis` service runs Tailscale, which manages secure networking for NewWallpaperWhoDis. The `NewWallpaperWhoDis` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## What to document for users

- Prerequisites: A standard Docker/Docker Compose environment. No special hardware passthrough or GPU/video/render groups are required. 
- Volumes: Make sure you update `compose.yaml` to include bind mounts for `./data:/app/data` and `./wallpapers:/app/wallpapers` to persist the database cache and your image files respectively.
- MagicDNS/Serve: By default, NewWallpaperWhoDis runs on internal port `3000` inside the container. Make sure the Tailscale reverse proxy configuration (`ts-serve` config block) in `compose.yaml` is pointing to `"Proxy":"http://127.0.0.1:3000"` (which maps the application inside the shared network namespace).
- Ports: If you want to access the Web UI from legacy devices on your local LAN that do not have Tailscale installed, uncomment the `ports` mapping in the `tailscale` service of `compose.yaml` and ensure `SERVICEPORT=6767` is set in your `.env` file. This maps port `6767` on the host to the shared port `3000` inside the Tailscale container. Otherwise, leave it disabled for Tailnet-only access.

- Service-specific gotchas: 
  - **Flat-File Sync:** You don't have to upload images in the web UI. You can drag and drop files directly into the `./wallpapers` folder via Windows Explorer, SMB, or FTP and the background Auto Sync crawler will automatically discover and ingest them.
  - **Proxmox LXC Crash:** If deploying in an unprivileged Proxmox LXC container, you may experience a `net.ipv4.ip_unprivileged_port_start` permission denied error on boot due to a containerd.io AppArmor compatibility bug. You may need to downgrade containerd.io or adjust your LXC container profiles.
- Links: 
  - [NewWallpaperWhoDis Webpage](https://newwallpaperwhodis.web.app/)
  - [GitHub Repository](https://github.com/upioneer/NewWallpaperWhoDis)

## Files to check

n/a
