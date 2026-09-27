# Audiobookshelf with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Audiobookshelf](https://github.com/advplyr/audiobookshelf) with Tailscale as a sidecar container to securely access and manage your audiobook and podcast library over a private Tailscale network. By integrating Tailscale, you can ensure that your Audiobookshelf instance remains private and accessible only to devices within your Tailscale network.

## Audiobookshelf

[Audiobookshelf](https://github.com/advplyr/audiobookshelf) is an open-source self-hosted application for managing and streaming audiobooks and podcasts. It offers features like multi-user support, playback progress sync, a web player, and mobile app integrations, making it easy to organize and enjoy your audiobook and podcast collection from anywhere. By adding Tailscale, you can protect your library from unauthorized access while maintaining seamless and secure connectivity for all your devices.

## Configuration Overview

In this setup, the `tailscale-audiobookshelf` service runs Tailscale, which manages secure networking for the Audiobookshelf service. The `audiobookshelf` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Audiobookshelf’s web interface and streaming capabilities are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your personal audiobook and podcast collection.
