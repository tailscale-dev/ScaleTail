# Homarr

[Homarr](https://homarr.dev/) is a dashboard for your services. It shows your applications on one page and integrates with many of them to display live information.

This stack runs Homarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://homarr.<tailnet>.ts.net` |
| Service port  | `7575`                            |
| Image         | `ghcr.io/homarr-labs/homarr`      |
| Data          | `./homarr-data/appdata`           |

## Before you start

Set `SECRET_ENCRYPTION_KEY` in `.env` to a hex key of 64 characters. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface and follow the onboarding. Homarr asks you to create the administrator account.

## Upgrading

If you set `SECRET_ENCRYPTION_KEY` in `compose.yaml` before, move that value to `.env`. A new key cannot decrypt the secrets of the integrations that Homarr already stored.

## Links

- [Homarr documentation](https://homarr.dev/docs/getting-started/)
- [Homarr source code](https://github.com/homarr-labs/homarr)
