# Tailscale App Connector

A Tailscale [app connector](https://tailscale.com/docs/features/app-connectors/how-to/setup) routes Tailnet traffic for selected applications through itself. Users and devices reach these applications by domain name instead of by IP address.

This stack runs only the Tailscale container from [the standard setup](../../documentation/standard-setup.md), configured as an app connector.

## At a glance

| Item           | Value                 |
| -------------- | --------------------- |
| Web interface  | None                  |
| Tailnet device | `app-connector`       |
| Image          | `tailscale/tailscale` |
| Data           | `./ts/state`          |

## Before you start

An app connector needs a tag and matching rules in your Tailnet policy. Follow the [app connector setup guide](https://tailscale.com/docs/features/app-connectors/how-to/setup) first:

1. Create a tag for the connector and add the `tagOwners`, `autoApprovers`, and `grants` entries from the guide to your Tailnet policy.
2. Give the device that tag. Create the auth key for `TS_AUTHKEY` with the tag, or add `--advertise-tags=tag:<connector-tag-name>` to `TS_EXTRA_ARGS` in `compose.yaml`.

## Deviations from the standard setup

- **No application container.** The stack has no `application` service, no Tailscale Serve configuration, and no `./config` folder.
- **Connector flag.** `TS_EXTRA_ARGS=--advertise-connector` offers the device as an app connector to your Tailnet.
- **IP forwarding.** The `sysctls` block enables IPv4 and IPv6 forwarding in the container, which an app connector requires.
- **Bridge network.** The container uses `network_mode: bridge`, so forwarded traffic leaves through the Docker host.
- **DNS server.** The `dns` block is active and uses `DNS_SERVER` from `.env`.

## First run

Add your applications on the **Apps** page of the Tailscale admin console and assign them to the tag of the connector.

## Links

- [Tailscale app connector setup](https://tailscale.com/docs/features/app-connectors/how-to/setup)
- [Tailscale in Docker](https://tailscale.com/kb/1282/docker)
