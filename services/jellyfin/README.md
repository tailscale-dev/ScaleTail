# Jellyfin with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Jellyfin](https://github.com/jellyfin/jellyfin) with Tailscale as a sidecar container to securely manage and access your media server over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Jellyfin instance, ensuring that it is only accessible within your Tailscale network.

## Jellyfin

[Jellyfin](https://github.com/jellyfin/jellyfin) is an open-source, self-hosted media server that allows you to manage and stream your media collection, including movies, TV shows, music, and more, to various devices. It provides a rich user interface and supports multiple clients, making it a powerful alternative to other media server solutions. This configuration leverages Tailscale to securely connect to your Jellyfin instance, ensuring that your media server interface is protected from unauthorized access and that your instance is accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the tailscale-jellyfin service runs Tailscale, which manages secure networking for the Jellyfin service. The jellyfin service uses the Tailscale network stack via Docker's network_mode: service:tailscale configuration. This setup ensures that Jellyfin’s web interface and API are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted media server.
