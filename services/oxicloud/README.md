# SERVICE

[OxiCloud](https://atalayalabs.github.io/OxiCloud/) A fast self-hosted cloud for people who want files, calendars, contacts, and office editing without dragging a heavy stack behind them.

This stack runs Oxicloud with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://oxicloud.<tailnet>.ts.net` |
| Service port  | `8086`                             |
| Image         | `diocrafts/oxicloud:latest`        |
| Data          | `./oxicloud-data/`                 |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

Additional container for postgres DB.

## First run

Open the web interface and follow the setup.

## Links

- [SERVICE documentation](https://github.com/AtalayaLabs/OxiCloud)
- [SERVICE source code](https://github.com/AtalayaLabs/OxiCloud)
