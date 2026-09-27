# Linkding with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Linkding](https://github.com/sissbruecker/linkding) with Tailscale as a sidecar container to securely manage and access your self-hosted bookmark manager over a private Tailscale network. By integrating Tailscale, you can ensure that your Linkding instance remains private and accessible only to authorized devices on your Tailscale network.

## Linkding

[Linkding](https://github.com/sissbruecker/linkding) is a lightweight, self-hosted bookmark manager designed to simplify saving and organizing links. It supports features like tagging, searching, and bookmark importing/exporting. It also includes a browser extension for quick access and management. With Tailscale, your Linkding instance is safeguarded, ensuring that your bookmarks are only accessible to you and authorized users within your private network.

## Key Features

- **Tagging and Search**: Organize and find bookmarks effortlessly with tags and a robust search feature.
- **Browser Integration**: Quickly save and manage bookmarks via browser extensions.
- **Self-Hosted Privacy**: Keep your bookmarks secure and private with a locally hosted solution.
- **Import/Export**: Easily migrate bookmarks to and from other services.

## Configuration Overview

In this setup, the `tailscale-linkding` service runs Tailscale, which manages secure networking for the Linkding service. The `linkding` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Linkding’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing enhanced privacy and security for managing your bookmarks.
