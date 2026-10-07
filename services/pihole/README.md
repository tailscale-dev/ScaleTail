# Pi-hole

[Pi-hole](https://github.com/pi-hole/pi-hole) is a DNS server that blocks advertisements and trackers for every device that uses it.

This stack runs Pi-hole with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                           |
| ------------- | --------------------------------------------------------------- |
| Web interface | `https://pihole.<tailnet>.ts.net/admin`                         |
| Service port  | `80`                                                            |
| DNS           | Port `53` (TCP and UDP) on the Tailscale IP address of `pihole` |
| Image         | `pihole/pihole`                                                 |
| Data          | `./pihole-data/etc-pihole` (settings and databases)             |
|               | `./pihole-data/etc-dnsmasq.d` (custom dnsmasq configuration)    |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **The web interface is at `/admin`.** Pi-hole serves its web interface under this path and answers a request for `/` with error `403`.
- **DNS does not use Tailscale Serve.** Serve only handles the web interface. Pi-hole listens for DNS queries on port `53` of the Tailscale IP address of the device.
- **No DHCP server.** The stack does not publish port `67` and does not give the application the `NET_ADMIN` capability, which the Pi-hole DHCP server needs.

## First run

1. Pi-hole generates a random password for the web interface at the first start. Find it in the log:

   ```bash
   docker logs app-pihole 2>&1 | grep "random password"
   ```

   To set your own password, run:

   ```bash
   docker exec app-pihole pihole setpassword 'your-password'
   ```

2. Open the web interface and log in.

## Configuration

### Use Pi-hole as the DNS server of your Tailnet

Follow the [Pi-hole guide from Tailscale](https://tailscale.com/kb/1114/pi-hole). In short:

1. In the Pi-hole web interface, go to **Settings** > **DNS**, switch from **Basic** to **Expert**, and select **Permit all origins** under the interface settings. Tailnet devices have `100.x.y.z` addresses, which Pi-hole does not treat as local.
2. In the Tailscale admin console, open the **DNS** page. Add the Tailscale IP address of the `pihole` device as a custom nameserver and enable **Override DNS servers**.

### Offer DNS to your local network

Uncomment the `ports:` line of the `tailscale` service in `compose.yaml` and add port `53` below it:

```yaml
    ports:
      - 0.0.0.0:53:53/tcp
      - 0.0.0.0:53:53/udp
```

Pi-hole also needs the **Permit all origins** setting for this, because the queries arrive through Docker's bridge network.

On a host that runs `systemd-resolved`, port `53` is already in use. See [Free up port 53 on the Docker host](../../documentation/free-up-port-53.md).

## Links

- [Pi-hole documentation](https://docs.pi-hole.net/)
- [Pi-hole Docker image](https://github.com/pi-hole/docker-pi-hole)
- [Pi-hole source code](https://github.com/pi-hole/pi-hole)
