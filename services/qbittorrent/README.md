# qBittorrent with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [qBittorrent](https://www.qbittorrent.org/) with Tailscale as a sidecar container to securely manage and access your torrent client over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your qBittorrent instance, ensuring that it is only accessible within your Tailscale network.

## qBittorrent

[qBittorrent](https://www.qbittorrent.org/) is an open-source, cross-platform torrent client that offers a clean interface, powerful search capabilities, and support for most features found in modern BitTorrent clients. This configuration leverages Tailscale to securely connect to your qBittorrent instance, ensuring that your torrent management interface is protected from unauthorized access and that your instance is accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the tailscale-qbittorrent service runs Tailscale, which manages secure networking for the qBittorrent service. The qbittorrent service uses the Tailscale network stack via Docker's network_mode: service:tailscale configuration. This setup ensures that qBittorrent’s web interface and API are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted torrent client.
