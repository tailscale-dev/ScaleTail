# Hemmelig.app with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Hemmelig.app** with a Tailscale sidecar container, enabling secure access to your private encrypted secret-sharing platform over your Tailscale network. With this setup, your instance will be **private and reachable only by your authorized Tailscale devices**, ensuring truly confidential communication and secret exchange.

## Hemmelig.app

[**Hemmelig.app**](https://github.com/HemmeligOrg/Hemmelig.app) is an open-source encrypted sharing platform designed for securely transmitting sensitive information such as passwords, confidential messages, API keys, or other private data. All encryption is performed client-side using strong cryptography (TweetNaCl), meaning **your secrets are encrypted before ever leaving the user’s browser and the server never sees the plaintext**.

## Key Features

- 🔐 **Zero-Knowledge Encryption** – All data encrypted client-side; the server only stores ciphertext.
- ⏳ **Self-Destructing Secrets** – Secrets can expire after time or a specific number of views.
- 🛡 **Optional Password Protection** – Add another layer of protection to shared secrets.
- 🌍 **IP Restrictions** – Restrict who can view the secret based on IP range.
- 📁 **Encrypted File Uploads** – Support for sharing files securely (when enabled).
- 🪪 **Rich Sharing Options** – Includes QR code support and metadata controls.
- 📦 **Self-Hosted Friendly** – Easy Docker deployment with persistent storage and SQLite backend.

## Why Self-Host?

While a public SaaS instance of Hemmelig (e.g., hemmelig.app) exists, **self-hosting gives you full control over your data, compliance, and uptime** — especially important if you’re sharing highly sensitive company secrets or keys. Combining it with Tailscale ensures the service isn’t publicly reachable at all, but instead safely accessible only by your team.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (e.g., `tailscale-hemmelig`) runs the Tailscale client and joins your private Tailscale network. The main `hemmelig` service uses:

```plain
network_mode: service:tailscale-hemmelig
```

This effectively **routes all traffic through the Tailscale network interface**, making the app private and unreachable from the public Internet while still accessible to any device on your Tailscale network. Remote team members can securely access the Hemmelig web UI, API, and encryption features over Tailscale without exposing the app publicly.
