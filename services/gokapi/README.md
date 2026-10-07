# Gokapi

[Gokapi](https://github.com/Forceu/Gokapi) is a file sharing server. You upload a file and share a link that expires after a number of downloads or days.

This stack runs Gokapi with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://gokapi.<tailnet>.ts.net`             |
| Service port  | `53842`                                       |
| Image         | `f0rc3/gokapi`                                |
| Data          | `./gokapi-data/gokapi-data` (uploaded files)  |
|               | `./gokapi-data/gokapi-config` (configuration) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open `https://gokapi.<tailnet>.ts.net/setup`. The setup wizard asks for the authentication method, the administrator account, the storage, and the public address of the server. Until you finish it, the web interface only shows a maintenance message.

## Links

- [Gokapi documentation](https://gokapi.readthedocs.io/en/latest/)
- [Gokapi source code](https://github.com/Forceu/Gokapi)
