# Gitea with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Gitea](https://gitea.com/) with Tailscale as a sidecar container, enabling secure access to your self-hosted Git forge via your private Tailnet. With this setup, your Gitea instance remains fully private and accessible only from authorized Tailscale devices.

## Gitea

[Gitea](https://gitea.com/) is a lightweight, self-hosted Git service that provides repository hosting, pull requests, issue tracking, and more. It is designed for easy deployment and minimal operational overhead, making it a great choice for private Git hosting on homelabs and small teams.

## Key Features

* **Lightweight Deployment** – Runs smoothly on nearly any machine, from Raspberry Pi to cloud instances.
* **Repository Management** – Full Git repository hosting with web interface.
* **Collaboration Tools** – Pull requests, issues, and wiki support for team collaboration.
* **Self-Hosted** – Complete control over your code and data.
* **Private by Default with Tailscale** – Secured with Tailscale, accessible only to your authorized devices.

## Configuration Overview

In this deployment, the `tailscale-gitea` service runs the Tailscale client to establish a secure private network. The `gitea` container uses `network_mode: service:tailscale-gitea` to route all traffic through the Tailscale interface. This ensures your Git service, web interface, and API endpoints are only accessible via Tailscale, preventing public exposure while still offering seamless remote access to your team.
