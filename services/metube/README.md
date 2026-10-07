# MeTube

[MeTube](https://github.com/alexta69/metube) is a web interface for `yt-dlp`. It downloads videos and audio from YouTube and many other sites to your server.

This stack runs MeTube with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://metube.<tailnet>.ts.net` |
| Service port  | `8081`                            |
| Image         | `ghcr.io/alexta69/metube`         |
| Data          | `./downloads`                     |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **MagicDNS is enabled.** The stack sets `TS_ACCEPT_DNS=true`, so the containers resolve names through MagicDNS and not through Docker's DNS.
- **Download folder.** The downloads are in `./downloads`, not in a `./metube-data` folder.

## First run

MeTube has no login. Open the web interface, paste a link, and select **Download**. The files appear in `./downloads`.

## Links

- [MeTube documentation and source code](https://github.com/alexta69/metube)
