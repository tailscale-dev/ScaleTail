# Minecraft Bedrock Server with Tailscale Sidecar Configuration

This Docker Compose configuration sets up a [Minecraft Bedrock Edition](https://www.minecraft.net/en-us/about-minecraft) server with Tailscale as a sidecar container, enabling private multiplayer access over your Tailnet. No port forwarding or public IP required — only players on your Tailscale network can connect.

## Minecraft Bedrock

[Minecraft Bedrock Edition](https://www.minecraft.net/en-us/about-minecraft) is the cross-platform variant that runs on Windows 10/11, mobile, and consoles. This configuration uses the [itzg/minecraft-bedrock-server](https://hub.docker.com/r/itzg/minecraft-bedrock-server) Docker image. For the **Java Edition** server (TCP 25565, plugin/mod support), see [services/minecraft](../minecraft/).

## Networking Note

Bedrock uses **raw UDP on port 19132**. Tailscale Serve and Funnel only proxy HTTPS, so neither is used here — there is no `serve.json` block in the compose file. The Bedrock server listens directly on the Tailscale interface and players connect at the Tailnet IP or MagicDNS hostname of the node.

## Configuration Overview

The `tailscale-minecraft-bedrock` service runs the Tailscale client to join your Tailnet. The application service uses `network_mode: service:tailscale`, so the Bedrock server's UDP 19132 binds inside the Tailscale container's network namespace and is reachable from Tailnet peers only.

## Setup

1. Clone the repository and navigate to the service directory:

   ```bash
   git clone https://github.com/tailscale-dev/ScaleTail.git
   cd ScaleTail/services/minecraft-bedrock
   ```

2. Edit `.env`:
   - Paste your Tailscale auth key into `TS_AUTHKEY=`.
   - Set `EULA=TRUE` to accept the [Mojang EULA](https://www.minecraft.net/en-us/eula). The server will not start until you do.
   - (Optional) Adjust `SERVER_NAME`, `GAMEMODE`, `DIFFICULTY`, `MAX_PLAYERS`, etc.

3. (OPTIONAL) Pre-create the data directories so Docker does not create them as `root`:

   ```bash
   mkdir -p minecraft-bedrock-data ts/state
   ```

4. Start the stack:

   ```bash
   docker compose up -d
   ```

5. Find your Tailnet name in the [Tailscale admin console](https://login.tailscale.com/admin/machines).

## Connecting

Bedrock clients (Windows / mobile / console) cannot enter a custom port through the in-game Quick Server interface on every platform. Two options:

- **Add Server (Bedrock 1.16+)**: Servers tab → Add Server. Enter the Tailnet IP or `minecraft-bedrock.<tailnet-name>.ts.net` and port `19132`.
- **Direct Connect**: enter the address and port at the connect prompt where supported.

Notes:

- All players must be on the same Tailnet (or have been shared access to the node).
- `ONLINE_MODE=false` allows clients without an Xbox Live account but reduces security — use only on trusted networks.

## Server Console

Attach to the running container for in-server commands (`/op`, `/stop`, `/save`, etc.):

```bash
docker attach app-minecraft-bedrock
```

Detach without stopping the server: `Ctrl-p Ctrl-q`.

## Environment Variables

| Variable | Default | Description |
| --- | --- | --- |
| `TS_AUTHKEY` | _(empty)_ | Tailscale auth key from the admin console |
| `EULA` | `FALSE` | Must be `TRUE` to accept Mojang's EULA before the server will start |
| `VERSION` | `LATEST` | Bedrock version: `LATEST` or a pinned version like `1.21.50` |
| `SERVER_NAME` | `A Minecraft Bedrock Server on Tailscale` | Name shown in the Bedrock server list |
| `GAMEMODE` | `survival` | `survival`, `creative`, or `adventure` |
| `DIFFICULTY` | `normal` | `peaceful`, `easy`, `normal`, or `hard` |
| `LEVEL_NAME` | `Bedrock level` | World name (also the directory name on disk) |
| `MAX_PLAYERS` | `10` | Maximum concurrent players |
| `ONLINE_MODE` | `true` | Require Xbox Live accounts (set false for offline play) |

## Useful Links

- [MUST READ - Bedrock DNS redirect for XBOX](https://github.com/Pugmatt/BedrockConnect)
- [itzg/minecraft-bedrock-server on Docker Hub](https://hub.docker.com/r/itzg/minecraft-bedrock-server)
- [itzg/minecraft-bedrock-server on GitHub](https://github.com/itzg/docker-minecraft-bedrock-server)
- [Mojang EULA](https://www.minecraft.net/en-us/eula)
- [Tailscale Docker guide](https://tailscale.com/blog/docker-tailscale-guide)
