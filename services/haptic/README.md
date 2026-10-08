# Haptic

[Haptic](https://github.com/chroxify/haptic) is a local-first editor for your Markdown notes. The web version keeps your notes in the browser.

This stack runs Haptic with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://haptic.<tailnet>.ts.net` |
| Service port  | `80`                              |
| Image         | `chroxify/haptic-web`             |
| Data          | None                              |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No data folder.** The stack has no volumes. Haptic stores your notes in the browser of each device, not on the server.

## First run

Nothing to set up. Open the web interface.

## Links

- [Haptic documentation and source code](https://github.com/chroxify/haptic)
