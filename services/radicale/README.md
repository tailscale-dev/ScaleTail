# Radicale with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Radicale](https://radicale.org/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Radicale

[Radicale](https://radicale.org/) is a small but powerful CalDAV (calendars, to-do lists) and CardDAV (contacts) server. It is lightweight, easy to configure, and requires minimal resources, making it a great self-hosted alternative to cloud-based calendar and contact sync services.

## Key Features

- CalDAV and CardDAV support for syncing calendars, to-do lists, and contacts
- Works with any compliant client (Thunderbird, GNOME Calendar, DAVx5, Apple Calendar, etc.)
- Lightweight with minimal resource usage
- Simple file-based storage
- Web interface for managing collections
- Built-in access control and authentication

## Configuration Overview

In this setup, the `tailscale-radicale` service runs Tailscale, which manages secure networking for Radicale. The `radicale` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

The container runs with hardened security settings: read-only filesystem, no new privileges, dropped capabilities, and resource limits (256M memory, 50 pids).

## Prerequisites

- This image uses [tomsquest/docker-radicale](https://github.com/tomsquest/docker-radicale). Refer to their documentation for advanced configuration options.
- To configure users and authentication, mount a custom config file or refer to the [Radicale documentation](https://radicale.org/v3.html#configuration).

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variable: `TS_AUTHKEY`
