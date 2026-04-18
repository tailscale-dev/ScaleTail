# Transmute with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Transmute** with a Tailscale sidecar container, allowing you to securely access your instance over your private Tailnet. With this setup, Transmute remains private by default and is only accessible from devices authenticated to your Tailscale network.

## Transmute

[**Transmute**](https://github.com/transmute-app/transmute) is an open-source file conversion and transformation service designed to handle a wide variety of document, media, and data format conversions through a clean API and web interface. It is particularly useful for workflows that require automated or repeatable transformations between formats.

Running Transmute behind Tailscale ensures that your file processing pipelines and potentially sensitive data remain secure, without exposing the service publicly.

## Key Features

- Convert files between multiple formats (documents, images, and more)
- API-first design for automation and integrations
- Web interface for manual conversions
- Lightweight and container-friendly deployment
- Self-hosted with full control over your data

## Configuration Overview

In this setup, the `tailscale-transmute` service runs Tailscale and manages secure connectivity to your Tailnet. The `transmute` container shares the same network stack using Docker’s `network_mode: service:tailscale-transmute`.

## Service Notes / Gotchas

- Some conversions may require additional system dependencies depending on formats used
- Initial startup may take longer if Transmute initializes processing tools
- Ensure sufficient CPU and memory for heavy conversions

## Useful Links

- GitHub Repository: <https://github.com/transmute-app/transmute>
- Tailscale Auth Keys: <https://tailscale.com/kb/1085/auth-keys>
- Tailscale Serve Docs: <https://tailscale.com/kb/1242/tailscale-serve>
