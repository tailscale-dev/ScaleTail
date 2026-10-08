# Beszel Hub

[Beszel](https://beszel.dev/) is a lightweight server monitoring platform with historical data, Docker statistics, and alerts. The hub is its web interface. It collects the data from an agent on each system that you monitor.

This stack runs Beszel Hub with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://beszel-hub.<tailnet>.ts.net` |
| Service port  | `8090`                                |
| Image         | `henrygd/beszel`                      |
| Data          | `./beszel-hub-data/beszel_data`       |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

1. Open the web interface and create the first account.
2. Select **Add System**. The dialog shows the public key that an agent needs.
3. Start an agent on each system that you want to monitor, for example with the [Beszel Agent stack](../beszel-agent/), and add it in the same dialog.

## Links

- [Beszel documentation](https://beszel.dev/guide/getting-started)
- [Beszel source code](https://github.com/henrygd/beszel)
