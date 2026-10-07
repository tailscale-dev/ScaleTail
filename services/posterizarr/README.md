# Posterizarr

[Posterizarr](https://github.com/fscorrupt/Posterizarr) creates posters, backgrounds, and title cards for your media library in one style. It reads your library from Plex, Jellyfin, or Emby and downloads the artwork from several sources.

This stack runs Posterizarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://posterizarr.<tailnet>.ts.net`                    |
| Service port  | `8000`                                                    |
| Image         | `ghcr.io/fscorrupt/posterizarr`                           |
| Data          | `./posterizarr-data/config` (configuration and database)  |
|               | `./posterizarr-data/assets` (created artwork)             |
|               | `./posterizarr-data/assetsbackup` (backup of the artwork) |
|               | `./posterizarr-data/manualassets` (your own artwork)      |

## Before you start

Create the data folders yourself and make user `1000` their owner. Docker creates missing folders as user `root`. The stack runs Posterizarr as user and group `1000`, and it then fails with `Permission denied: '/config/database'`.

```bash
mkdir -p posterizarr-data/config posterizarr-data/assets posterizarr-data/assetsbackup posterizarr-data/manualassets
sudo chown -R 1000:1000 posterizarr-data
```

## Deviations from the standard setup

- **Fixed user.** The `application` container runs as user and group `1000` through the `user` setting.
- **No scheduled runs.** `RUN_TIME=disabled` turns off the schedule of the container. You start runs from the web interface.

## First run

Posterizarr has no login by default. Open the web interface and enter the details of your media server and your API keys in the configuration. To reach a media server in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Posterizarr documentation and source code](https://github.com/fscorrupt/Posterizarr)
