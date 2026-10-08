# DumbDo

[DumbDo](https://github.com/DumbWareio/DumbDo) is a simple to-do list. It has no accounts and no database, and it stores your lists in one file.

This stack runs DumbDo with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://dumbdo.<tailnet>.ts.net` |
| Service port  | `3000`                            |
| Image         | `dumbwareio/dumbdo`               |
| Data          | `./dumbdo-data`                   |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Nothing to set up. Open the web interface. DumbDo has no login by default, so everyone who can reach the device on your Tailnet can edit the lists.

## Links

- [DumbDo documentation and source code](https://github.com/DumbWareio/DumbDo)
