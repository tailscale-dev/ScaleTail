# Memos with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Memos** with a Tailscale sidecar container, allowing you to securely access your personal knowledge base over your private Tailnet without exposing it to the public internet.

## Memos

[Memos](https://github.com/usememos/memos) is a lightweight, open-source note-taking and knowledge management platform designed for capturing quick thoughts, ideas, and daily logs. It combines the simplicity of a personal notebook with the structure of a self-hosted knowledge base, making it ideal for developers, operators, and individuals who want full control over their notes.

By pairing Memos with Tailscale, you ensure that your notes remain private and accessible only to authorized devices on your Tailnet, eliminating the need for public exposure or complex reverse proxy setups.

## Configuration Overview

In this setup, the `tailscale-memos` service runs Tailscale and manages secure networking. The `memos` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale-memos` configuration. This ensures that Memos is only accessible through your Tailnet unless you explicitly expose ports.

## Files to check

Please verify the following before starting:

- `.env` // Must include `TS_AUTHKEY` for Tailscale authentication

## Resources

- Official Repository: <https://github.com/usememos/memos>
- Documentation: <https://usememos.com/docs>
