# Wallos

[Wallos](https://github.com/ellite/Wallos) tracks your subscriptions. It shows your recurring expenses, reminds you of payments, and helps you to manage your budget.

This stack runs Wallos with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | `https://wallos.<tailnet>.ts.net`      |
| Service port  | `80`                                   |
| Image         | `bellamy/wallos`                       |
| Data          | `./wallos-data/db` (database)          |
|               | `./wallos-data/logos` (uploaded logos) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface. Wallos sends you to the registration page, where you create the first account, which becomes the administrator.

## Links

- [Wallos documentation and source code](https://github.com/ellite/Wallos)
