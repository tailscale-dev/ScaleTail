# Caddy

[Caddy](https://caddyserver.com/) is a web server and reverse proxy with automatic HTTPS. In this stack, it serves or proxies your own sites on your Tailnet.

This stack runs Caddy with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                            |
| ------------- | ------------------------------------------------ |
| Web interface | `http://caddy.<tailnet>.ts.net` (sample site)    |
| Service port  | `80`                                             |
| Images        | `caddy`                                          |
|               | `traefik/whoami` (sample site)                   |
| Data          | `./Caddyfile` (Caddy configuration)              |
|               | `./site` (static files, `/srv` in the container) |
|               | `./caddy_data` (certificates)                    |
|               | `./caddy_config` (saved configuration)           |

## Before you start

Replace `caddy.MagicDNSname.ts.net` in `Caddyfile` with the name of the device on your Tailnet, `caddy.<tailnet>.ts.net`. If you change `SERVICE` in `.env`, change the name in `Caddyfile` as well.

## Deviations from the standard setup

- **No Tailscale Serve.** Caddy answers requests itself, on port `80` of the Tailscale IP address of the device. The stack has no Serve configuration.
- **Sample site.** The stack runs a `whoami` container as a test site, and `Caddyfile` proxies to it. Replace both with your own sites.
- **Tailscale socket.** Both containers mount `./tailscale/tmp`. Caddy uses the Tailscale socket in that folder to request HTTPS certificates. The stack shares the folder and not the socket file, so that Caddy finds the new socket after Tailscale restarts.
- **Data folders.** The data is in `./site`, `./caddy_data`, and `./caddy_config`, not in a `./caddy-data` folder.

## First run

Open `http://caddy.<tailnet>.ts.net`. The sample site shows the details of your request.

## Configuration

### HTTPS

The sample site uses plain HTTP inside your Tailnet. To use HTTPS:

1. Enable [MagicDNS](https://tailscale.com/kb/1081/magicdns) and [HTTPS certificates](https://tailscale.com/kb/1153/enabling-https) for your Tailnet.
2. Remove `http://` from the site address in `Caddyfile` and restart the stack.

Caddy then requests a certificate through Tailscale at the first visit, which takes about 20 seconds. See [Caddy certificates on Tailscale](https://tailscale.com/kb/1190/caddy-certificates).

## Links

- [Caddy documentation](https://caddyserver.com/docs/)
- [Caddy Docker image](https://github.com/caddyserver/caddy-docker)
- [Caddy certificates on Tailscale](https://tailscale.com/kb/1190/caddy-certificates)
