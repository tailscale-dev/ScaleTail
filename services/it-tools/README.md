# IT-Tools

[IT-Tools](https://github.com/CorentinTh/it-tools) is a collection of tools for developers and IT staff, such as converters, encoders, formatters, and generators.

This stack runs IT-Tools with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://it-tools.<tailnet>.ts.net` |
| Service port  | `80`                                |
| Image         | `corentinth/it-tools`               |
| Data          | None                                |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No data folder.** IT-Tools runs in your browser and stores nothing on the server, so the stack has no volumes.

## First run

Nothing to set up. Open the web interface.

## Links

- [IT-Tools source code](https://github.com/CorentinTh/it-tools)
