# BentoPDF

[BentoPDF](https://github.com/alam00000/bentopdf) is a toolkit for PDF files. You merge, split, compress, convert, and edit PDF files in your browser, and the files do not leave your device.

This stack runs BentoPDF with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://bentopdf.<tailnet>.ts.net` |
| Service port  | `8080`                              |
| Image         | `ghcr.io/alam00000/bentopdf`        |
| Data          | None                                |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No application data.** BentoPDF processes the files in your browser and stores nothing on the server. The `./bentopdf-data/app/config` volume from the template stays empty.
- **Service port.** BentoPDF listens on port `8080`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

Nothing to set up. Open the web interface.

## Links

- [BentoPDF documentation and source code](https://github.com/alam00000/bentopdf)
