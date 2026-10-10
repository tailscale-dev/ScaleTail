# ScaleTail - Secure self-hosting made simple

[![GitHub stars](https://img.shields.io/github/stars/tailscale-dev/ScaleTail)](https://github.com/tailscale-dev/ScaleTail/stargazers)
[![License](https://img.shields.io/github/license/tailscale-dev/ScaleTail)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](https://www.docker.com/)
[![Tailscale](https://img.shields.io/badge/Tailscale-cccccc?logo=tailscale&logoColor=fff)](https://tailscale.com/)

ScaleTail provides ready-to-run [Docker Compose](https://docs.docker.com/compose) stacks that connect self-hosted applications to your [Tailnet](https://tailscale.com/docs/concepts/tailnet). Each stack runs a Tailscale sidecar container, so the application joins your Tailnet as its own device. Most stacks publish the application at an HTTPS address such as `https://vaultwarden.<tailnet>.ts.net`, reachable from your Tailnet only.

## Featured by Tailscale

[Alex](https://github.com/ironicbadger) from the official Tailscale YouTube channel did a deep dive into ScaleTail! He walks through how to deploy a secure, private service of ScaleTail in under 10 minutes.

[![Watch "We got self-hosted apps for days with ScaleTail"](https://img.youtube.com/vi/ZoEZ7oHA7Gg/maxresdefault.jpg)](https://www.youtube.com/watch?v=ZoEZ7oHA7Gg)

## Quick Start

You need:

- A Linux host with [Docker Engine](https://docs.docker.com/engine/install/), Docker Compose 2.23.1 or later, and [Git](https://git-scm.com/). Check the Compose version with `docker compose version`.
- [MagicDNS](https://tailscale.com/kb/1081/magicdns) and [HTTPS certificates](https://tailscale.com/kb/1153/enabling-https) enabled for your Tailnet, on the [DNS](https://console.tailscale.com/admin/dns) page of the admin console. Without them, the `https://` address of a stack does not work. With HTTPS enabled, device names appear in public certificate transparency logs.

1. **Create an auth key** on the [Keys](https://console.tailscale.com/admin/settings/keys) page of the admin console.

   - Leave **Ephemeral** off. Tailscale removes an ephemeral device 30 to 60 minutes after it goes offline, for example when you stop the stack.
   - Turn on **Pre-approved** if your Tailnet uses [device approval](https://tailscale.com/kb/1099/device-approval).
   - Turn on **Reusable** to use the key for more than one stack.

2. **Get the stacks and choose a service.**

   ```sh
   git clone https://github.com/tailscale-dev/ScaleTail.git
   cd ScaleTail/services/<service>
   ```

   Replace `<service>` with the directory from the **Details** link in [Available configurations](#available-configurations), for example `uptime-kuma`.

3. **Read the service README.** "Before you start" lists what the service needs beyond these steps, such as secrets to generate. Until you set them, Compose stops with an error such as `required variable DB_PASSWORD is missing a value`.

4. **Edit `.env`.** Open the hidden file `.env`, for example with `nano .env`. Paste your auth key after `TS_AUTHKEY=` and set the values that the service README asks for.

5. **Start the stack.**

   ```sh
   docker compose up -d
   docker compose ps
   ```

   The application starts after the `tailscale` container reports `healthy`. If a container is not running, read the logs with `docker compose logs`.

6. **Open the service.** From a device in your Tailnet, open the web interface from "At a glance" in the service README, usually `https://<SERVICE>.<tailnet>.ts.net`. `<SERVICE>` is the value of `SERVICE` in `.env`, and `<tailnet>` is your [Tailnet DNS name](https://tailscale.com/kb/1217/tailnet-name). The first request can take up to a minute, because Tailscale requests the certificate at that moment. Then follow "First run" in the service README. Some stacks have no web interface, and their service README says how to reach them.

7. **Keep the device connected.** Its node key expires after 180 days by default. To prevent that, disable key expiry for the device on the [Machines](https://console.tailscale.com/admin/machines) page.

Every stack starts from the same [standard setup](documentation/standard-setup.md), which explains the containers, the Tailnet address, the data folders, and the settings in `.env`.

## Table of contents

- [Featured by Tailscale](#featured-by-tailscale)
- [Quick Start](#quick-start)
- [Available configurations](#available-configurations)
  - [🌐 Networking and security](#-networking-and-security)
  - [🎥 Media and entertainment](#-media-and-entertainment)
  - [💼 Productivity and collaboration](#-productivity-and-collaboration)
  - [📊 Dashboards and visualization](#-dashboards-and-visualization)
  - [🛠️ Development tools](#development-tools)
  - [📈 Monitoring and analytics](#-monitoring-and-analytics)
  - [🏠 Smart home](#-smart-home)
  - [📱 Utilities](#-utilities)
  - [🍽️ Food \& wellness](#food-wellness)
- [Update a stack](#update-a-stack)
- [Remove a stack](#remove-a-stack)
- [Get help](#get-help)
- [Tailscale Serve and Funnel](#tailscale-serve-and-funnel)
- [Documentation](#documentation)
- [Contributors](#contributors)
- [Contributing](#contributing)
- [Star history](#star-history)
- [License](#license)

## Available configurations

### 🌐 Networking and security

| 🌐 Service                          | 📝 Description                                                                              | 🔗 Link                                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| 🛡️ **AdGuard Home**                 | A network-wide DNS server that blocks ads and trackers.                                     | [Details](services/adguardhome)                  |
| 🔄 **AdGuardHome Sync**             | A tool for syncing configuration across multiple AdGuard Home instances.                    | [Details](services/adguardhome-sync)             |
| 🌐 **Caddy**                        | A web server and reverse proxy with automatic HTTPS.                                        | [Details](services/caddy)                        |
| 🌐 **DDNS Updater**                 | A self-hosted solution to keep DNS A/AAAA records updated automatically.                    | [Details](services/ddns-updater)                 |
| 🌐 **FlareSolverr**                 | A proxy server to bypass Cloudflare and DDoS-GUARD protection.                              | [Details](services/flaresolverr)                 |
| 🔍 **Nessus**                       | A vulnerability scanner from Tenable, with a limited free license called Nessus Essentials. | [Details](services/nessus)                       |
| 🗃️ **NetBox**                       | A source of truth for documenting IP addresses, racks, devices, connections, and circuits.  | [Details](services/netbox)                       |
| 🧩 **Pi-hole**                      | A network-level ad blocker that acts as a DNS sinkhole.                                     | [Details](services/pihole)                       |
| 🆔 **Pocket ID**                    | A self-hosted OIDC provider that signs users in to your services with passkeys.             | [Details](services/pocket-id)                    |
| 🌐 **RustDesk Server**              | A self-hosted ID and relay server for RustDesk remote desktop clients.                      | [Details](services/rustdesk-server)              |
| 🌐 **Tailscale App Connector Node** | Configure a device to act as an app connector for your Tailscale network.                   | [Details](services/tailscale-app-connector-node) |
| 🚀 **Tailscale Exit Node**          | Configure a device to act as an exit node for your Tailscale network.                       | [Details](services/tailscale-exit-node)          |
| 🌐 **Tailscale Subnet Router Node** | Configure a device to act as a subnet router node for your Tailscale network.               | [Details](services/tailscale-subnet-router-node) |
| 🔒 **Technitium DNS**               | An open-source DNS server with ad blocking, forwarders, and your own DNS zones.             | [Details](services/technitium)                   |
| 🌐 **Traefik**                      | A reverse proxy and load balancer that routes requests to Docker containers by label.       | [Details](services/traefik)                      |

### 🎥 Media and entertainment

| 🎥 Service            | 📝 Description                                                                                                   | 🔗 Link                            |
| --------------------- | ---------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| 🎵 **ArtistTrackarr** | A self-hosted dashboard for tracking upcoming and newly released albums and EPs.                                 | [Details](services/artisttrackarr) |
| 🎧 **Audiobookshelf** | A self-hosted audiobook and podcast server with multi-user support and playback syncing.                         | [Details](services/audiobookshelf) |
| 🎥 **Bazarr**         | A companion tool to Radarr and Sonarr for managing subtitles.                                                    | [Details](services/bazarr)         |
| 📚 **BookLore**       | A self-hosted application for managing and reading books.                                                        | [Details](services/booklore)       |
| ⚙️ **Configarr**      | A tool that syncs TRaSH Guides and your own YAML configuration to Radarr, Sonarr, and related services.          | [Details](services/configarr)      |
| 📰 **FreshRSS**       | A customizable feed reader with themes, extensions, and no separate database.                                    | [Details](services/freshrss)       |
| 🎮 **Hytale**         | A self-hosted Hytale game server.                                                                                | [Details](services/hytale)         |
| 🖼️ **Immich**         | A self-hosted Google Photos alternative with face recognition and mobile sync.                                   | [Details](services/immich)         |
| 📺 **Jellyfin**       | An open-source media system that puts you in control of managing and streaming your media.                       | [Details](services/jellyfin)       |
| 📖 **Kavita**         | An open-source, self-hosted digital library for comics, manga, and ebooks.                                       | [Details](services/kavita)         |
| 📺 **MeTube**         | A self-hosted web UI for yt-dlp that downloads video and audio from YouTube and many other sites.                | [Details](services/metube)         |
| ⛏️ **Minecraft**      | A self-hosted Minecraft Java Edition server for private Tailnet multiplayer.                                     | [Details](services/minecraft)      |
| 📻 **Miniflux**       | A minimalist and opinionated feed reader.                                                                        | [Details](services/miniflux)       |
| 🎶 **Navidrome**      | A self-hosted music server that streams your collection to its web player and Subsonic-compatible apps.          | [Details](services/navidrome)      |
| 🎵 **Picard**         | A music tagger that looks up your files in MusicBrainz and writes tags and cover art, used through your browser. | [Details](services/picard)         |
| 🎬 **Plex**           | A media server that organizes video, music, and photos from personal media libraries.                            | [Details](services/plex)           |
| 🖼️ **Posterizarr**    | A tool that creates matching posters, backgrounds, and title cards for Plex, Jellyfin, and Emby libraries.       | [Details](services/posterizarr)    |
| 📡 **Prowlarr**       | An indexer manager and proxy for applications like Radarr, Sonarr, and Lidarr.                                   | [Details](services/prowlarr)       |
| 📥 **qBittorrent**    | An open-source BitTorrent client.                                                                                | [Details](services/qbittorrent)    |
| 🎞️ **Radarr**         | A movie collection manager for Usenet and BitTorrent users.                                                      | [Details](services/radarr)         |
| ♻️ **Recyclarr**      | A tool that syncs TRaSH Guides quality profiles and custom formats to Radarr and Sonarr.                         | [Details](services/recyclarr)      |
| 🎬 **Seerr**          | A request management and media discovery tool for Plex, Jellyfin, and Emby.                                      | [Details](services/seerr)          |
| 🔗 **Slink**          | A self-hosted image hosting and sharing platform with shareable links.                                           | [Details](services/slink)          |
| 📡 **Sonarr**         | A PVR for Usenet and BitTorrent users to manage TV series.                                                       | [Details](services/sonarr)         |
| 🎶 **Swing Music**    | A self-hosted music player and streaming server for your local audio library.                                    | [Details](services/swingmx)        |
| 📊 **Tautulli**       | A monitoring and tracking tool for Plex Media Server.                                                            | [Details](services/tautulli)       |

### 💼 Productivity and collaboration

| 💼 Service              | 📝 Description                                                                                                        | 🔗 Link                           |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| 💰 **Actual Budget**    | A self-hosted personal finance and budgeting app focused on privacy and full data ownership.                          | [Details](services/actual-budget) |
| 🧠 **AFFiNE**           | A self-hosted workspace for documents, whiteboards, and databases.                                                    | [Details](services/affine)        |
| ⚓ **Anchor**           | An offline-first, self-hosted note-taking app with sync, attachments, sharing, and optional OIDC authentication.      | [Details](services/anchor)        |
| 📄 **BentoPDF**         | A privacy-first PDF toolkit that merges, splits, compresses, converts, and edits PDFs in the browser.                 | [Details](services/bentopdf)      |
| ✂️ **ClipCascade**      | A self-hosted server that syncs your clipboard across devices with end-to-end encryption.                             | [Details](services/clipcascade)   |
| 🗂️ **Copyparty**        | A self-hosted file server with accelerated resumable uploads.                                                         | [Details](services/copyparty)     |
| 📚 **Docmost**          | A self-hosted, real-time collaborative wiki with rich editing, diagrams, permissions, and full-text search.           | [Details](services/docmost)       |
| ✅ **Donetick**         | A self-hosted task and chore manager for households and small groups.                                                 | [Details](services/donetick)      |
| ✅ **DumbDo**           | A self-hosted, minimalistic task manager for simple to-do lists.                                                      | [Details](services/dumbdo)        |
| ✅ **Eigenfocus**       | A self-hosted project and task manager with boards and time tracking.                                                 | [Details](services/eigenfocus)    |
| 🗂️ **EspoCRM**          | A self-hosted CRM for sales, support, and marketing.                                                                  | [Details](services/espocrm)       |
| 📝 **Excalidraw**       | A virtual whiteboard for sketching hand-drawn style diagrams.                                                         | [Details](services/excalidraw)    |
| 📝 **flatnotes**        | A simple, self-hosted note-taking app using Markdown files.                                                           | [Details](services/flatnotes)     |
| 👨🏼‍💻 **Forgejo**      | A community-driven, self-hosted Git service.                                                                          | [Details](services/forgejo)       |
| 📋 **Formbricks**       | A self-hosted, open-source platform for collecting user feedback, surveys, and NPS.                                   | [Details](services/formbricks)    |
| ✍️ **Ghost**            | An open-source publishing platform for blogs and newsletters.                                                         | [Details](services/ghost)         |
| 👨🏼‍💻 **Gitea**        | A lightweight, self-hosted Git service with repository hosting, pull requests, and issue tracking.                    | [Details](services/gitea)         |
| 🧑‍🧑‍🧒‍🧒 **Gramps Web** | A web-based genealogy platform for browsing and editing family trees together.                                        | [Details](services/grampsweb)     |
| 🔖 **Haptic**           | A local-first, open-source Markdown note editor.                                                                      | [Details](services/haptic)        |
| 🌿 **Isley**            | A self-hosted cannabis grow journal for tracking plants and managing grow data.                                       | [Details](services/isley)         |
| 🗂️ **Kaneo**            | A self-hosted project management tool with boards and tasks, focused on simplicity.                                   | [Details](services/kaneo)         |
| 🗒️ **Karakeep**         | A self-hosted bookmark manager that archives links, notes, and images, with full-text search and optional AI tagging. | [Details](services/karakeep)      |
| 🧠 **LanguageTool**     | An open-source grammar, style, and spell checker server for many languages.                                           | [Details](services/languagetool)  |
| 🔖 **linkding**         | A self-hosted bookmark manager to save and organize links.                                                            | [Details](services/linkding)      |
| 📥 **Mattermost**       | A self-hosted collaborative workflow and communication tool.                                                          | [Details](services/mattermost)    |
| 📝 **Memos**            | A lightweight, self-hosted Markdown note-taking app for quick notes on a timeline.                                    | [Details](services/memos)         |
| 📝 **Nanote**           | A lightweight, self-hosted note-taking app with Markdown support.                                                     | [Details](services/nanote)        |
| 📂 **NextExplorer**     | A self-hosted file explorer for managing mounted directories.                                                         | [Details](services/next-explorer) |
| 🤖 **Open WebUI**       | A self-hosted AI platform with a ChatGPT-style interface for local and cloud-based models.                            | [Details](services/open-webui)    |
| 📚 **Paperless-ngx**    | An open-source document management system that transforms physical documents into a searchable archive.               | [Details](services/paperless)     |
| 🔗 **Pingvin Share**    | **PROJECT ARCHIVED** A self-hosted file sharing platform.                                                             | [Details](services/pingvin-share) |
| 📅 **Radicale**         | A lightweight CalDAV and CardDAV server for self-hosted calendar, to-do, and contact sync.                            | [Details](services/radicale)      |
| 🔄 **Resilio Sync**     | A peer-to-peer tool that syncs folders directly between your devices.                                                 | [Details](services/resilio-sync)  |
| 📁 **Seafile**          | A self-hosted file syncing and collaboration platform with file sharing, versioning, and team library support.        | [Details](services/seafile)       |
| 🗂️ **Stirling-PDF**     | A web application for managing and editing PDF files.                                                                 | [Details](services/stirlingpdf)   |
| 🏦 **SubTrackr**        | A self-hosted web app to track subscriptions, renewal dates, costs, and payment methods.                              | [Details](services/subtrackr)     |
| 💰 **Sure**             | A self-hosted personal finance and budgeting app with optional AI insights.                                           | [Details](services/sure)          |
| 🗃️ **Vaultwarden**      | An unofficial Bitwarden server implementation written in Rust.                                                        | [Details](services/vaultwarden)   |
| ✅ **Vikunja**          | A self-hosted to-do and project management app with lists, boards, and reminders.                                     | [Details](services/vikunja)       |
| 💸 **Wallos**           | A self-hosted tracker for recurring subscriptions and expenses, with multi-currency support.                          | [Details](services/wallos)        |
| 📚 **XWiki**            | A wiki platform for documentation and knowledge management, with structured pages and extensions.                     | [Details](services/xwiki)         |

### 📊 Dashboards and visualization

| 📊 Service                | 📝 Description                                                                                                 | 🔗 Link                                |
| ------------------------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| 🧭 **Glance**             | A lightweight, customizable dashboard that puts your feeds, such as RSS, weather, and markets, on one page.    | [Details](services/glance)             |
| 🖥️ **Homarr**             | A customizable dashboard for your self-hosted services, with drag-and-drop configuration and app integrations. | [Details](services/homarr)             |
| 🏠 **Homepage**           | A highly customizable application dashboard with Docker and service integrations.                              | [Details](services/homepage)           |
| 🖼️ **NewWallpaperWhoDis** | A self-hosted wallpaper server that rotates your collection on browsers, tablets, smart TVs, and dashboards.   | [Details](services/newwallpaperwhodis) |

<a id="development-tools"></a>

### 🛠️ Development tools

| 🛠️ Service          | 📝 Description                                                                                                   | 🔗 Link                         |
| ------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| 🧰 **Arcane**       | A self-hosted web UI to manage Docker containers, images, networks, volumes, and Compose projects.               | [Details](services/arcane)      |
| 🛠️ **Coder**        | A self-hosted platform for development environments that you define as Terraform templates.                      | [Details](services/coder)       |
| 🔧 **CyberChef**    | A web app for encryption, encoding, compression, and data analysis.                                              | [Details](services/cyberchef)   |
| 🐳 **Dockge**       | A lightweight, self-hosted Docker Compose stack manager with a web UI.                                           | [Details](services/dockge)      |
| 🐳 **Dockhand**     | A lightweight Docker management UI for containers and Compose stacks on local and remote hosts.                  | [Details](services/dockhand)    |
| 🖥️ **Dozzle**       | A real-time log viewer for Docker containers.                                                                    | [Details](services/dozzle)      |
| 📁 **File Browser** | **PROJECT ARCHIVED** A web file manager for one folder on your server. Upstream gives no further security fixes. | [Details](services/filebrowser) |
| 🔁 **FossFLOW**     | A self-hosted tool to draw isometric infrastructure diagrams.                                                    | [Details](services/fossflow)    |
| 🖥️ **GitSave**      | A self-hosted service that backs up your Git repositories from GitHub, GitLab, and others on a schedule.         | [Details](services/gitsave)     |
| 🖥️ **Gokapi**       | A lightweight self-hosted file sharing platform.                                                                 | [Details](services/gokapi)      |
| 🖥️ **IT-Tools**     | A collection of handy online tools for developers and sysadmins.                                                 | [Details](services/it-tools)    |
| 📧 **Mailpit**      | A self-hosted email testing tool for capturing, viewing, and debugging outgoing emails during development.       | [Details](services/mailpit)     |
| 🖥️ **Node-RED**     | A flow-based development tool for visual programming.                                                            | [Details](services/nodered)     |
| 🧠 **Ollama**       | A self-hosted solution for running open large language models (LLMs) locally with an OpenAI-compatible API.      | [Details](services/ollama)      |
| 🖥️ **Portainer**    | A lightweight management UI which allows you to easily manage your Docker environments.                          | [Details](services/portainer)   |
| 🔍 **SearXNG**      | A free internet metasearch engine which aggregates results from various search services.                         | [Details](services/searxng)     |

### 📈 Monitoring and analytics

| 📈 Service                | 📝 Description                                                                                         | 🔗 Link                               |
| ------------------------- | ------------------------------------------------------------------------------------------------------ | ------------------------------------- |
| 🛰️ **Beszel Agent**       | An agent that collects system and Docker stats and reports them to a Beszel Hub.                       | [Details](services/beszel-agent)      |
| 📉 **Beszel Hub**         | A lightweight server monitoring hub with historical data, Docker stats, and alerts.                    | [Details](services/beszel-hub)        |
| 🖥️ **changedetection.io** | A tool for monitoring website changes.                                                                 | [Details](services/changedetection)   |
| 🔎 **Portracker**         | A self-hosted tool that discovers the services on your systems and maps the ports they use.            | [Details](services/portracker)        |
| 🚀 **Speedtest Tracker**  | A self-hosted tool to monitor and log internet speed tests with detailed visualizations.               | [Details](services/speedtest-tracker) |
| 📊 **Umami**              | An open-source web analytics platform that respects user privacy.                                      | [Details](services/umami)             |
| 📊 **Uptime Kuma**        | A self-hosted monitoring tool that checks your websites and services and alerts you when they go down. | [Details](services/uptime-kuma)       |

### 🏠 Smart home

| 🏠 Service            | 📝 Description                                                                                  | 🔗 Link                            |
| --------------------- | ----------------------------------------------------------------------------------------------- | ---------------------------------- |
| 🎥 **Frigate**        | A self-hosted NVR with real-time AI object detection for IP cameras and local video monitoring. | [Details](services/frigate)        |
| 🏡 **Home Assistant** | An open-source home automation platform for controlling smart devices.                          | [Details](services/home-assistant) |

### 📱 Utilities

| 📱 Service        | 📝 Description                                                                                              | 🔗 Link                         |
| ----------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------- |
| 🔁 **ConvertX**   | A self-hosted online file converter for documents, images, audio, video, and over a thousand other formats. | [Details](services/convertx)    |
| 🔔 **Gotify**     | A simple server for sending and receiving messages in real-time.                                            | [Details](services/gotify)      |
| 🔐 **Hemmelig**   | **PROJECT ARCHIVED** A self-hosted, zero-knowledge encrypted secret sharing platform with expiring secrets. | [Details](services/hemmelig)    |
| 📦 **Homebox**    | A self-hosted home inventory and asset management system.                                                   | [Details](services/homebox)     |
| 🚗 **LubeLogger** | A self-hosted vehicle maintenance and fuel mileage tracker.                                                 | [Details](services/lube-logger) |
| 📱 **Mini QR**    | A self-hosted app to create, style, and scan QR codes.                                                      | [Details](services/miniqr)      |
| 📣 **ntfy**       | A simple HTTP-based pub/sub notification service for sending push notifications.                            | [Details](services/ntfy)        |
| 🚗 **Tracktor**   | A self-hosted app to track your vehicles' fuel use, maintenance, insurance, and documents.                  | [Details](services/tracktor)    |
| 🔁 **Transmute**  | A self-hosted file converter and compressor for images, video, audio, and documents, with a web UI and API. | [Details](services/transmute)   |

<a id="food-wellness"></a>

### 🍽️ Food & wellness

| 🍽️ Service             | 📝 Description                                                                                            | 🔗 Link                        |
| ---------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------ |
| 🥘 **KitchenOwl**      | A self-hosted grocery list and recipe manager with meal planning and expense tracking for households.     | [Details](services/kitchenowl) |
| 🥘 **Mealie**          | A self-hosted recipe manager and meal planner with features like shopping lists, scaling, and importing.  | [Details](services/mealie)     |
| 🥘 **Tandoor Recipes** | A self-hosted recipe manager and meal planner with shopping lists, nutrition tracking, and recipe import. | [Details](services/tandoor)    |

## Update a stack

Most stacks use the `latest` image tag. To get newer images, run this from the service directory:

```sh
docker compose pull
docker compose up -d
```

To get the latest version of the stacks, update your clone. Git does not overwrite files that you changed, such as `.env`, so set your changes aside first:

```sh
git stash
git pull
git stash pop
```

If `git stash pop` reports a conflict in `.env`, open the file, keep your values, delete the `<<<<<<<`, `=======`, and `>>>>>>>` lines, then run `git reset` and `git stash drop`.

Before you restart the stack, read the "Upgrading" section of the service README, if it has one.

## Remove a stack

From the service directory, run `docker compose down --volumes`. To remove the stack completely, also remove the device on the [Machines](https://console.tailscale.com/admin/machines) page and delete the service directory. It contains the Tailscale state in `./ts/state` and the application data. The containers create some of these folders as root, so deleting them may need `sudo`.

## Get help

- Read the "Troubleshooting" section of the service README, and check the logs with `docker compose logs`.
- Ask questions in the [Tailscale Discord](https://discord.gg/tailscale).
- Report a problem with a stack in a [GitHub issue](https://github.com/tailscale-dev/ScaleTail/issues/new/choose).

## Tailscale Serve and Funnel

[Tailscale Serve](https://tailscale.com/kb/1312/serve) routes traffic from other devices in your Tailnet to a service on one device. [Tailscale Funnel](https://tailscale.com/kb/1223/funnel) routes traffic from the public internet to that service, so people without Tailscale can reach it.

Stacks that use Serve keep Funnel off (`"AllowFunnel":{"$${TS_CERT_DOMAIN}:443":false}` in `compose.yaml`), so they are reachable from your Tailnet only. Umami has an opt-in public mode; see its README.

To make a service reachable from the internet:

1. Add `funnel` to `nodeAttrs` in your Tailnet policy file for the device, as described in [Tailscale Funnel](https://tailscale.com/kb/1223/funnel).
2. In `compose.yaml`, change `false` to `true` in the `AllowFunnel` line.
3. Recreate the stack with `docker compose up -d --force-recreate`.

Funnel is in beta and listens only on ports 443, 8443, and 10000. It requires MagicDNS and HTTPS certificates, as in the Quick Start. Anyone on the internet can then reach the application, so turn on its login first.

![Diagram of Tailscale Funnel: a client on the public internet reaches a controlled gateway, which exposes one service in the Tailnet, while private services get no access.](images/tailscale-funnel.png)

![Diagram of Tailscale Serve: a Tailnet node reaches a lightweight web service through Serve with private access only. Funnel, shown separately, is the only part that publishes a service to the public internet.](images/tailscale-serve.png)

## Documentation

In this repository:

- [The standard ScaleTail setup](documentation/standard-setup.md)
- [Free up port 53 on the Docker host](documentation/free-up-port-53.md)
- [Install Tailscale on an OpenPLi set-top box (without Docker)](documentation/tailscale-on-arm.md)

From Tailscale:

- [Tailscale documentation](https://tailscale.com/kb)
- [Docker](https://tailscale.com/kb/1282/docker) and its [configuration parameters](https://tailscale.com/docs/features/containers/docker/docker-params)
- [Tailscale Serve](https://tailscale.com/kb/1312/serve)
- [Tailscale Funnel](https://tailscale.com/kb/1223/funnel)
- [A deep dive into using Tailscale with Docker](https://tailscale.com/blog/docker-tailscale-guide)

## Contributors

A huge thank you to all our contributors! ScaleTail wouldn't be what it is today without your time, effort, and ideas!

<a href="https://github.com/tailscale-dev/ScaleTail/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tailscale-dev/ScaleTail" alt="ScaleTail contributors" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidance on adding services with the [template](templates/service-template/) to keep Tailscale-sidecar setups consistent.

## Star history

[![Star History Chart](https://api.star-history.com/svg?repos=tailscale-dev/scaletail&type=Date)](https://star-history.com/#tailscale-dev/scaletail&Date)

## License

[MIT](LICENSE)
