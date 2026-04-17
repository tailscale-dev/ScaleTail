# AFFiNE with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [AFFiNE](https://github.com/toeverything/affine) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## AFFiNE

[AFFiNE](https://github.com/toeverything/affine) AFFiNE is an open-source, privacy-focused workspace that combines docs, whiteboards, and databases. A free Notion & Miro alternative for individuals and teams.

## Configuration Overview

In this setup, the `tailscale-AFFiNE` service runs Tailscale, which manages secure networking for AFFiNE. The `AFFiNE` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.