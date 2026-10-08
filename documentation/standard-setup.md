# The standard ScaleTail setup

Every service in this repository starts from the same [template](../templates/service-template/). This page describes that shared setup once. The README of a service only lists what differs, under the heading "Deviations from the standard setup".

## Containers

Each stack runs two containers that share one network namespace.

| Compose service | Container name          | Purpose                                                              |
| --------------- | ----------------------- | -------------------------------------------------------------------- |
| `tailscale`     | `tailscale-<service>`   | Joins your Tailnet as a device named after `SERVICE` in `.env`.       |
| `application`   | `app-<service>`         | Runs the service and uses the network of the `tailscale` container.   |

The application uses `network_mode: service:tailscale` and starts only after the `tailscale` container reports healthy.

## Tailnet access

- **Web interface.** [Tailscale Serve](https://tailscale.com/kb/1312/serve) publishes the web interface at `https://<service>.<tailnet>.ts.net` and forwards it to the internal port of the application. `<service>` is the value of `SERVICE` and `<tailnet>` is your [Tailnet name](https://tailscale.com/kb/1217/tailnet-name).
- **Requirements.** Your Tailnet needs [MagicDNS](https://tailscale.com/kb/1081/magicdns) and [HTTPS certificates](https://tailscale.com/kb/1153/enabling-https) enabled. The first request can take up to a minute, because Tailscale requests the certificate at that moment.
- **Tailnet only.** Tailscale Funnel is disabled, so the service is not reachable from the public internet.
- **Other ports.** Any other port the application listens on is reachable at the Tailscale IP address of the device, when your Tailnet policy allows it.
- **No host ports.** The stack publishes no ports on the Docker host. To reach the service from your local network as well, uncomment the `ports` block of the `tailscale` service.

## Settings in `.env`

| Variable      | Purpose                                                                                      |
| ------------- | -------------------------------------------------------------------------------------------- |
| `SERVICE`     | Name of the Tailnet device, the containers, and the data folder.                             |
| `IMAGE_URL`   | Image of the application.                                                                    |
| `SERVICEPORT` | Port used by the optional `ports` block. The port for Tailscale Serve is set in `compose.yaml`. |
| `DNS_SERVER`  | DNS server used by the optional `dns` block.                                                 |
| `TS_AUTHKEY`  | Your Tailscale auth key. Only needed for the first start.                                    |
| `TZ`          | Time zone, passed to the application when its image supports it.                             |

## Data

All data stays in the service directory, next to `compose.yaml`.

| Path                | Content                                   |
| ------------------- | ----------------------------------------- |
| `./config`          | Tailscale configuration files.            |
| `./ts/state`        | Tailscale state, including the device key. |
| `./<service>-data/` | Data of the application.                  |

Keep `./ts/state` when you recreate the stack. Without it, the device joins your Tailnet again as a new device.

## DNS

The containers use Docker's DNS by default, so the application can reach other containers in the same stack by their Compose service name. It cannot resolve MagicDNS names of other Tailnet devices.

- To reach another Tailnet device from the application, use its Tailscale IP address.
- To use MagicDNS names instead, uncomment `TS_ACCEPT_DNS=true`. This replaces Docker's DNS, so Compose service names no longer resolve. Do not use it in a stack where the application depends on other containers by name.
- If name resolution fails in general, uncomment the `dns` block to use the server from `DNS_SERVER`.
