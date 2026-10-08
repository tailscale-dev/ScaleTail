# Donetick

[Donetick](https://github.com/donetick/donetick) is a task and chore manager for households and small groups. You create tasks, assign them, set a schedule, and track who did what.

This stack runs Donetick with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| Web interface | `https://donetick.<tailnet>.ts.net`                         |
| Service port  | `2021`                                                      |
| Image         | `donetick/donetick`                                         |
| Data          | `./donetick-data/config` (configuration, `selfhosted.yaml`) |
|               | `./donetick-data/data` (database)                           |

## Before you start

Replace the value of `jwt.secret` in `donetick-data/config/selfhosted.yaml` with your own random value, for example from `openssl rand -base64 32`. Donetick refuses to start with the sample value and reports `JWT secret is too weak`.

## Deviations from the standard setup

- **Configuration file.** This directory contains `donetick-data/config/selfhosted.yaml`. `DT_ENV=selfhosted` makes Donetick read that file.

## First run

Open the web interface and sign up to create the first account.

## Links

- [Donetick documentation](https://docs.donetick.com/)
- [Donetick source code](https://github.com/donetick/donetick)
