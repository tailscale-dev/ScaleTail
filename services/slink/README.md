# Slink with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Slink](https://github.com/andrii-kryvoviaz/slink) with Tailscale as a sidecar container to securely manage and access your local file-sharing system over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you can ensure that your Slink instance is both secure and private, accessible only within your Tailscale network.

## Slink

[Slink](https://github.com/andrii-kryvoviaz/slink) is a fast, self-hosted alternative to ShareDrop, enabling secure, real-time file sharing over local networks. It allows you to easily share files between devices without relying on third-party servers, ensuring complete control and privacy. By combining Slink with Tailscale, this configuration provides a secure way to connect and share files exclusively within your private network.

## Configuration Overview

In this setup, the `tailscale-slink` service runs Tailscale, which manages secure networking for the Slink service. The `slink` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Slink's file-sharing interface is only accessible through the Tailscale network, adding an extra layer of security and privacy for your self-hosted file-sharing system.
