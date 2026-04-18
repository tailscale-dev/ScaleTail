# Minecraft Server with Tailscale Sidecar Configuration

This Docker Compose configuration sets up a [Minecraft Java Edition](https://www.minecraft.net/) server with Tailscale as a sidecar container, enabling private multiplayer access over your Tailnet. No port forwarding or public IP required — only players on your Tailscale network can connect.

## Minecraft

[Minecraft](https://www.minecraft.net/) is one of the most popular sandbox games in the world, offering open-ended survival, building, and exploration gameplay. This configuration uses the [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server) Docker image, the community standard with support for Vanilla, Paper, Fabric, Forge, and other server types.

## Key Features

* **Private multiplayer** — no router ports need to be opened; all traffic stays on your Tailnet.
* **MagicDNS hostname** — players connect using `minecraft.<tailnet-name>.ts.net:25565`.
* **Multiple server types** — switch between Vanilla, Paper, Fabric, Forge, Spigot, and Bukkit via an environment variable.
* **Persistent world data** — world files and server config are stored in a named Docker volume.
* **Fully configurable** — server type, version, difficulty, player limit, MOTD, and memory are all set through `.env`.

## Networking Note

Unlike web-based services in this repository, Minecraft uses **raw TCP on port 25565**. Tailscale Serve and Funnel only proxy HTTP/HTTPS traffic, so they are **not used here**. Instead, the Minecraft server listens directly on the Tailscale interface and players connect at:

```text
minecraft.<tailnet-name>.ts.net:25565
```

No `serve.json` configuration is needed for this service.

## Configuration Overview

In this setup, the `tailscale-minecraft` service runs the Tailscale client to join your private mesh network. The `minecraft` service is configured with `network_mode: service:tailscale-minecraft`, so all network traffic for the game server is routed through the Tailscale container. The Minecraft server binds TCP port 25565, which is reachable only from devices on your Tailnet.

## Setup

1. Clone the repository and navigate to the service directory:

   ```bash
   git clone https://github.com/tailscale-dev/ScaleTail.git
   cd ScaleTail/services/minecraft
   ```

2. Edit `.env` and paste in your Tailscale auth key (from [https://login.tailscale.com/admin/settings/keys](https://login.tailscale.com/admin/settings/keys)).

3. (Optional) Adjust `SERVER_TYPE`, `MEMORY`, `MAX_PLAYERS`, or other variables in `.env`.

4. Start the stack:

   ```bash
   docker compose up -d
   ```

5. Find your Tailnet name in the [Tailscale admin console](https://login.tailscale.com/admin/machines).

6. Connect in Minecraft: **Multiplayer** → **Add Server** → `minecraft.<tailnet-name>.ts.net`

## Connecting

* All players must be on the same Tailnet (or have been shared access to the node).
* `ONLINE_MODE=false` allows offline/non-premium accounts but reduces security — only use this on trusted networks.
* Bedrock Edition uses UDP port 19132, which is not proxied through Tailscale Serve. Bedrock players can still connect directly via the Tailscale IP on port 19132, but this requires using the Bedrock edition of itzg/minecraft-server (set `TYPE=BEDROCK`) and is outside the scope of this configuration.

## Environment Variables

| Variable | Default | Description |
| --- | --- | --- |
| `TS_AUTHKEY` | _(empty)_ | Tailscale auth key from the admin console |
| `SERVER_TYPE` | `PAPER` | Server software: VANILLA, PAPER, FABRIC, FORGE, SPIGOT, BUKKIT |
| `MINECRAFT_VERSION` | `LATEST` | Game version: LATEST or a pinned version like 1.21.4 |
| `DIFFICULTY` | `normal` | Game difficulty: peaceful, easy, normal, hard |
| `MAX_PLAYERS` | `10` | Maximum concurrent players |
| `MOTD` | `A Minecraft Server on Tailscale` | Message shown in the server browser |
| `MEMORY` | `2G` | JVM heap size — increase for larger worlds or player counts |
| `ONLINE_MODE` | `true` | Require valid Minecraft accounts (set false for offline/LAN play) |

## Useful Links

* [itzg/minecraft-server on Docker Hub](https://hub.docker.com/r/itzg/minecraft-server)
* [itzg/minecraft-server documentation](https://docker-minecraft-server.readthedocs.io)
* [Tailscale Serve docs](https://tailscale.com/kb/1242/tailscale-serve)
* [Tailscale Funnel docs](https://tailscale.com/kb/1223/funnel)
* [Tailscale Docker guide](https://tailscale.com/blog/docker-tailscale-guide)
