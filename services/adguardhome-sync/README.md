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

- **`ORIGIN_URL` and `ORIGIN_USERNAME`.** The AdGuard Home instance to copy from.
- **`REPLICA1_URL` and `REPLICA1_USERNAME`.** The instance to copy to.
- **`CRON`.** The schedule. The sample value runs a sync every minute.

Set the passwords in `.env`:

- **`ORIGIN_PASSWORD` and `REPLICA1_PASSWORD`.** The passwords of the two instances. Compose stops with an error if one of them is empty.

To reach an AdGuard Home instance on your Tailnet, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Deviations from the standard setup

- **No Tailscale Serve.** The stack has no Serve configuration. The tool only makes outgoing connections to your AdGuard Home instances.
- **Start command.** The stack starts the tool with the `run` command.
- **No data folder.** The tool stores nothing on disk. The settings are in `compose.yaml`, and the passwords are in `.env`.

## First run

Check the log to see whether the sync works:

```bash
docker logs app-adguardhome-sync
```

## Upgrading

Earlier versions of this stack had the sample value `password` for `ORIGIN_PASSWORD` and `REPLICA1_PASSWORD` in `compose.yaml`. The passwords are now in `.env`. They are empty, and Compose stops with an error until you set them. If you already run the stack, move your passwords from `compose.yaml` to `.env`.

## Links

- [AdGuard Home Sync documentation and source code](https://github.com/bakito/adguardhome-sync)
