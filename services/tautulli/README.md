# Tautulli with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Tautulli for Docker](https://hub.docker.com/r/linuxserver/tautulli) with Tailscale as a sidecar container to securely monitor and manage your Plex Media Server over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you enhance the security and privacy of your Tautulli installation, ensuring that it is only accessible within your Tailscale network.

## Tautulli

[Tautulli](https://tautulli.com/) is a popular monitoring and analytics tool for Plex Media Server. It provides detailed insights into your server’s activity, including media consumption, user activity, and server health. Tautulli allows you to generate reports, send notifications, and manage users, making it an essential tool for Plex server administrators. This configuration leverages Tailscale to securely connect to your Tautulli interface, protecting your server's monitoring data from unauthorized access.

## Configuration Overview

In this setup, the tailscale-tautulli service runs Tailscale, which manages secure networking for the Tautulli service. The tautulli service utilizes the Tailscale network stack via Docker's network_mode: service:tailscale configuration. This setup ensures that Tautulli’s monitoring interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your Plex server monitoring and management.
