# ntfy

[ntfy](https://ntfy.sh/) is a notification service. Scripts and applications publish messages to a topic with a simple HTTP request, and your phone or browser receives them.

This stack runs ntfy with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                           |
| ------------- | ----------------------------------------------- |
| Web interface | `https://ntfy.<tailnet>.ts.net`                 |
| Service port  | `80`                                            |
| Image         | `binwiederhier/ntfy`                            |
| Data          | `./ntfy-data/etc` (configuration, `server.yml`) |
|               | `./ntfy-data/cache` (message cache)             |

## Before you start

Create the data folders yourself and make user `1000` their owner. Docker creates missing folders as user `root`. ntfy runs as user `1000` and cannot write to folders that `root` owns.

```bash
mkdir -p ntfy-data/etc ntfy-data/cache
sudo chown -R 1000:1000 ntfy-data
```

## Deviations from the standard setup

- **Fixed user.** The `application` container runs as user and group `1000` through the `user` setting.
- **Start command.** The stack starts ntfy with the `serve` command.

## First run

ntfy has no login by default. Everyone who can reach the device on your Tailnet can read and publish all topics.

1. Open the web interface and subscribe to a topic.
2. Publish a test message from a device on your Tailnet:

   ```bash
   curl -d "Hello from ScaleTail" https://ntfy.<tailnet>.ts.net/mytopic
   ```

3. In the ntfy mobile app, set `https://ntfy.<tailnet>.ts.net` as the server.

## Configuration

ntfy reads its settings from `./ntfy-data/etc/server.yml`. Create the file and restart the stack to apply it. These settings are useful behind Tailscale Serve:

```yaml
base-url: "https://ntfy.<tailnet>.ts.net"
behind-proxy: true
cache-file: "/var/cache/ntfy/cache.db"
```

- `base-url` is required for attachments and for notifications on iOS.
- `behind-proxy` makes ntfy rate-limit each visitor separately. Without it, all visitors count as one.
- `cache-file` keeps messages across restarts. Without it, ntfy keeps them in memory for 12 hours.

To require a login, set `auth-file` and `auth-default-access: "deny-all"`. See the [ntfy configuration documentation](https://docs.ntfy.sh/config/).

## Links

- [ntfy documentation](https://docs.ntfy.sh/)
- [ntfy source code](https://github.com/binwiederhier/ntfy)
