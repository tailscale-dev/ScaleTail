# Bazarr

[Bazarr](https://www.bazarr.media/) downloads subtitles for the movies and series that Radarr and Sonarr manage.

This stack runs Bazarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                               |
| ------------- | --------------------------------------------------- |
| Web interface | `https://bazarr.<tailnet>.ts.net`                   |
| Service port  | `6767`                                              |
| Image         | `lscr.io/linuxserver/bazarr`                        |
| Data          | `./bazarr-data/config` (configuration and database) |
|               | `./bazarr-data/media/movies` (movie library)        |
|               | `./bazarr-data/media/tvseries` (series library)     |

## Before you start

Point the `/movies` and `/tv` volumes in `compose.yaml` at the folders that Radarr and Sonarr use, because Bazarr stores the subtitles next to the video files. Docker creates missing folders as user `root`. The container runs as user and group `1000`, which need write access to both folders.

## Deviations from the standard setup

None.

## First run

Bazarr has no login by default. Open the web interface and go to **Settings**:

1. Under **Sonarr** and **Radarr**, enter the address, port, and API key of each application.
2. Under **Languages**, choose your subtitle languages and create a language profile.
3. Under **Providers**, enable the subtitle providers you want to use.

To reach Sonarr or Radarr in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Bazarr setup guide](https://wiki.bazarr.media/Getting-Started/Setup-Guide/)
- [Bazarr source code](https://github.com/morpheus65535/bazarr)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-bazarr/)
