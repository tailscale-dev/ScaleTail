# Navidrome

[Navidrome](https://www.navidrome.org/) is a music server. It streams your own music collection to its web player and to the many apps that support the Subsonic API.

This stack runs Navidrome with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://navidrome.<tailnet>.ts.net`                          |
| Service port  | `4533`                                                        |
| Image         | `deluan/navidrome`                                            |
| Data          | `./navidrome-data/data` (database and cache)                  |
|               | The folder that you mount at `/music` (your music, read-only) |

## Before you start

Replace `/path/to/your/music/folder` in `compose.yaml` with the absolute path of the folder on the Docker host that holds your music.

## Deviations from the standard setup

- **Time zone.** `compose.yaml` does not pass `TZ` to the container.

## First run

Open the web interface and create the administrator account. Navidrome then scans your music folder.

In Subsonic apps, use `https://navidrome.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Links

- [Navidrome documentation](https://www.navidrome.org/docs/)
- [Navidrome source code](https://github.com/navidrome/navidrome)
