# Tailscale Subnet Router

A Tailscale [subnet router](https://tailscale.com/docs/features/subnet-routers) gives your Tailnet access to devices that cannot run Tailscale themselves. It forwards traffic between your Tailnet and a local network, such as your home or office network.

This stack runs only the Tailscale container from [the standard setup](../../documentation/standard-setup.md), configured as a subnet router.

## At a glance

| Item           | Value                 |
| -------------- | --------------------- |
| Web interface  | None                  |
| Tailnet device | `subnet-router`       |
| Image          | `tailscale/tailscale` |
| Data           | `./ts/state`          |

## Before you start

Set `SUBNET_ROUTES` in `.env` to the networks that the router should offer, as a comma-separated list. The default `10.1.234.0/24` is an example.

## Deviations from the standard setup

- **No application container.** The stack has no `application` service, no Tailscale Serve configuration, and no `./config` folder.
- **Advertised routes.** `TS_ROUTES` passes the value of `SUBNET_ROUTES` to Tailscale, which offers these routes to your Tailnet.
- **IP forwarding.** The `sysctls` block enables IPv4 and IPv6 forwarding in the container, which a subnet router on Linux requires.
- **Bridge network.** The container uses `network_mode: bridge`, so it reaches the local network through the Docker host.
- **DNS server.** The `dns` block is active and uses `DNS_SERVER` from `.env`.

## First run

1. In the Tailscale admin console, open the **Machines** page and select the `subnet-router` device.
2. In the **Subnets** section, select **Edit**. Under **Subnet routes**, select the routes to approve and select **Save**.
3. Linux devices do not use subnet routes by default. Run `sudo tailscale set --accept-routes` on each Linux device that should use them.

## Links

- [Tailscale subnet routers](https://tailscale.com/docs/features/subnet-routers)
- [Tailscale in Docker](https://tailscale.com/kb/1282/docker)
