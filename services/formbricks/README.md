
# Formbricks with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Formbricks** with a Tailscale sidecar container, enabling secure access to your self-hosted user feedback and survey platform over your private Tailscale network. With this setup, your Formbricks instance remains **private and accessible only from authorized devices on your Tailnet**, keeping feedback data and analytics protected from public exposure.

## Formbricks

[**Formbricks**](https://github.com/formbricks/formbricks) is an open-source, self-hosted alternative to tools like Typeform, Hotjar, and Google Forms. It allows you to collect **user feedback, surveys, NPS scores, and product insights** directly from your applications or websites, while maintaining full control over your data.

Formbricks is built with privacy, extensibility, and developer experience in mind, making it well-suited for internal tooling, SaaS products, and organizations that want insight without vendor lock-in.

## Key Features

- 📝 **Surveys & Forms** – Create surveys, forms, and questionnaires with a modern UI.
- ⭐ **NPS & CSAT** – Measure Net Promoter Score and customer satisfaction.
- 🎯 **In-App Feedback** – Embed feedback widgets directly into your applications.
- 📊 **Analytics & Dashboards** – Analyze responses with built-in insights.
- 🔌 **API & Webhooks** – Integrate feedback data into external systems.
- 🔐 **Privacy-First** – Full data ownership through self-hosting.
- 🐳 **Docker-Ready** – Designed for containerized deployments.
- 📦 **Open Source** – Community-driven and extensible.

## Why Self-Host?

Feedback data can include sensitive product insights, internal metrics, and personal information. Self-hosting Formbricks ensures **complete ownership and control over your data**, supports compliance requirements, and removes reliance on third-party SaaS platforms. Combined with Tailscale, Formbricks becomes a secure internal feedback system that is never exposed to the public internet.

## Configuration Overview

In this deployment, a **Tailscale sidecar container** (for example `tailscale-formbricks`) runs the Tailscale client and joins your private Tailscale network. The main `formbricks` service uses:

```plain
network_mode: service:tailscale-formbricks
```

This configuration routes all inbound and outbound traffic through the Tailscale interface, ensuring that the Formbricks admin UI, APIs, and feedback endpoints are accessible **only via your Tailscale network**. This keeps sensitive feedback data protected while still allowing secure access for authorized team members.
