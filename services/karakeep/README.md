# Karakeep with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **[Karakeep](https://github.com/karakeep-app/karakeep)** with Tailscale as a sidecar container to securely manage and access your self-hosted notes and collaboration app over a private Tailscale network. By integrating Tailscale, you can ensure that your Karakeep instance is only accessible to authorized devices within your Tailscale network, protecting your ideas and information from the public web.

## Karakeep

[Karakeep](https://github.com/karakeep-app/karakeep) is an open-source, self-hosted **bookmark-everything app (links, notes and images)** with AI-based automatic tagging and full text search.

## Key Features

- 🔗 Bookmark links, take simple notes and store images and pdfs.
- ⬇️ Automatic fetching for link titles, descriptions and images.
- 📋 Sort your bookmarks into lists.
- 👥 Collaborate with others on the same list.
- 🔎 Full text search of all the content stored.
- ✨ AI-based (aka chatgpt) automatic tagging and summarization. With supports for local models using ollama!
- 🤖 Rule-based engine for customized management.
- 🎆 OCR for extracting text from images.
- 🔖 Chrome plugin and Firefox addon for quick bookmarking.
- 📱 An iOS app, and an Android app.
- 📰 Auto hoarding from RSS feeds.
- 🔌 REST API and multiple clients.
- 🌐 Multi-language support.
- 🖍️ Mark and store highlights from your hoarded content.
- 🗄️ Full page archival (using monolith) to protect against link rot.
- ▶️ Auto video archiving using yt-dlp.
- ☑️ Bulk actions support.
- 🔐 SSO support.
- 🌙 Dark mode support.
- 💾 Self-hosting first. Own your data, free from third-party cloud services.
- ⬇️ Bookmark importers from Chrome, Pocket, Linkwarden, Omnivore, Tab Session Manager.
- 🔄 Automatic sync with browser bookmarks via floccus.
- **Secure Access with Tailscale** – Restrict access to your data using your private Tailscale network.

## Configuration Overview

In this setup, the `tailscale-karakeep` service runs Tailscale, which manages secure networking for the Karakeep service. The `karakeep` service uses the Tailscale network stack via Docker's `network_mode: service:` configuration. This ensures that Karakeep’s web interface is only accessible through the Tailscale network (or locally, if preferred), enhancing the privacy and security of your notes and collaborative workspace.
