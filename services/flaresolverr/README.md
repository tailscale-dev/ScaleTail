# FlareSolverr

[FlareSolverr](https://github.com/FlareSolverr/FlareSolverr) is a proxy server that solves Cloudflare challenges for other applications, such as Prowlarr.

This stack runs FlareSolverr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                   |
| ------------- | --------------------------------------- |
| Web interface | None                                    |
| API           | `https://flaresolverr.<tailnet>.ts.net` |
| Service port  | `8191`                                  |
| Image         | `ghcr.io/flaresolverr/flaresolverr`     |
| Data          | None                                    |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No web interface.** Tailscale Serve publishes the API of FlareSolverr. The address answers with a short status message.
- **No data folder.** FlareSolverr stores nothing on disk, so the stack has no volumes.
- **Optional settings.** `compose.yaml` passes `LOG_LEVEL`, `LOG_FILE`, `LOG_HTML`, and `CAPTCHA_SOLVER` to the container when you add them to `.env`.

## First run

Nothing to set up in FlareSolverr itself. Enter its address in the application that uses it. From another stack in this repository, use `http://<Tailscale IP address of flaresolverr>:8191`. See the [DNS section of the standard setup](../../documentation/standard-setup.md#dns) for the use of names.

## Links

- [FlareSolverr documentation and source code](https://github.com/FlareSolverr/FlareSolverr)
