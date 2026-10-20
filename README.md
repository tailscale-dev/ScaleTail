# ScaleTail

[![GitHub stars](https://img.shields.io/github/stars/tailscale-dev/ScaleTail)](https://github.com/tailscale-dev/ScaleTail/stargazers)
[![License](https://img.shields.io/github/license/tailscale-dev/ScaleTail)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff)](https://www.docker.com/)
[![Tailscale](https://img.shields.io/badge/Tailscale-cccccc?logo=tailscale&logoColor=fff)](https://tailscale.com/)

ScaleTail is a collection of ready-to-run [Docker Compose](https://docs.docker.com/compose) stacks that connect self-hosted applications to your [Tailnet](https://tailscale.com/docs/concepts/tailnet). Each stack runs a Tailscale sidecar container, so the application joins your Tailnet as its own device. Most stacks publish the application at an HTTPS address such as `https://vaultwarden.<tailnet>.ts.net`, reachable from your Tailnet only.

## Table of contents

- [Featured by Tailscale](#featured-by-tailscale)
- [Quick Start](#quick-start)
- [Available configurations](#available-configurations)
  - [Networking and security](#networking-and-security)
  - [Media and entertainment](#media-and-entertainment)
  - [Productivity and collaboration](#productivity-and-collaboration)
  - [Dashboards and visualization](#dashboards-and-visualization)
  - [Development tools](#development-tools)
  - [Monitoring and analytics](#monitoring-and-analytics)
  - [Smart home](#smart-home)
  - [Utilities](#utilities)
  - [Food and wellness](#food-and-wellness)
- [Update a stack](#update-a-stack)
- [Remove a stack](#remove-a-stack)
- [Get help](#get-help)
- [Tailscale Serve and Funnel](#tailscale-serve-and-funnel)
- [Documentation](#documentation)
- [Contributors](#contributors)
- [Contributing](#contributing)
- [Star history](#star-history)
- [License](#license)

## Featured by Tailscale

In this video from the Tailscale YouTube channel, [Alex](https://github.com/ironicbadger) deploys a ScaleTail service in under 10 minutes.

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

6. **Open the service.** From a device in your Tailnet, open the address from "At a glance" in the service README, usually `https://<SERVICE>.<tailnet>.ts.net`.

   - `<SERVICE>` is the value of `SERVICE` in `.env`.
   - `<tailnet>.ts.net` is your [Tailnet DNS name](https://tailscale.com/kb/1217/tailnet-name), for example `tail1234.ts.net`.
   - The first request can take up to a minute, because Tailscale requests the certificate at that moment.

   Then follow "First run" in the service README. Some stacks have no web interface, and their service README says how to reach them.

7. **Keep the device connected.** Its node key expires after 180 days by default. To prevent that, disable key expiry for the device on the [Machines](https://console.tailscale.com/admin/machines) page.

Every stack starts from the same [standard setup](documentation/standard-setup.md), which explains the containers, the Tailnet address, the data folders, and the settings in `.env`.

## Available configurations

### Networking and security

| Service                          | Description                                                                             | Link                                             |
| -------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------ |
| **AdGuard Home**                 | DNS server that blocks ads and trackers on every device that uses it.                   | [Details](services/adguardhome)                  |
| **AdGuard Home Sync**            | Tool that copies the configuration of one AdGuard Home instance to replicas.            | [Details](services/adguardhome-sync)             |
| **Caddy**                        | Web server and reverse proxy with automatic HTTPS.                                      | [Details](services/caddy)                        |
| **DDNS Updater**                 | Updater that keeps DNS records pointed at your current public IP address.               | [Details](services/ddns-updater)                 |
| **FlareSolverr**                 | Proxy that solves Cloudflare and DDoS-GUARD challenges.                                 | [Details](services/flaresolverr)                 |
| **Nessus**                       | Vulnerability scanner from Tenable, with the limited free Nessus Essentials license.    | [Details](services/nessus)                       |
| **NetBox**                       | Network documentation tool for IP addresses, racks, devices, connections, and circuits. | [Details](services/netbox)                       |
| **Pi-hole**                      | DNS sinkhole that blocks ads and trackers for every device that uses it.                | [Details](services/pihole)                       |
| **Pocket ID**                    | OpenID Connect provider that signs users in to your services with passkeys.             | [Details](services/pocket-id)                    |
| **RustDesk Server**              | Your own ID and relay server for RustDesk clients, so they skip the public servers.     | [Details](services/rustdesk-server)              |
| **Tailscale App Connector Node** | App connector that sends Tailnet traffic for chosen domains through this host.          | [Details](services/tailscale-app-connector-node) |
| **Tailscale Exit Node**          | Exit node that routes the internet traffic of other Tailnet devices through this host.  | [Details](services/tailscale-exit-node)          |
| **Tailscale Subnet Router Node** | Subnet router that gives your Tailnet access to a local network.                        | [Details](services/tailscale-subnet-router-node) |
| **Technitium DNS**               | Authoritative and recursive DNS server with ad blocking and your own zones.             | [Details](services/technitium)                   |
| **Traefik**                      | Reverse proxy and load balancer that routes requests to Docker containers by label.     | [Details](services/traefik)                      |
| **Vaultwarden**                  | Unofficial password manager server for the Bitwarden apps and extensions.               | [Details](services/vaultwarden)                  |

### Media and entertainment

| Service            | Description                                                                                          | Link                               |
| ------------------ | ---------------------------------------------------------------------------------------------------- | ---------------------------------- |
| **ArtistTrackarr** | Tracker for new albums, EPs, singles, and compilations from Spotify.                                 | [Details](services/artisttrackarr) |
| **Audiobookshelf** | Server for audiobooks and podcasts, with playback progress synced across devices.                    | [Details](services/audiobookshelf) |
| **Bazarr**         | Subtitle manager for movies and series in Radarr and Sonarr.                                         | [Details](services/bazarr)         |
| **BookLore**       | Book manager and browser reader, with Kobo and KOReader sync. In maintenance mode.                   | [Details](services/booklore)       |
| **Configarr**      | Tool that applies YAML settings and TRaSH Guides profiles to Radarr and Sonarr, then exits.          | [Details](services/configarr)      |
| **FreshRSS**       | RSS and Atom feed reader that uses SQLite, with no separate database server.                         | [Details](services/freshrss)       |
| **Fusion**         | Lightweight feed reader for RSS, Atom, and JSON feeds, with a Fever API.                             | [Details](services/fusion)         |
| **Hytale**         | Hytale game server in a community image, for players on your Tailnet.                                | [Details](services/hytale)         |
| **Immich**         | Photo and video library that backs up mobile media, with search and sharing.                         | [Details](services/immich)         |
| **Jellyfin**       | Media server that organizes and streams your movies, series, and music.                              | [Details](services/jellyfin)       |
| **Kavita**         | Digital library for comics, manga, and books, with progress synced across devices.                   | [Details](services/kavita)         |
| **MeTube**         | Web UI for yt-dlp that downloads videos and audio from YouTube and other sites.                      | [Details](services/metube)         |
| **Minecraft**      | Minecraft Java Edition server that players reach over your Tailnet.                                  | [Details](services/minecraft)      |
| **Miniflux**       | Minimalist feed reader for RSS, Atom, and JSON feeds, with a PostgreSQL database.                    | [Details](services/miniflux)       |
| **Navidrome**      | Music server that streams your collection to its web player and Subsonic-compatible apps.            | [Details](services/navidrome)      |
| **Picard**         | MusicBrainz tag editor that writes tags and cover art, used in your browser.                         | [Details](services/picard)         |
| **Plex**           | Media server that streams your movies, series, and music to Plex apps; needs a Plex account.         | [Details](services/plex)           |
| **Posterizarr**    | Poster, background, and title card generator for Plex, Jellyfin, and Emby libraries.                 | [Details](services/posterizarr)    |
| **Prowlarr**       | Indexer manager for Usenet and torrent trackers, used by apps such as Radarr and Sonarr.             | [Details](services/prowlarr)       |
| **qBittorrent**    | BitTorrent client with a web interface.                                                              | [Details](services/qbittorrent)    |
| **Radarr**         | Movie manager that searches Usenet and BitTorrent and sorts files into your library.                 | [Details](services/radarr)         |
| **Recyclarr**      | Tool that applies TRaSH Guides quality profiles from a YAML file to Radarr and Sonarr on a schedule. | [Details](services/recyclarr)      |
| **Seerr**          | Request manager for Plex, Jellyfin, and Emby that sends approved requests to Radarr and Sonarr.      | [Details](services/seerr)          |
| **Slink**          | Image hosting platform that shares uploads through links.                                            | [Details](services/slink)          |
| **Sonarr**         | Series manager that searches Usenet and BitTorrent for new episodes.                                 | [Details](services/sonarr)         |
| **Swing Music**    | Music player and streaming server for your local audio files.                                        | [Details](services/swingmx)        |
| **Tautulli**       | Monitoring tool for Plex Media Server, with viewing history, statistics, and notifications.          | [Details](services/tautulli)       |

### Productivity and collaboration

| Service           | Description                                                                                    | Link                              |
| ----------------- | ---------------------------------------------------------------------------------------------- | --------------------------------- |
| **Actual Budget** | Personal finance app for budgeting.                                                            | [Details](services/actual-budget) |
| **AFFiNE**        | Workspace for documents, whiteboards, and databases.                                           | [Details](services/affine)        |
| **Anchor**        | Note-taking app that works offline and syncs notes when you are back online.                   | [Details](services/anchor)        |
| **BentoPDF**      | PDF toolkit that works in your browser, without uploading files.                               | [Details](services/bentopdf)      |
| **ClipCascade**   | Server that syncs your clipboard across devices, with end-to-end encryption.                   | [Details](services/clipcascade)   |
| **Copyparty**     | File server with resumable uploads, browser access, and WebDAV.                                | [Details](services/copyparty)     |
| **Docmost**       | Team wiki with real-time collaborative editing.                                                | [Details](services/docmost)       |
| **Donetick**      | Task and chore manager for households and small groups.                                        | [Details](services/donetick)      |
| **DumbDo**        | To-do list app that keeps its lists in one file, with no database.                             | [Details](services/dumbdo)        |
| **Eigenfocus**    | Project and task manager with boards, time tracking, and focus tools.                          | [Details](services/eigenfocus)    |
| **EspoCRM**       | Customer relationship manager for contacts, companies, and sales opportunities.                | [Details](services/espocrm)       |
| **Excalidraw**    | Virtual whiteboard for sketching diagrams in a hand-drawn style.                               | [Details](services/excalidraw)    |
| **File Browser**  | Archived. Web file manager for one folder on your server, with no further security fixes.      | [Details](services/filebrowser)   |
| **flatnotes**     | Note-taking app that stores notes as plain Markdown files, with no database.                   | [Details](services/flatnotes)     |
| **Formbricks**    | Survey and feedback platform for websites, apps, and links.                                    | [Details](services/formbricks)    |
| **Ghost**         | Publishing platform for blogs and newsletters.                                                 | [Details](services/ghost)         |
| **Gokapi**        | File sharing server with links that expire after a number of downloads or days.                | [Details](services/gokapi)        |
| **Gramps Web**    | Genealogy web app for browsing and editing family trees together.                              | [Details](services/grampsweb)     |
| **Haptic**        | Markdown note editor that keeps notes in the browser, not on the server.                       | [Details](services/haptic)        |
| **Isley**         | Cannabis grow journal for plants, watering, feeding, harvests, and sensors.                    | [Details](services/isley)         |
| **Joplin Server** | Sync server for the Joplin note-taking apps, for personal non-commercial use.                  | [Details](services/joplin)        |
| **Kaneo**         | Open-source project tracker with boards and tasks, an alternative to Trello and Linear.        | [Details](services/kaneo)         |
| **Karakeep**      | Bookmark manager that archives links, notes, and images, with full-text search and AI tagging. | [Details](services/karakeep)      |
| **LanguageTool**  | Grammar and spelling checker server for browser extensions, with no web interface.             | [Details](services/languagetool)  |
| **linkding**      | Bookmark manager to save, tag, and search links.                                               | [Details](services/linkding)      |
| **Mattermost**    | Team chat platform with channels, direct messages, and integrations.                           | [Details](services/mattermost)    |
| **Memos**         | Note-taking app for short Markdown notes, shown on a timeline.                                 | [Details](services/memos)         |
| **Nanote**        | Note-taking app that stores notes as Markdown files in folders.                                | [Details](services/nanote)        |
| **NextExplorer**  | Web file manager for one folder on your server.                                                | [Details](services/next-explorer) |
| **Open WebUI**    | Chat interface for AI models, through Ollama or OpenAI-compatible APIs.                        | [Details](services/open-webui)    |
| **Paperless-ngx** | Document management system that turns scans and files into a searchable archive.               | [Details](services/paperless)     |
| **Pingvin Share** | Archived. File sharing platform with links that can expire.                                    | [Details](services/pingvin-share) |
| **Radicale**      | CalDAV and CardDAV server that syncs calendars, to-do lists, and contacts.                     | [Details](services/radicale)      |
| **Resilio Sync**  | Peer-to-peer tool that syncs folders between your devices, without a central server.           | [Details](services/resilio-sync)  |
| **Seafile**       | File sync and sharing platform that stores files in libraries.                                 | [Details](services/seafile)       |
| **Stirling-PDF**  | PDF toolbox that runs on the server. The free plan covers five users.                          | [Details](services/stirlingpdf)   |
| **SubTrackr**     | Subscription tracker that shows monthly and yearly costs and when each one renews.             | [Details](services/subtrackr)     |
| **Sure**          | Fork of the archived Maybe finance app, for tracking accounts, investments, and net worth.     | [Details](services/sure)          |
| **Vikunja**       | To-do and project app with lists, boards, and Gantt charts.                                    | [Details](services/vikunja)       |
| **Wallos**        | Subscription tracker with payment reminders and budgets.                                       | [Details](services/wallos)        |
| **XWiki**         | Wiki for documentation and knowledge management.                                               | [Details](services/xwiki)         |

### Dashboards and visualization

| Service                | Description                                                                                 | Link                                   |
| ---------------------- | ------------------------------------------------------------------------------------------- | -------------------------------------- |
| **Glance**             | Dashboard that puts feeds, such as RSS, weather, and markets, on one page.                  | [Details](services/glance)             |
| **Homarr**             | Dashboard with user accounts that shows live data from the apps you connect.                | [Details](services/homarr)             |
| **Homepage**           | Dashboard that you set up in YAML files, with bookmarks and live data from apps and Docker. | [Details](services/homepage)           |
| **NewWallpaperWhoDis** | Wallpaper server that rotates your collection on browsers, tablets, TVs, and dashboards.    | [Details](services/newwallpaperwhodis) |

### Development tools

| Service       | Description                                                                             | Link                          |
| ------------- | --------------------------------------------------------------------------------------- | ----------------------------- |
| **Arcane**    | Web UI to manage Docker containers, images, networks, volumes, and Compose projects.    | [Details](services/arcane)    |
| **Coder**     | Platform for development environments and AI coding agents, from Terraform.             | [Details](services/coder)     |
| **CyberChef** | Web app for encoding, decoding, encrypting, compressing, and analyzing data.            | [Details](services/cyberchef) |
| **Dockge**    | Web interface to manage Docker Compose stacks.                                          | [Details](services/dockge)    |
| **Dockhand**  | Docker manager for local and remote hosts, free for home use.                           | [Details](services/dockhand)  |
| **Dozzle**    | Real-time log viewer for Docker containers.                                             | [Details](services/dozzle)    |
| **Forgejo**   | Community-governed fork of Gitea.                                                       | [Details](services/forgejo)   |
| **FossFLOW**  | Tool for drawing isometric infrastructure diagrams.                                     | [Details](services/fossflow)  |
| **Gitea**     | Git service with repositories, pull requests, issues, packages, and CI.                 | [Details](services/gitea)     |
| **GitSave**   | Backup tool for your Git repositories, run on a schedule.                               | [Details](services/gitsave)   |
| **IT-Tools**  | Online tools for developers and IT staff, such as converters and generators.            | [Details](services/it-tools)  |
| **Mailpit**   | Email testing tool that captures outgoing mail over SMTP for viewing and debugging.     | [Details](services/mailpit)   |
| **Node-RED**  | Low-code, flow-based tool for event-driven applications.                                | [Details](services/nodered)   |
| **Ollama**    | Runtime for large language models, with an OpenAI-compatible API and no login.          | [Details](services/ollama)    |
| **Portainer** | Web interface to manage Docker containers, images, volumes, and networks.               | [Details](services/portainer) |
| **SearXNG**   | Metasearch engine that combines results from many search services without tracking.     | [Details](services/searxng)   |

### Monitoring and analytics

| Service                | Description                                                                           | Link                                  |
| ---------------------- | ------------------------------------------------------------------------------------- | ------------------------------------- |
| **Beszel Agent**       | Agent that sends system and Docker stats to a Beszel hub.                             | [Details](services/beszel-agent)      |
| **Beszel Hub**         | Server monitor with history, Docker stats, and alerts.                                | [Details](services/beszel-hub)        |
| **changedetection.io** | Monitor that watches web pages and notifies you when their content changes.           | [Details](services/changedetection)   |
| **Portracker**         | Port tracker that discovers the services on your systems and maps the ports they use. | [Details](services/portracker)        |
| **Speedtest Tracker**  | Tool that runs scheduled internet speed tests and charts the results over time.       | [Details](services/speedtest-tracker) |
| **Umami**              | Web analytics that uses no cookies and collects no personal data.                     | [Details](services/umami)             |
| **Uptime Kuma**        | Monitor for websites and services that alerts you when they go down.                  | [Details](services/uptime-kuma)       |

### Smart home

| Service            | Description                                                                                                     | Link                               |
| ------------------ | --------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| **Frigate**        | Network video recorder with real-time AI object detection for IP cameras, using an optional GPU or accelerator. | [Details](services/frigate)        |
| **Home Assistant** | Home automation platform for local control of smart devices.                                                    | [Details](services/home-assistant) |

### Utilities

| Service        | Description                                                                                          | Link                            |
| -------------- | ---------------------------------------------------------------------------------------------------- | ------------------------------- |
| **ConvertX**   | Web file converter for more than a thousand formats.                                                 | [Details](services/convertx)    |
| **Gotify**     | Push notification server that shows messages from your scripts in its web interface and Android app. | [Details](services/gotify)      |
| **Hemmelig**   | Archived. Encrypted secret sharing by link, with secrets deleted after reading or on expiry.         | [Details](services/hemmelig)    |
| **Homebox**    | Home inventory for items, with location, quantity, warranty, and purchase details.                   | [Details](services/homebox)     |
| **LubeLogger** | Tracker for vehicle maintenance and fuel use.                                                        | [Details](services/lube-logger) |
| **Mini QR**    | Web app to create, style, and scan QR codes.                                                         | [Details](services/miniqr)      |
| **ntfy**       | Notification service that lets scripts and apps push messages to phones and browsers over HTTP.      | [Details](services/ntfy)        |
| **Tracktor**   | Tracker for vehicle fuel use, maintenance, insurance, and documents, with renewal dates.             | [Details](services/tracktor)    |
| **Transmute**  | Converter and compressor for images, video, audio, and documents, with a web UI and API.             | [Details](services/transmute)   |

### Food and wellness

| Service             | Description                                                                         | Link                           |
| ------------------- | ----------------------------------------------------------------------------------- | ------------------------------ |
| **KitchenOwl**      | Grocery list and recipe manager for households, with meal planning and expenses.    | [Details](services/kitchenowl) |
| **Mealie**          | Recipe manager and meal planner with shopping lists and imports from web addresses. | [Details](services/mealie)     |
| **Tandoor Recipes** | Recipe manager and meal planner with shopping lists.                                | [Details](services/tandoor)    |

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

Thank you to everyone who has contributed to ScaleTail.

<a href="https://github.com/tailscale-dev/ScaleTail/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tailscale-dev/ScaleTail" alt="ScaleTail contributors" />
</a>

Made with [contrib.rocks](https://contrib.rocks).

## Contributing

To add or update a service, follow [CONTRIBUTING.md](CONTRIBUTING.md) and start from the [service template](templates/service-template/).

## Star history

[![Star History Chart](https://api.star-history.com/svg?repos=tailscale-dev/scaletail&type=Date)](https://star-history.com/#tailscale-dev/scaletail&Date)

## License

[MIT](LICENSE)
