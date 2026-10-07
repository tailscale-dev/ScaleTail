# AdGuard Home Sync

[AdGuard Home Sync](https://github.com/bakito/adguardhome-sync) copies the configuration of one AdGuard Home instance to one or more replicas, including filters, rewrites, clients, and DNS settings.

This stack runs AdGuard Home Sync with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                           |
| ------------- | ------------------------------------------------------------------------------- |
| Web interface | None                                                                            |
| Service port  | `8080` on the Tailscale IP address of `adguardhome-sync` (API of the sync tool) |
| Image         | `ghcr.io/bakito/adguardhome-sync`                                               |
| Data          | None                                                                            |

## Before you start

Replace the sample values in the `environment` block of `compose.yaml`:

- **`ORIGIN_URL`, `ORIGIN_USERNAME`, `ORIGIN_PASSWORD`.** The AdGuard Home instance to copy from.
- **`REPLICA1_URL`, `REPLICA1_USERNAME`, `REPLICA1_PASSWORD`.** The instance to copy to.
- **`CRON`.** The schedule. The sample value runs a sync every minute.

To reach an AdGuard Home instance on your Tailnet, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Deviations from the standard setup

- **No Tailscale Serve.** The stack has no Serve configuration. The tool only makes outgoing connections to your AdGuard Home instances.
- **Start command.** The stack starts the tool with the `run` command.
- **No data folder.** The tool stores nothing on disk. All settings are in `compose.yaml`.

## First run

Check the log to see whether the sync works:

```bash
docker logs app-adguardhome-sync
```

## Links

- [AdGuard Home Sync documentation and source code](https://github.com/bakito/adguardhome-sync)
