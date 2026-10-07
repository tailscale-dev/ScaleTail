# Actual Budget

[Actual Budget](https://actualbudget.org/) is a personal finance app for budgeting. You track your accounts and spending and plan your budget, and your data stays on your own server.

This stack runs Actual Budget with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                    |
| ------------- | ---------------------------------------- |
| Web interface | `https://actual-budget.<tailnet>.ts.net` |
| Service port  | `5006`                                   |
| Image         | `docker.io/actualbudget/actual-server`   |
| Data          | `./actual-budget-data`                   |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and set a password for the server. Then create a budget file or import an existing one.

## Links

- [Actual Budget documentation](https://actualbudget.org/docs/)
- [Actual Budget source code](https://github.com/actualbudget/actual)
