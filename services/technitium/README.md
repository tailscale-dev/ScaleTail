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
| Data          | `./technitium-data/app/config` (settings, zones, logs, and statistics)                     |

## Before you start

- **Set the administrator password.** Set `ADMIN_PASSWORD` in `.env`. It is empty, and Compose stops with an error until you set it. Technitium reads it only at the first start.
- **Free port 53.** The stack publishes port `53` on the Docker host. On a host that runs `systemd-resolved`, this port is in use. See [Free up port 53 on the Docker host](../../documentation/free-up-port-53.md).
- **Choose the forwarders.** `DNS_SERVER1` and `DNS_SERVER2` in `.env` set the DNS servers that Technitium forwards to.

## Deviations from the standard setup

- **Published host ports.** The `ports` block is active. It publishes the web interface on port `5380`, DNS on port `53`, DNS-over-TLS and DNS-over-QUIC on port `853`, and DNS-over-HTTPS on port `443` of the Docker host. Devices in your local network can therefore reach Technitium without Tailscale. Remove the lines that you do not need.
- **Settings through environment variables.** `compose.yaml` sets the server name, recursion, and forwarders. Technitium reads these variables only at the first start, when it has no configuration yet.

## First run

1. Open the web interface and log in with username `admin` and the password from `ADMIN_PASSWORD`.
2. Point your devices or your router at the IP address of the Docker host as DNS server.

## Configuration

### Use Technitium as the DNS server of your Tailnet

In the Tailscale admin console, open the **DNS** page. Add the Tailscale IP address of the `technitium` device as a custom nameserver and enable **Override DNS servers**.

## Upgrading

Earlier versions of this stack mounted the data folder at `/config`, which Technitium does not use. Technitium kept its settings and zones inside the container, and they were lost when the container was recreated. The stack now mounts the folder at `/etc/dns`.

If you run an earlier version, copy your settings to the host before you start the new version. Otherwise Technitium starts without them.

1. Stop Technitium, so that it writes all changes to disk:

   ```bash
   docker compose stop application
   ```

2. Copy the settings from the container to the data folder. Docker created this folder as user `root`, so the command needs `sudo`:

   ```bash
   sudo docker cp app-technitium:/etc/dns/. ./technitium-data/app/config/
   ```

3. Start the stack with the updated `compose.yaml`:

   ```bash
   docker compose up -d
   ```

Earlier versions of this stack had a sample value for `ADMIN_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now.

## Links

- [Technitium DNS Server help](https://technitium.com/dns/help.html)
- [Technitium DNS Server source code](https://github.com/TechnitiumSoftware/DnsServer)
- [Docker environment variables](https://github.com/TechnitiumSoftware/DnsServer/blob/master/DockerEnvironmentVariables.md)
