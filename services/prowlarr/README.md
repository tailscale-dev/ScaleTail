# Prowlarr

[Prowlarr](https://github.com/Prowlarr/Prowlarr) manages your Usenet indexers and torrent trackers in one place and passes them on to applications such as Radarr and Sonarr.

This stack runs Prowlarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://prowlarr.<tailnet>.ts.net` |
| Service port  | `9696`                              |
| Image         | `lscr.io/linuxserver/prowlarr`      |
| Data          | `./prowlarr-data`                   |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface. Prowlarr asks you to choose an authentication method and to create a username and password before you can continue.

Then add your indexers, and add Radarr and Sonarr under **Settings** > **Apps**. To reach an application in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Links

- [Prowlarr documentation](https://wiki.servarr.com/prowlarr)
- [Prowlarr source code](https://github.com/Prowlarr/Prowlarr)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-prowlarr/)
