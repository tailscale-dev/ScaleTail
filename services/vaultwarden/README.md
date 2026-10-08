# Vaultwarden

[Vaultwarden](https://github.com/dani-garcia/vaultwarden) is a password manager server that works with the Bitwarden apps and browser extensions.

This stack runs Vaultwarden with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | `https://vaultwarden.<tailnet>.ts.net` |
| Service port  | `80`                                   |
| Image         | `vaultwarden/server`                   |
| Data          | `./vaultwarden-data/vw-data`           |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

1. Open the web interface and select **Create account**.
2. Registration is open to everyone who can reach the device on your Tailnet. After you created your accounts, set `SIGNUPS_ALLOWED` to `"false"` in `compose.yaml` and restart the stack.
3. In the Bitwarden apps and browser extensions, choose a self-hosted server and enter `https://vaultwarden.<tailnet>.ts.net`. The device must be connected to your Tailnet.

## Configuration

### Admin page

The admin page at `/admin` is disabled by default. To enable it, add an `ADMIN_TOKEN` to the `environment` block of `compose.yaml`. See [Enabling admin page](https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page).

## Links

- [Vaultwarden wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Vaultwarden source code](https://github.com/dani-garcia/vaultwarden)
