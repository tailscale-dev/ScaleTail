# Seerr

[Seerr](https://github.com/seerr-team/seerr) is a request manager for your media library. Users search for movies and series and request them, and Seerr passes approved requests to Radarr and Sonarr. It works with Plex, Jellyfin, and Emby.

This stack runs Seerr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                            |
| ------------- | -------------------------------- |
| Web interface | `https://seerr.<tailnet>.ts.net` |
| Service port  | `5055`                           |
| Image         | `ghcr.io/seerr-team/seerr`       |
| Data          | `./seerr-data/config`            |

## Before you start

Create the configuration folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. The Seerr image runs as user and group `1000`, and it then exits with `EACCES` when it creates `/app/config/logs`.

```bash
mkdir -p seerr-data/config
sudo chown -R 1000:1000 seerr-data
```

## Deviations from the standard setup

- **Log level.** `compose.yaml` sets `LOG_LEVEL=debug`.

## First run

Open the web interface and follow the setup. You choose your media server, sign in with it, and add Radarr and Sonarr. To reach an application in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Seerr documentation](https://docs.seerr.dev/)
- [Seerr source code](https://github.com/seerr-team/seerr)
