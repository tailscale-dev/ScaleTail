# BentoPDF with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **BentoPDF** with a Tailscale sidecar container, enabling secure access to your self-hosted PDF management interface over your private Tailscale network. With this setup, your BentoPDF instance remains **private and accessible only from authorized devices on your Tailnet**, keeping your documents protected from public exposure.

## BentoPDF

[**BentoPDF**](https://github.com/alam00000/bentopdf) is an open-source, self-hosted web application for **viewing, organizing, and managing PDF documents**. It provides a clean, modern interface focused on simplicity and performance, making it ideal for personal document libraries, internal teams, or homelab environments that require private document access.

## Key Features

- 📄 **In-Browser PDF Viewer** – View PDF files directly from a modern web interface.
- 🗂 **Document Organization** – Browse and manage PDFs stored on your server.
- 🔍 **Fast & Lightweight** – Minimal overhead with a focus on performance.
- 🧭 **Clean, Minimal UI** – Simple and distraction-free user experience.
- 🐳 **Docker-Friendly** – Designed to run easily in containerized environments.
- 🔐 **Privacy-First** – Your documents stay entirely on your own infrastructure.
- 📦 **Open Source** – Fully open-source and self-hostable.

## Why Self-Host?

PDF files often contain sensitive personal or business information. Self-hosting BentoPDF ensures **full control and ownership of your documents**, without relying on third-party cloud storage or services. Combined with Tailscale, BentoPDF becomes a private document portal that is securely accessible from anywhere while remaining invisible to the public internet.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-bentopdf`) runs the Tailscale client and joins your private Tailscale network. The main `bentopdf` service uses:

```plain
network_mode: service:tailscale-bentopdf
```

This configuration routes all traffic through the Tailscale interface, ensuring that the BentoPDF web UI is accessible **only via your Tailscale network**. This provides a simple and secure way to access your PDF library from all trusted devices.
