# Plex with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Plex Media Server](https://hub.docker.com/r/linuxserver/plex) with Tailscale as a sidecar container to securely manage and stream your media over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your media server, ensuring that it is only accessible within your Tailscale network.

## Plex Media Server

[Plex Media Server](https://hub.docker.com/r/linuxserver/plex) is a versatile platform for organizing and streaming your personal media collection, including movies, TV shows, music, and photos. Plex makes it easy to access your media from any device, both locally and remotely, with a user-friendly interface and extensive device support. This configuration leverages Tailscale to securely connect to your Plex server, protecting your media streams from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-plex` service runs Tailscale, which manages secure networking for the Plex Media Server. The `plex` service utilizes the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that Plex's media streaming service is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your media server.
