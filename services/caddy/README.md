# Caddy with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Caddy](https://github.com/caddyserver/caddy-docker) with Tailscale as a sidecar container to securely manage and route your traffic over a private Tailscale network. By integrating Tailscale, you can enhance the security and privacy of your Caddy instance, ensuring that access is restricted to devices within your Tailscale network.

## Caddy

[Caddy](https://github.com/caddyserver/caddy-docker) is an extensible platform for deploying long-running services ("apps") using a single, unified configuration. It is enterprise-ready, extensible, open source, and provides automatic HTTPS. By incorporating Tailscale, your Caddy instance is safeguarded, ensuring that only authorized users and devices on your Tailscale network can access your applications and services.

## Configuration Overview

In this setup, the `tailscale-caddy` service runs Tailscale, which manages secure networking for Caddy. The `application` service uses Docker's `network_mode: service:tailscale` configuration. This keeps Caddy's dashboard and routes on your Tailnet unless you publish a host port.

To get this working:

- Update the FQDN in `Caddyfile` to match your `${SERVICE}.MagicDNSname.ts.net`.
- Update the TS_AUTHKEY in the .env file to your Tailscale key.

If you change `SERVICE` in `.env`, update the hostname in `Caddyfile` as well. The healthcheck calls Caddy's admin API on `127.0.0.1:2019`, so it does not depend on the hostname.

Both containers mount the Tailscale socket directory. Caddy only uses the socket to get HTTPS certificates, which the sample `http://` site address does not request (see below). Sharing the directory instead of the socket file lets Caddy use the new socket after Tailscale restarts.

The example `compose.yaml` uses a simple webserver for testing purposes.

Within your Tailscale dashboard do you have [HTTPS](https://tailscale.com/kb/1153/enabling-https) and [MagicDNS](https://tailscale.com/kb/1081/magicdns) enabled? If so, remove the http:// from the Caddyfile and Caddy should automatically provision a public HTTPS certificate from Let's Encrypt via the Tailscale infrastructure. The certificate takes ~20s to be procured upon first visit. This is further documented in [Caddy certificates on Tailscale](https://tailscale.com/kb/1190/caddy-certificates).
