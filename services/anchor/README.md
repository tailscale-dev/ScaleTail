# Anchor with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Anchor](https://github.com/ZhFahim/anchor) with Tailscale as a sidecar container so your notes stay reachable only over your Tailnet instead of being exposed to the public internet.

## Anchor

[Anchor](https://github.com/ZhFahim/anchor) is an offline-first, self-hostable note-taking application focused on speed, privacy, and reliability across web and mobile. It stores notes locally, syncs changes across devices when online, and supports features like rich text editing, attachments, tagging, sharing, and optional OIDC authentication. Pairing Anchor with Tailscale is a strong fit when you want private access to your notes from anywhere without putting the app behind a public reverse proxy.

## Key Features

- Offline-first note-taking with automatic sync when devices reconnect
- Clean, fast web and mobile interface with rich text editing
- Support for attachments, tags, and note organization
- Optional sharing capabilities for collaboration
- OIDC authentication support (Authelia, Authentik, Keycloak, Pocket ID, etc.)
- Self-hosted and privacy-focused with full data ownership
- Works seamlessly with Tailscale for private, secure remote access

## Configuration Overview

In this setup, the `tailscale-anchor` service runs Tailscale and manages secure networking for Anchor. The `anchor` service shares that network stack via Docker's `network_mode: service:` configuration, which keeps the app private to your Tailnet unless you intentionally add host port mappings or funnel it through another public entrypoint.

## Upstream documentation

- [Anchor GitHub repository](https://github.com/ZhFahim/anchor)
- [Anchor OIDC configuration](https://github.com/ZhFahim/anchor#oidc-authentication)

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variable `TS_AUTHKEY`
