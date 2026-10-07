# Technitium DNS Server

[Technitium DNS Server](https://technitium.com/dns/) is a DNS server for your network. It resolves names itself or through forwarders, blocks advertisements, and hosts your own DNS zones.

This stack runs Technitium DNS Server with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                      |
| ------------- | ------------------------------------------------------------------------------------------ |
| Web interface | `https://technitium.<tailnet>.ts.net`                                                      |
| Service port  | `5380`                                                                                     |
| DNS           | Port `53` (TCP and UDP) on the Tailscale IP address of `technitium` and on the Docker host |
| Image         | `technitium/dns-server`                                                                    |
| Data          | None on the host, see the deviations                                                       |

## Before you start

- **Set the administrator password.** Change `ADMIN_PASSWORD` in `.env`. The default is `ChangeME`. Technitium reads it only at the first start.
- **Free port 53.** The stack publishes port `53` on the Docker host. On a host that runs `systemd-resolved`, this port is in use. See [Free up port 53 on the Docker host](../../documentation/free-up-port-53.md).
- **Choose the forwarders.** `DNS_SERVER1` and `DNS_SERVER2` in `.env` set the DNS servers that Technitium forwards to.

## Deviations from the standard setup

- **Published host ports.** The `ports` block is active. It publishes the web interface on port `5380`, DNS on port `53`, DNS-over-TLS and DNS-over-QUIC on port `853`, and DNS-over-HTTPS on port `443` of the Docker host. Devices in your local network can therefore reach Technitium without Tailscale. Remove the lines that you do not need.
- **Settings are not stored on the host.** Technitium keeps its settings and zones in `/etc/dns` in the container. The stack mounts `./technitium-data/app/config` at `/config`, which Technitium does not use. Your settings are lost when the container is recreated, for example after an image update. Back up your settings in the web interface before you update.
- **Settings through environment variables.** `compose.yaml` sets the server name, recursion, and forwarders. Technitium reads these variables only at the first start, when it has no configuration yet.

## First run

1. Open the web interface and log in with username `admin` and the password from `ADMIN_PASSWORD`.
2. Point your devices or your router at the IP address of the Docker host as DNS server.

## Configuration

### Use Technitium as the DNS server of your Tailnet

In the Tailscale admin console, open the **DNS** page. Add the Tailscale IP address of the `technitium` device as a custom nameserver and enable **Override DNS servers**.

## Links

- [Technitium DNS Server help](https://technitium.com/dns/help.html)
- [Technitium DNS Server source code](https://github.com/TechnitiumSoftware/DnsServer)
- [Docker environment variables](https://github.com/TechnitiumSoftware/DnsServer/blob/master/DockerEnvironmentVariables.md)
