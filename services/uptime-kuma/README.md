# Uptime Kuma

[Uptime Kuma](https://github.com/louislam/uptime-kuma) monitors your websites and services. It checks them at an interval, shows their uptime, and sends a notification when one is down.

This stack runs Uptime Kuma with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | `https://uptime-kuma.<tailnet>.ts.net` |
| Service port  | `3001`                                 |
| Image         | `louislam/uptime-kuma:2`               |
| Data          | `./uptime-kuma-data/uptime-kuma-data`  |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Uptime Kuma mounts `/var/run/docker.sock` read-only, so that it can monitor the containers on the Docker host. Remove the line if you do not use this monitor type.

## First run

1. Open the web interface. Uptime Kuma first asks which database to use. SQLite needs no further settings.
2. Create the administrator account.
3. Add your first monitor. To monitor a service in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Uptime Kuma wiki](https://github.com/louislam/uptime-kuma/wiki)
- [Uptime Kuma source code](https://github.com/louislam/uptime-kuma)
