# RustDesk Server

[RustDesk](https://rustdesk.com/) is a remote desktop application. This stack runs its own ID and relay server, so that your RustDesk clients find and reach each other without the public servers.

This stack runs RustDesk Server with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item                  | Value                                                                                              |
| --------------------- | -------------------------------------------------------------------------------------------------- |
| Web interface         | None                                                                                               |
| ID server (`hbbs`)    | Ports `21115`, `21116` (TCP and UDP), and `21118` on the Tailscale IP address of `rustdesk-server` |
| Relay server (`hbbr`) | Ports `21117` and `21119` on the Tailscale IP address of `rustdesk-server`                         |
| Image                 | `rustdesk/rustdesk-server`                                                                         |
| Data                  | `./rustdesk-server-data/hbbs` (key pair and database of the ID server)                             |
|                       | `./rustdesk-server-data/hbbr` (data of the relay server)                                           |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Two application containers.** The `application` container runs the ID server `hbbs`, and the `hbbr` container runs the relay server. Both use the network of the `tailscale` container.
- **No Tailscale Serve.** RustDesk has no web interface. The clients connect directly to the ports of the device on your Tailnet, so the stack has no Serve configuration.
- **Relay setting.** `ALWAYS_USE_RELAY` in `.env` is `N`. Set it to `Y` to send all connections through the relay server.

## First run

1. Start the stack. The ID server creates its key pair at the first start. Read the public key:

   ```bash
   cat ./rustdesk-server-data/hbbs/id_ed25519.pub
   ```

2. In each RustDesk client, open **Settings** > **Network** > **ID/Relay Server**. Enter `rustdesk-server.<tailnet>.ts.net` as the **ID server** and the public key as the **Key**. You do not need to fill in the relay server or the API server.

   You can also pass both values on the command line, for example `rustdesk.exe --config "host=rustdesk-server.<tailnet>.ts.net,key=<public key>"`.

All clients must be on your Tailnet.

## Links

- [RustDesk self-hosting documentation](https://rustdesk.com/docs/en/self-host/)
- [RustDesk client configuration](https://rustdesk.com/docs/en/self-host/client-configuration/)
- [RustDesk server source code](https://github.com/rustdesk/rustdesk-server)
