# qui

[qui](https://getqui.com/) is a web interface for qBittorrent. One qui manages several qBittorrent instances, with automations and cross-seed.

This stack runs qui with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). qui has no built-in Tailscale support, and its image contains no `tailscale` or `tailscaled`. The stack does not include qBittorrent. Run qBittorrent with the [qBittorrent stack](../qbittorrent) or elsewhere. Its own web interface keeps working next to qui.

## At a glance

| Item          | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| Web interface | `https://qui.<tailnet>.ts.net`                              |
| Service port  | `7476`                                                      |
| Image         | `ghcr.io/autobrr/qui:latest`                                |
| Data          | `./qui-data/config/` (`config.toml`, `qui.db`, and backups) |

## Before you start

- **qBittorrent.** qui needs a running qBittorrent with its web interface turned on, and your own password for it. Until you set one, qBittorrent generates a new temporary password at every start, and qui loses the connection after the next restart.
- **Network path.** qui must reach the web interface of qBittorrent. When qBittorrent runs in the [qBittorrent stack](../qbittorrent), use the Tailscale IP address of that device, such as `http://<tailscale-ip>:8080`. Your Tailnet policy must allow the qui device to reach that device on port `8080`.

## Deviations from the standard setup

- **Secure session cookie.** `QUI__SESSION_COOKIE_SECURE=true` lets the browser send the login cookie only over HTTPS, as upstream recommends behind an HTTPS proxy. When you uncomment the `ports` block to log in over plain HTTP on your local network, set it to `false`.

## First run

1. Open the web interface and create your account. The first visitor of a new instance creates the account, so do this right after the first start.
2. Add your qBittorrent as an instance. Enter its address, such as `http://<tailscale-ip>:8080`, and the username and password of its web interface.

## Configuration

- **Local filesystem access.** Cross-seed with hardlinks or reflinks and orphan scan need the download folder of qBittorrent inside the qui container, at the same path as in qBittorrent. Add that folder to the `volumes` of the `application` service. See [Local filesystem access](https://getqui.com/docs/getting-started/docker#local-filesystem-access).

## Links

- [qui documentation](https://getqui.com/docs/intro)
- [qui Docker guide](https://getqui.com/docs/getting-started/docker)
- [qui configuration reference](https://getqui.com/docs/configuration/reference)
- [qui source code](https://github.com/autobrr/qui)
