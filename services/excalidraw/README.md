# Excalidraw

[Excalidraw](https://github.com/excalidraw/excalidraw) is a virtual whiteboard for diagrams and sketches with a hand-drawn look.

This stack runs Excalidraw with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://excalidraw.<tailnet>.ts.net` |
| Service port  | `80`                                  |
| Image         | `excalidraw/excalidraw`               |
| Data          | None                                  |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No application data.** Excalidraw keeps your drawings in the browser and stores nothing on the server. The `./excalidraw-data/app/config` volume from the template stays empty.

## First run

Nothing to set up. Open the web interface.

## Links

- [Excalidraw documentation](https://docs.excalidraw.com/)
- [Excalidraw source code](https://github.com/excalidraw/excalidraw)
