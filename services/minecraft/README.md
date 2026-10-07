# Minecraft Server

This stack runs a [Minecraft Java Edition](https://www.minecraft.net/) server with the [`itzg/minecraft-server`](https://docker-minecraft-server.readthedocs.io) image, which supports Vanilla, Paper, Fabric, Forge, and other server types. Players connect to it over your Tailnet.

This stack runs Minecraft Server with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| Web interface | None                                                        |
| Game server   | `minecraft.<tailnet>.ts.net`, TCP port `25565`              |
| Image         | `itzg/minecraft-server`                                     |
| Data          | `./minecraft-data` (world, configuration, and server files) |

## Before you start

The defaults work without changes. You can adjust these values in `.env`:

| Variable            | Default                           | Description                                                    |
| ------------------- | --------------------------------- | -------------------------------------------------------------- |
| `SERVER_TYPE`       | `VANILLA`                         | Server software: VANILLA, PAPER, FABRIC, FORGE, SPIGOT, BUKKIT |
| `MINECRAFT_VERSION` | `LATEST`                          | Game version: LATEST or a fixed version such as 1.21.4         |
| `DIFFICULTY`        | `normal`                          | Game difficulty: peaceful, easy, normal, hard                  |
| `MAX_PLAYERS`       | `10`                              | Maximum number of players at the same time                     |
| `MOTD`              | `A Minecraft Server on Tailscale` | Message in the server list                                     |
| `MEMORY`            | `2G`                              | Java heap size; increase it for larger worlds or more players  |

## Deviations from the standard setup

- **No Tailscale Serve.** Minecraft uses its own protocol on TCP port `25565`, which Tailscale Serve does not forward. The server listens on that port of the Tailscale IP address of the device, and the stack has no Serve configuration.
- **License agreement.** `compose.yaml` sets `EULA=TRUE`, which accepts the [Minecraft End User License Agreement](https://www.minecraft.net/eula) for you.

## First run

1. Start the stack. The first start takes a while, because the image downloads the server.
2. In Minecraft, select **Multiplayer** > **Add Server** and enter `minecraft.<tailnet>.ts.net`.

All players must be on your Tailnet, or you must share the device with them.

## Configuration

- **Bedrock Edition.** Bedrock uses UDP port `19132` and another server type, which this stack does not set up.

## Links

- [itzg/minecraft-server documentation](https://docker-minecraft-server.readthedocs.io)
- [itzg/minecraft-server on Docker Hub](https://hub.docker.com/r/itzg/minecraft-server)
