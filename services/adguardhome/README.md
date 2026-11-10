# AdGuard Home

[AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) is a DNS server that blocks advertisements and trackers for every device that uses it.

This stack runs AdGuard Home with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                       |
| ------------- | ------------------------------------------------------------------------------------------- |
| Web interface | `https://adguardhome.<tailnet>.ts.net` (after the setup wizard)                             |
| Setup wizard  | `http://<Tailscale IP address of adguardhome>:3000` (first start only)                      |
| Service port  | `80`                                                                                        |
| DNS           | Port `53` (TCP and UDP) on the Tailscale IP address of `adguardhome` and on the Docker host |
| Image         | `adguard/adguardhome`                                                                       |
| Data          | `./adguardhome-data/configdir` (configuration)                                              |
|               | `./adguardhome-data/workdir` (filters, statistics, and query log)                           |

## Before you start

The stack publishes port `53` on the Docker host. On a host that runs `systemd-resolved`, this port is in use. See [Free up port 53 on the Docker host](../../documentation/free-up-port-53.md).

## Deviations from the standard setup

- **Published host ports.** The `ports` block is active and publishes DNS on port `53` (TCP and UDP) of the Docker host. Devices in your local network can therefore use AdGuard Home without Tailscale.
- **Setup wizard on port `3000`.** At the first start, AdGuard Home only listens on port `3000`. Tailscale Serve forwards to port `80`, so the web interface is not available at the Tailnet address until you finish the wizard.
- **DNS does not use Tailscale Serve.** Serve only handles the web interface. AdGuard Home listens for DNS queries on port `53` of the Tailscale IP address of the device.

## First run

1. Find the Tailscale IP address of the device:

   ```bash
   docker exec tailscale-adguardhome tailscale ip -4
   ```

2. Open `http://<Tailscale IP address>:3000` and follow the setup wizard. Keep port `80` for the web interface and port `53` for the DNS server, and create the administrator account.
3. Open the web interface at `https://adguardhome.<tailnet>.ts.net` and log in.

## Configuration

### Use AdGuard Home as the DNS server of your Tailnet

In the Tailscale admin console, open the **DNS** page. Add the Tailscale IP address of the `adguardhome` device as a custom nameserver and enable **Override DNS servers**.

### Use AdGuard Home in your local network

Point your devices or your router at the IP address of the Docker host as DNS server.

## Links

- [AdGuard Home wiki](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [AdGuard Home Docker image](https://hub.docker.com/r/adguard/adguardhome)
- [AdGuard Home source code](https://github.com/AdguardTeam/AdGuardHome)
