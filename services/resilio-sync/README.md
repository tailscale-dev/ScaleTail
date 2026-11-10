# Resilio Sync

[Resilio Sync](https://www.resilio.com/sync/) synchronises folders directly between your devices, without a central server.

This stack runs Resilio Sync with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                       |
| ------------- | --------------------------------------------------------------------------- |
| Web interface | `https://resilio-sync.<tailnet>.ts.net`                                     |
| Service port  | `8888`                                                                      |
| Image         | `linuxserver/resilio-sync`                                                  |
| Data          | `./resilio-sync-data/config` (configuration)                                |
|               | `./resilio-sync-data/data` (synchronised folders, `/sync` in the container) |
|               | `./resilio-sync-data/downloads` (downloads)                                 |

## Before you start

To synchronise existing folders, point the `/sync` volume in `compose.yaml` at your own folder. The container runs as user and group `1000`, which need write access to it.

## Deviations from the standard setup

- **Sync port.** The stack publishes no ports, so the sync port `55555` is only reachable through your Tailnet and not from your local network or the internet.

## First run

Open the web interface and create the username and password for it. Then add your folders below `/sync`.

## Links

- [Resilio Sync website](https://www.resilio.com/sync/)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-resilio-sync/)
