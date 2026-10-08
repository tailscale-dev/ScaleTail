# Sonarr

[Sonarr](https://github.com/Sonarr/Sonarr) manages your series collection. It searches Usenet and BitTorrent sources for new episodes, sends them to your download client, and sorts the files into your library.

This stack runs Sonarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                        |
| ------------- | ------------------------------------------------------------ |
| Web interface | `https://sonarr.<tailnet>.ts.net`                            |
| Service port  | `8989`                                                       |
| Image         | `lscr.io/linuxserver/sonarr`                                 |
| Data          | `./sonarr-data/config` (configuration and database)          |
|               | `./sonarr-data/media/tvseries` (series library, optional)    |
|               | `./sonarr-data/downloads` (download client output, optional) |

## Before you start

Point the `/tv` and `/downloads` volumes in `compose.yaml` at your series library and at the output folder of your download client. Both are optional and default to empty folders in `./sonarr-data`. Docker creates missing folders as user `root`. The container runs as user and group `1000`, which need write access to both folders.

## Deviations from the standard setup

None.

## First run

Open the web interface. Sonarr asks you to choose an authentication method and to create a username and password before you can continue.

## Links

- [Sonarr documentation](https://wiki.servarr.com/sonarr)
- [Sonarr source code](https://github.com/Sonarr/Sonarr)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-sonarr/)
- [Configarr presets](https://github.com/ChillBill77/configarr-presets), for help with quality profiles and download quality
