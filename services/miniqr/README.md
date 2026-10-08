# Mini QR

[Mini QR](https://github.com/lyqht/mini-qr) creates and scans QR codes in your browser. You style the code with colours, shapes, and a logo and export it as an image.

This stack runs Mini QR with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://mini-qr.<tailnet>.ts.net` |
| Service port  | `8080`                             |
| Image         | `ghcr.io/lyqht/mini-qr`            |
| Data          | None                               |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Device name.** `SERVICE` in `.env` is `mini-qr`, which differs from the name of this directory.
- **No data folder.** Mini QR runs in your browser and stores nothing on the server, so the stack has no application data.

## First run

Nothing to set up. Open the web interface.

## Links

- [Mini QR documentation and source code](https://github.com/lyqht/mini-qr)
