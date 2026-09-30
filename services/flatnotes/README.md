# Flatnotes with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **[Flatnotes](https://github.com/dullage/flatnotes)** with Tailscale as a sidecar container to securely manage and access your self-hosted note-taking application over a private Tailscale network. By integrating Tailscale, you can ensure that your Flatnotes instance remains private and accessible only to authorized devices within your Tailscale network.

## Flatnotes

[Flatnotes](https://github.com/dullage/flatnotes) is a **lightweight, self-hosted note-taking app** that stores notes in plain text Markdown files. With a simple yet powerful interface, Flatnotes offers **tag-based organization**, **full-text search**, and a **distraction-free writing experience**. By integrating Tailscale, you can keep your notes private and secure, ensuring that only trusted devices can access them.

## Key Features

- **Markdown-Based Notes** – Write and store notes in Markdown format for flexibility.
- **Tag-Based Organization** – Easily categorize and manage notes with tags.
- **Full-Text Search** – Quickly find notes with an efficient search function.
- **Self-Hosted Privacy** – Keep full control of your data without relying on third-party services.
- **Secure Access with Tailscale** – Restrict access to only authorized devices within your private network.

## Configuration Overview

In this setup, the `tailscale-flatnotes` service runs Tailscale, which manages secure networking for the Flatnotes service. The `flatnotes` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Flatnotes’ web interface and note storage are only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy for managing your notes.
