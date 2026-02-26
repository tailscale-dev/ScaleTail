# Tracktor with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Tracktor** with a **Tailscale sidecar** container, enabling secure access to your self-hosted vehicle management interface over your private Tailscale network. With this setup, your Tracktor instance remains **private and accessible only from authorized devices on your Tailnet**, keeping sensitive vehicle data, documents, and analytics off the public internet.

## Tracktor

[**Tracktor**](https://github.com/javedh-dev/tracktor) is an open-source web application for comprehensive vehicle management. It helps you track multiple vehicles in one place, including fuel consumption, maintenance history, insurance, and regulatory documents with renewal dates.

Tracktor is under active development and may include breaking changes. Keep regular backups of your data and validate upgrades before relying on it for critical workflows.

## Key Features

- 🚗 **Vehicle Management** – Add, edit, and manage multiple vehicles, including different fuel types.
- ⛽ **Fuel Tracking** – Log fuel refills and monitor consumption and efficiency over time.
- 🧰 **Maintenance Log** – Record and review maintenance history per vehicle.
- 📄 **Document Tracking** – Track insurance, inspection, and regulatory documents with renewal dates.
- ⏰ **Reminders** – Set reminders for maintenance, renewals, and other vehicle events.
- 📊 **Dashboard & Analytics** – Visualize key metrics and upcoming renewals.
- 🔐 **User Authentication** – Username/password auth with session management.
- 🎛️ **Feature Toggles** – Enable or disable features depending on your needs.

## Why Self-Host?

A vehicle management system often contains personal and operational data such as license plate numbers, VINs, service history, and document expiration dates. Hosting this data yourself ensures you retain full ownership, avoid third-party data exposure, and can integrate it cleanly into your homelab or internal tooling.

When combined with Tailscale, Tracktor becomes a private portal accessible only to authenticated devices on your Tailnet. This significantly reduces attack surface by avoiding public port exposure, while preserving the convenience of accessing your vehicle records from anywhere.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-tracktor`) runs the Tailscale client and joins your private Tailscale network. The main `tracktor` service uses:

```plain
network_mode: service:tailscale-tracktor
```

This configuration routes all inbound and outbound traffic through the Tailscale interface, ensuring that the Tracktor web UI is accessible **only via your Tailscale network**.
