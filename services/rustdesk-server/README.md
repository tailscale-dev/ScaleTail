# Rustdesk Server with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Rustdesk Server](https://rustdesk.com/docs/en/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Rustdesk Server

[Rustdesk Server](https://rustdesk.com/docs/en/) information about the service. Explain what the app does in 2-3 sentences and why someone would pair it with Tailscale.

## Configuration Overview

In this setup, the `tailscale-rustdesk-server` service runs Tailscale, which manages secure networking for Rustdesk Server. The `Rustdesk Server` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## Client setup

- Service Configuration: The Rustdesk client public Key credentials are generated at first run and stored in the **id_ed25519.pub** file. This is found in the compose directory **./rustdesk-server-data/hbbs/**  Clients can be setup using the --config switch. e.g. **rustdesk.exe --config "host=rustdesk.your-tailnet.ts,key=thetextfromkey"** or in the client Setting -> Network -> ID/Relay Server.  There is no need to configure the relay or API server.

Links:

- [Client setup](https://github.com/rustdesk/rustdesk/discussions/7118)
- [Rustdesk](https://rustdesk.com/)
- [Client Configuration](https://rustdesk.com/docs/en/self-host/client-configuration/)

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variable `TS_AUTHKEY`
