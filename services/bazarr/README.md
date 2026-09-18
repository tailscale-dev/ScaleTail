# Bazarr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Bazarr](https://github.com/morpheus65535/bazarr) with Tailscale as a sidecar container to securely manage and access your subtitle management system over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Bazarr instance, ensuring that it is only accessible within your Tailscale network.

## Bazarr

[Bazarr](https://github.com/morpheus65535/bazarr) is an open-source, self-hosted application for managing and downloading subtitles for your movies and TV shows. It works in conjunction with other media managers like Sonarr and Radarr to automatically search for and download subtitles from various sources. This configuration leverages Tailscale to securely connect to your Bazarr instance, ensuring that your subtitle management interface is protected from unauthorized access and that your instance is accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the tailscale-bazarr service runs Tailscale, which manages secure networking for the Bazarr service. The bazarr service uses the Tailscale network stack via Docker's network_mode: service:tailscale configuration. This setup ensures that Bazarr’s web interface and API are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted subtitle manager.
