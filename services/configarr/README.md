# Configarr

[Configarr](https://github.com/raydak-labs/configarr) keeps the settings of Radarr, Sonarr, and related applications in sync with YAML files. It applies custom formats and quality profiles, for example from the TRaSH Guides.

This stack runs Configarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                            |
| ------------- | ---------------------------------------------------------------- |
| Web interface | None                                                             |
| Image         | `ghcr.io/raydak-labs/configarr`                                  |
| Data          | `./configarr-data/config` (your `config.yml` and `secrets.yml`)  |
|               | `./configarr-data/dockerrepos` (downloaded guides and templates) |

## Before you start

Create `config.yml` and `secrets.yml` in `./configarr-data/config`. The [Configarr documentation](https://configarr.de/docs/intro) describes both files. To reach Radarr or Sonarr in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Deviations from the standard setup

- **No web interface.** The stack has no Tailscale Serve configuration and no `./config` folder. Configarr only makes outgoing connections to your applications.
- **Runs once.** The `application` container runs one sync and then exits, so the stack uses `restart: "no"`.

## First run

Start the stack and read the result of the sync in the log:

```bash
docker compose up -d
docker logs app-configarr
```

To sync on a schedule, run `docker compose up application` from cron or another scheduler.

## Links

- [Configarr documentation](https://configarr.de/docs/intro)
- [Configarr source code](https://github.com/raydak-labs/configarr)
- [Configarr presets](https://github.com/ChillBill77/configarr-presets)
