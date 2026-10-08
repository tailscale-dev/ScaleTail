# CyberChef

[CyberChef](https://github.com/gchq/CyberChef) is a web application for encoding, decoding, encrypting, compressing, and analysing data. You combine operations into a recipe by drag and drop.

This stack runs CyberChef with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://cyberchef.<tailnet>.ts.net` |
| Service port  | `8080`                               |
| Image         | `ghcr.io/gchq/cyberchef`             |
| Data          | None                                 |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No data folder.** CyberChef runs in your browser and stores nothing on the server, so the stack has no volumes.

## First run

Nothing to set up. Open the web interface.

## Links

- [CyberChef documentation](https://github.com/gchq/CyberChef/wiki)
- [CyberChef source code](https://github.com/gchq/CyberChef)
