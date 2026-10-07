# Tailscale Exit Node

A Tailscale [exit node](https://tailscale.com/kb/1103/exit-nodes) routes the internet traffic of other Tailnet devices through itself. Devices that use it reach the internet from the network of the Docker host, for example your home or office.

This stack runs only the Tailscale container from [the standard setup](../../documentation/standard-setup.md), configured as an exit node.

## At a glance

| Item           | Value                 |
| -------------- | --------------------- |
| Web interface  | None                  |
| Tailnet device | `exit-node`           |
| Image          | `tailscale/tailscale` |
| Data           | `./ts/state`          |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No application container.** The stack has no `application` service, no Tailscale Serve configuration, and no `./config` folder.
- **Exit node flag.** `TS_EXTRA_ARGS=--advertise-exit-node` offers the device as an exit node to your Tailnet.
- **IP forwarding.** The `sysctls` block enables IPv4 and IPv6 forwarding in the container, which an exit node on Linux requires.
- **Bridge network.** The container uses `network_mode: bridge`, so forwarded traffic leaves through the Docker host.
- **DNS server.** The `dns` block is active and uses `DNS_SERVER` from `.env`.

## First run

1. In the Tailscale admin console, open the **Machines** page and find the `exit-node` device.
2. Open its menu, select **Edit route settings**, and enable **Use as exit node**.
3. On each device that should use the exit node, select it in the Tailscale client. On Linux, run `sudo tailscale set --exit-node=<exit-node-ip>`.

## Links

- [Tailscale exit nodes](https://tailscale.com/kb/1103/exit-nodes)
- [Tailscale in Docker](https://tailscale.com/kb/1282/docker)
