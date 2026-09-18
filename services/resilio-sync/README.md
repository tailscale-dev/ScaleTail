# Resilio Sync with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Resilio Sync](https://github.com/linuxserver/docker-resilio-sync) with Tailscale as a sidecar container to securely synchronize and share your files over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your file synchronization, ensuring that Resilio Sync is only accessible within your Tailscale network.

## Resilio Sync

[Resilio Sync](https://github.com/linuxserver/docker-resilio-sync) is a powerful, peer-to-peer file synchronization tool that allows you to sync files between devices or share them with others, without relying on cloud services. With its robust and flexible syncing capabilities, Resilio Sync is ideal for personal and professional use cases where secure, decentralized file sharing is required. This configuration leverages Tailscale to securely connect to your Resilio Sync instance, protecting your file transfers from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-resilio-sync` service runs Tailscale, which manages secure networking for the Resilio Sync service. The `resilio-sync` service uses the Tailscale network stack via Docker’s `network_mode: service:tailscale` configuration. This setup ensures that Resilio Sync is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your file synchronization and sharing tasks.
