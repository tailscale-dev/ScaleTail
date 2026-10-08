# Eigenfocus

[Eigenfocus](https://eigenfocus.com/) is a project and task manager with boards, time tracking, and focus tools.

This stack runs Eigenfocus with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                             |
| ------------- | ------------------------------------------------- |
| Web interface | `https://eigenfocus.<tailnet>.ts.net`             |
| Service port  | `3000`                                            |
| Image         | `eigenfocus/eigenfocus:0.8.0`                     |
| Data          | `./eigenfocus-data` (database and uploaded files) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Pinned version.** `IMAGE_URL` in `.env` pins Eigenfocus to version `0.8.0`.

## First run

Open the web interface. Eigenfocus sends you to the profile page, where you enter your name and preferences before you create the first project.

## Links

- [Eigenfocus website](https://eigenfocus.com/)
- [Eigenfocus source code](https://github.com/Eigenfocus/eigenfocus)
