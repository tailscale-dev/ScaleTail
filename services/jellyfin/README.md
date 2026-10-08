# Jellyfin

[Jellyfin](https://jellyfin.org/) is a media server. It organises your movies, series, and music and streams them to your browser, television, and mobile devices.

This stack runs Jellyfin with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://jellyfin.<tailnet>.ts.net`                           |
| Service port  | `8096`                                                        |
| Image         | `lscr.io/linuxserver/jellyfin`                                |
| Data          | `./jellyfin-data/config` (configuration, database, and cache) |
|               | `./media/movies` (movie library)                              |
|               | `./media/tvseries` (series library)                           |

## Before you start

Point the `/data/movies` and `/data/tvshows` volumes in `compose.yaml` at your own media folders. Otherwise the stack starts with empty folders in `./media`.

## Deviations from the standard setup

- **Media folders.** The libraries are in `./media`, outside the `./jellyfin-data` folder.

## First run

Open the web interface. The setup wizard asks for the display language, the administrator account, your media libraries, and the metadata language. Use `/data/movies` and `/data/tvshows` as the library folders.

In the Jellyfin apps, use `https://jellyfin.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Links

- [Jellyfin documentation](https://jellyfin.org/docs/)
- [Jellyfin source code](https://github.com/jellyfin/jellyfin)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-jellyfin/)
