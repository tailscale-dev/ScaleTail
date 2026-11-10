# qBittorrent

[qBittorrent](https://www.qbittorrent.org/) is a BitTorrent client with a web interface.

This stack runs qBittorrent with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://qbittorrent.<tailnet>.ts.net`      |
| Service port  | `8080`                                      |
| Image         | `lscr.io/linuxserver/qbittorrent`           |
| Data          | `./qbittorrent-data/config` (configuration) |
|               | `./qbittorrent-data/downloads` (downloads)  |

## Before you start

To store downloads elsewhere, point the `/downloads` volume in `compose.yaml` at your own folder. Applications such as Radarr and Sonarr need access to the same folder.

## Deviations from the standard setup

- **Torrent port.** The stack publishes no ports, so the torrent port `6881` is only reachable through your Tailnet and not from the internet.

## First run

1. The username is `admin`. qBittorrent prints a temporary password to the log at each start:

   ```bash
   docker logs app-qbittorrent 2>&1 | grep "temporary password"
   ```

2. Open the web interface and log in.
3. Set your own password in the settings of the web interface. Otherwise qBittorrent generates a new temporary password at every start.

## Links

- [qBittorrent wiki](https://github.com/qbittorrent/qBittorrent/wiki)
- [qBittorrent source code](https://github.com/qbittorrent/qBittorrent)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-qbittorrent/)
