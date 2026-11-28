# Kometa

[Kometa](https://github.com/Kometa-Team/Kometa), formerly Plex Meta Manager, builds collections, overlays, and playlists in a Plex server and updates their metadata, based on a YAML configuration file. It runs on a schedule, by default once a day at 05:00.

This stack runs Kometa with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                            |
| ------------- | ---------------------------------------------------------------- |
| Web interface | None                                                             |
| Image         | `kometateam/kometa:latest`                                       |
| Data          | `./kometa-data/config` (`config.yml` and the logs)               |

## Before you start

Kometa does nothing until you fill in `config.yml` after the first start. Have these ready:

- **Plex URL.** An address of your Plex server that the Kometa container can reach, not `app.plex.tv`. For a Plex server on your Tailnet, such as the [Plex stack](../plex/README.md) of this repository, use the Tailscale IP address of the Plex device, for example `http://100.64.0.1:32400`.
- **Plex token.** See [Finding an authentication token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/).
- **TMDb API key.** Kometa does not run without one. Create a free account at [TMDb](https://www.themoviedb.org/settings/api) and use the v3 key.
- **Schedule.** `KOMETA_TIMES` in `.env` sets when Kometa runs each day, in the time zone from `TZ`. The default is `05:00`.

## Deviations from the standard setup

- **No web interface.** The stack has no Tailscale Serve configuration, no `./config` folder, and no `ports` block. Kometa only makes outgoing connections: to Plex, to TMDb and other metadata sites, and to services you add, such as Radarr, Sonarr, or Tautulli. The sidecar lets it reach those services on your Tailnet.
- **Runs as root.** The image has no `user` setting and runs as root. Files that Kometa creates in `./kometa-data/config` belong to root, so edit `config.yml` with `sudo`.
- **Health check.** The image has no health check and no `pgrep`, so the check looks for the `python3` process, which is Kometa.

## First run

1. Start the stack. On the first start, Kometa downloads a template `config.yml` to `./kometa-data/config` and exits. Docker starts it again, and Kometa then waits for the time in `KOMETA_TIMES`.
2. Edit `./kometa-data/config/config.yml`. Set `url` and `token` under `plex` and `apikey` under `tmdb`. Under `libraries`, use the names of your Plex libraries exactly as Plex shows them. Remove the sections of the template that you do not use, such as the notification services, or Kometa reports them as errors in every run.
3. To run Kometa right away instead of waiting for the schedule:

   ```bash
   docker exec app-kometa python3 kometa.py --run
   ```

   The log shows `TMDb Connection Successful`, then `Connecting to Plex Libraries...` with no errors. Check Plex for the new collections. Wait until a run has finished before you start another one.

## Troubleshooting

- **The log stays empty.** While Kometa waits for its schedule, `docker compose logs` shows nothing, because Kometa prints its countdown only in an interactive terminal. The full log of each run is in `./kometa-data/config/logs/meta.log`.
- **Plex is not reachable.** Use the Tailscale IP address of the Plex device in `config.yml`. To use its MagicDNS name instead, uncomment `TS_ACCEPT_DNS=true` in `compose.yaml`, as described in the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Kometa documentation](https://kometa.wiki/en/latest/)
- [Kometa Docker images](https://kometa.wiki/en/latest/kometa/install/images/)
- [Kometa install guide](https://kometa.wiki/en/latest/kometa/install/)
- [Kometa run commands and environment variables](https://kometa.wiki/en/latest/kometa/environmental/)
- [Kometa source code](https://github.com/Kometa-Team/Kometa)
- [Kometa on Docker Hub](https://hub.docker.com/r/kometateam/kometa)
