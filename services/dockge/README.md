# Dockge with Tailscale Sidecar Configuration

This Docker Compose configuration sets up Dockge with a Tailscale sidecar container, enabling secure, private access to your Docker Compose management UI over your Tailnet. With this setup, your Dockge instance is not exposed to the public internet and is only accessible from authorized devices connected via Tailscale.

## Dockge

[Dockge](https://github.com/louislam/dockge) is a lightweight, self-hosted Docker Compose stack manager built for simplicity and control. Created by the developer behind Uptime Kuma, Dockge provides an intuitive web interface for managing, editing, and deploying docker-compose.yml stacks without relying solely on the CLI.

It is especially well-suited for homelabs, self-hosted environments, and DevOps workflows where multiple services are managed via Docker Compose.

## Key Features

* 🐳 Web-based Docker Compose stack management
* ✏️ Live editing of docker-compose.yml files
* ▶️ One-click start, stop, and restart of stacks
* 📜 Real-time container logs viewer
* 📦 Multi-stack organization via directories
* ⚡ Lightweight and fast interface
* 🔍 Clear visibility into container status

## Important Notice

Make sure to populate the `STACKS_DIR=` variable in the `.env` before first startup.
