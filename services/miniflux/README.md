# Miniflux with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Miniflux](https://github.com/miniflux/v2) with Tailscale as a sidecar container, enabling secure access to your minimalist feed reader over a private Tailscale network. With this setup, your Miniflux instance remains fully private and accessible only from authorized devices.

## Miniflux

[Miniflux](https://miniflux.app/) is a minimalist and opinionated feed reader. It is designed to be fast, simple, and efficient, supporting RSS, Atom, and JSON feeds. Miniflux is focused on reading and offers a clean, distraction-free user interface.

## Key Features

* **Minimalist Design** – Focused purely on readability and efficiency.
* **Fast & Lightweight** – Written in Go, ensuring high performance and low resource usage.
* **Feed Support** – Supports RSS, Atom, and JSON feeds.
* **Privacy Focused** – Removes pixel trackers and ads from articles.
* **Self-Hosted** – Keep full control of your reading data.
* **Private by Default with Tailscale** – Secured with Tailscale, accessible only to you.

## Configuration Overview

In this deployment, the `tailscale-miniflux` service runs the Tailscale client to establish a secure private network. The `miniflux` application and its `postgres` database both use `network_mode: service:tailscale-miniflux`. This means all services share the same network namespace, allowing them to communicate via `localhost` and keeping the application reachable only via the Tailscale network.

## Files to check

Please verify the following files and variables before deploying:

* `.env` — define `SERVICE`, `IMAGE_URL`, `TS_AUTHKEY`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`, and database credentials.
* `compose.yaml` — confirm volume mappings and environment variables.
