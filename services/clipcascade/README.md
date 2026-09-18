# ClipCascade with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [ClipCascade](https://github.com/Sathvik-Rao/ClipCascade) with Tailscale as a sidecar container to securely manage and access your clipboard history over a private Tailscale network. By integrating Tailscale, you can ensure that your ClipCascade instance remains private and accessible only to authorized devices on your Tailscale network.

## ClipCascade

[ClipCascade](https://github.com/Sathvik-Rao/ClipCascade) is a self-hosted, open-source clipboard manager that synchronizes and organizes clipboard history across devices. It offers features like an intuitive web interface, multi-device clipboard synchronization, and searchable history, making it an essential tool for productivity and seamless workflows. By leveraging Tailscale, your ClipCascade instance remains secure and accessible only to devices within your private network.

## Key Features

- **Multi-Device Sync**: Synchronize clipboard history across multiple devices.
- **Searchable History**: Easily search and retrieve past clipboard entries.
- **Self-Hosted Privacy**: Keep your clipboard data secure and private.
- **User-Friendly Interface**: Manage clipboard history through an intuitive web interface.

## Configuration Overview

In this setup, the `tailscale-clipcascade` service runs Tailscale, which manages secure networking for the ClipCascade service. The `clipcascade` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that ClipCascade’s web interface and functionality are only accessible through the Tailscale network (or locally, if preferred), providing enhanced privacy and security for managing your clipboard history.
