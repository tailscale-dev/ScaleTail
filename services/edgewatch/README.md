# EdgeWatch

[EdgeWatch](https://github.com/crypt0rr/EdgeWatch) scans your internet-facing systems on a schedule with Nmap and Naabu, learns which ports and services are expected, and notifies you when the exposed surface changes.

This stack runs EdgeWatch with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). EdgeWatch has no built-in Tailscale support and its image contains no Tailscale client, so the sidecar publishes the web interface with Tailscale Serve, the proxy that the upstream documentation describes.

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://edgewatch.<tailnet>.ts.net`                      |
| Service port  | `8080`                                                    |
| Image         | `ghcr.io/crypt0rr/edgewatch:latest`                       |
| Data          | `./edgewatch-data/` (database and keys), `./config.yaml`  |

## Before you start

- **Set `web.allowed_hosts` in `config.yaml`.** Replace `<tailnet>` in `edgewatch.<tailnet>.ts.net` with your Tailnet DNS name, such as `tail1234`. If you change `SERVICE` in `.env`, change the first part of the name as well. Until you set it, EdgeWatch stops at start with `web.allowed_hosts[0]: invalid host name "edgewatch.<tailnet>.ts.net"`. It answers any other host name with `421 Misdirected Request`.
- **Let Docker create `./edgewatch-data`, or create it as root.** EdgeWatch runs as root without the capability to override file permissions, so the folder must belong to root. Docker creates it that way at the first start. To create it yourself, as upstream does, run `sudo install -d -m 0750 -o 0 -g 0 ./edgewatch-data`.
- **Docker Engine 25 or later.** The health check uses `start_interval`, which older Docker Engine releases do not support.
- **Scan only systems you own or may assess.** Full-range UDP scans can take hours and create a lot of traffic.

## Deviations from the standard setup

- **Configuration file.** EdgeWatch reads its settings from `config.yaml`, which the stack mounts read-only. It is upstream's `config.example.yaml` with `web.allowed_hosts` and `web.trusted_proxies` set for Tailscale Serve, which connects from loopback. Compose cannot write the file from a `configs` block, because the container's root filesystem is read-only.
- **Scans use the network of the `tailscale` container.** Upstream runs EdgeWatch with host networking. Here, as in every stack, the application shares the network of the sidecar. Scans reach the internet through the stack's Docker network, and Tailnet devices when your Tailnet policy allows it. They cannot reach containers on other Docker networks until you attach those networks, as described under "Configuration", and the scanners cannot see the host's own network interfaces. The address `127.0.0.1` is the loopback of the `tailscale` container.
- **No `ports` block.** EdgeWatch accepts connections on `127.0.0.1` only, so a published host port cannot reach it. Use Tailscale Serve.
- **Hardening from upstream.** The `application` container drops every capability and adds back `NET_RAW` for Nmap and Naabu, and `SETUID`, `SETGID`, and `KILL`, which EdgeWatch uses to run each scanner and the notification process under its own unprivileged user. It also sets `no-new-privileges`, a read-only root filesystem, and a `/tmp` tmpfs of 128 MB. `TMPDIR` points to the data folder, where Nmap, Naabu, and SQLite write their temporary files.
- **Limits from upstream.** The container may use 512 MB of memory, which covers a scan of a `/16`. It gets seven minutes to stop, so the daemon can save a large scan, and its log is limited to three files of 10 MB.
- **Health check.** The check calls `/healthz` every 30 seconds, with a start period of 20 minutes so that database migrations can finish after an upgrade.

## First run

1. Get the one-time setup token, which expires after 15 minutes:

   ```sh
   docker compose logs application | grep setup_token
   ```

2. Open the web interface and create the first administrator with the token.
3. Open **Jobs → New job** and follow the guided setup to choose targets, ports, a schedule, and alerts.

If the token expired before you finished, or the log no longer shows it because the container was recreated, issue a new one:

```sh
docker compose exec application edgewatch admin setup-token --config /etc/edgewatch/config.yaml --force
```

## Configuration

- **Settings.** Edit `config.yaml` and apply it with `docker compose up -d --force-recreate application`. The [configuration reference](https://edgewatch.offsec.nl/reference/configuration/) describes every setting, such as `retention`, `scanner.target_exclusions`, and `backup`.
- **Time zone.** The stack passes `TZ` from `.env`, which sets the time zone of the daemon log. The optional `timezone` setting in `config.yaml` also sets it for the web interface and notifications.
- **Naabu SYN scans.** A Naabu profile with `scan_type: syn` also needs `NET_ADMIN`. Add it to `cap_add` of the `application` service in a `compose.override.yaml`, as upstream's `compose.syn.yaml` does.
- **Other Docker networks.** Docker keeps networks apart, so the scanners cannot reach containers in other stacks. To scan them, attach their networks to the `tailscale` service, for example in a `compose.override.yaml`. The `application` service uses the network of the `tailscale` service and cannot join networks itself.

  ```yaml
  services:
    tailscale:
      networks:
        - default # Keep the network of this stack
        - other-stack

  networks:
    other-stack:
      name: other-stack_default # The name that docker network ls shows
      external: true
  ```

  Then add the containers to a job by name or IP address. The network must exist before this stack starts, and the other stack cannot remove it while this stack is attached. For Tailnet targets, use Tailscale IP addresses: `TS_ACCEPT_DNS=true` would resolve MagicDNS names, but container names would no longer resolve.
- **Metrics.** Tailscale Serve forwards every path, so when you enable `web.metrics`, every Tailnet device that may reach this one can request `/metrics`, which then only needs the bearer token. Upstream recommends keeping `/metrics` off the proxy. See [health and metrics](https://edgewatch.offsec.nl/deployment/reverse-proxies/#health-and-metrics).
- **Back up** `./edgewatch-data` as a whole. It holds the database and the generated encryption keys. See [backup and recovery](https://edgewatch.offsec.nl/operations/backup-recovery/).

## Troubleshooting

- **`mkdir /var/lib/edgewatch/tmp: permission denied`.** `./edgewatch-data` does not belong to root. Stop the stack, then run `sudo chown -R 0:0 ./edgewatch-data` and `sudo chmod 0750 ./edgewatch-data`.
- **`421 Misdirected Request`.** The address you opened is not in `web.allowed_hosts`. Check the name against `docker compose exec tailscale tailscale status --json | jq -r .Self.DNSName`, without the final dot, and recreate the container.

## Links

- [EdgeWatch documentation](https://edgewatch.offsec.nl/)
- [Installation](https://edgewatch.offsec.nl/getting-started/installation/), [Tailscale Serve and reverse proxies](https://edgewatch.offsec.nl/deployment/reverse-proxies/), and [container hardening](https://edgewatch.offsec.nl/deployment/container-hardening/)
- [EdgeWatch source code](https://github.com/crypt0rr/EdgeWatch)
