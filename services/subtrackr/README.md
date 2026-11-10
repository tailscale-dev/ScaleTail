# SubTrackr

[SubTrackr](https://github.com/bscott/subtrackr) tracks subscriptions, with monthly and yearly totals and renewal dates.

This stack runs SubTrackr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://subtrackr.<tailnet>.ts.net` |
| Service port  | `8080`                               |
| Image         | `ghcr.io/bscott/subtrackr`           |
| Data          | `./subtrackr-data/data`              |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface. SubTrackr has no login by default, so everyone who can reach the device on your Tailnet can see and change your data. You can enable a login in the settings.

## Links

- [SubTrackr documentation and source code](https://github.com/bscott/subtrackr)
