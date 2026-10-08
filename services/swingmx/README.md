# Swing Music

[Swing Music](https://swingmx.com/) is a music player and streaming server for your own audio files, with a web interface that resembles the commercial streaming services.

This stack runs Swing Music with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                  |
| ------------- | ------------------------------------------------------ |
| Web interface | `https://swingmusic.<tailnet>.ts.net`                  |
| Service port  | `1970`                                                 |
| Image         | `ghcr.io/swingmx/swingmusic`                           |
| Data          | `./swingmusic-data/app/config` (settings and database) |
|               | The folder that you mount at `/music` (your music)     |

## Before you start

Replace `/path/to/music` in `compose.yaml` with the absolute path of the folder on the Docker host that holds your music.

## Deviations from the standard setup

- **Device name.** `SERVICE` in `.env` is `swingmusic`, which differs from the name of this directory.

## First run

Open the web interface and follow the setup. You create your account and select `/music` as your music folder.

## Links

- [Swing Music documentation](https://swingmx.com/guide/introduction.html)
- [Swing Music source code](https://github.com/swingmx/swingmusic)
