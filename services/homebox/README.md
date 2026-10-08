# Homebox

[Homebox](https://homebox.software/) is an inventory for your home. You record your items with their location, quantity, warranty, and purchase details.

This stack runs Homebox with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://homebox.<tailnet>.ts.net` |
| Service port  | `7745`                             |
| Image         | `ghcr.io/sysadminsmedia/homebox`   |
| Data          | `./homebox-data`                   |

## Before you start

1. Create the data folder yourself and make user `65532` its owner. Docker creates missing folders as user `root`. The stack runs Homebox as user and group `65532`, which cannot write to a folder that `root` owns.

   ```bash
   mkdir -p homebox-data
   sudo chown 65532:65532 homebox-data
   ```

2. Set `HBOX_AUTH_API_KEY_PEPPER` in `.env` to a random value of at least 32 bytes. Generate one with `openssl rand -base64 48`. Compose stops with an error if it is empty. If you change the value later, all issued API keys become invalid.

## Deviations from the standard setup

- **Fixed user.** The `application` container runs as user and group `65532` through the `user` setting.

## First run

Open the web interface and register the first account.

## Links

- [Homebox documentation](https://homebox.software/en/)
- [Homebox source code](https://github.com/sysadminsmedia/homebox)
