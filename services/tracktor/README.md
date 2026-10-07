# Tracktor

[Tracktor](https://github.com/javedh-dev/tracktor) manages your vehicles. You track fuel use, maintenance, insurance, and documents with their renewal dates.

Tracktor is under active development and can have breaking changes. Back up your data before you update.

This stack runs Tracktor with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://tracktor.<tailnet>.ts.net` |
| Service port  | `3000`                              |
| Image         | `ghcr.io/javedh-dev/tracktor`       |
| Data          | `./tracktor-data`                   |

## Before you start

Set `TS_TAILNET` in `.env` to your Tailnet name without `.ts.net`, for example `tail123abc`. `compose.yaml` builds the allowed browser origin from it, such as `https://tracktor.tail123abc.ts.net`.

## Deviations from the standard setup

- **Allowed origin.** `CORS_ORIGINS` in `compose.yaml` only accepts requests from the Tailnet address of the web interface.
- **Service port.** Tracktor listens on port `3000`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

Open the web interface. Tracktor sends you to the registration page, where you create the first account.

## Links

- [Tracktor documentation and source code](https://github.com/javedh-dev/tracktor)
