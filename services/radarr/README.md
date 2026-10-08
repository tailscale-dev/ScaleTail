# Radarr

[Radarr](https://github.com/Radarr/Radarr) manages your movie collection. It searches Usenet and BitTorrent sources for the movies you want, sends them to your download client, and sorts the files into your library.

This stack runs Radarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://radarr.<tailnet>.ts.net`                             |
| Service port  | `7878`                                                        |
| Image         | `lscr.io/linuxserver/radarr`                                  |
| Data          | `./radarr-data/config` (configuration and database)           |
|               | `./radarr-data/media/movies` (movie library, optional)        |
|               | `./radarr-data/downloads` (download client output, optional)  |

## Before you start

Point the `/movies` and `/downloads` volumes in `compose.yaml` at your movie library and at the output folder of your download client. Both are optional and default to empty folders in `./radarr-data`. Docker creates missing folders as user `root`. The container runs as user and group `1000`, which need write access to both folders.

## Deviations from the standard setup

None.

## First run

Open the web interface. Radarr asks you to choose an authentication method and to create a username and password before you can continue.

## Links

- [Radarr documentation](https://wiki.servarr.com/radarr)
- [Radarr source code](https://github.com/Radarr/Radarr)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-radarr/)
- [Configarr presets](https://github.com/ChillBill77/configarr-presets), for help with quality profiles and download quality
