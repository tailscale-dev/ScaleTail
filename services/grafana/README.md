# Grafana

[Grafana](https://grafana.com/oss/grafana/) shows metrics, logs, and traces from data sources such as Prometheus, Loki, InfluxDB, and PostgreSQL in dashboards, and sends alerts. This stack runs the open source edition.

This stack runs Grafana with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                   |
| ------------- | ------------------------------------------------------- |
| Web interface | `https://grafana.<tailnet>.ts.net`                      |
| Service port  | `3000`                                                  |
| Image         | `grafana/grafana:latest`                                |
| Data          | `./grafana-data/` (SQLite database, plugins, and files) |

## Before you start

1. Create the data folder yourself and make user `472` its owner. Docker creates missing folders as user `root`. The image runs Grafana as user `472`, which cannot write to a folder that `root` owns. Grafana then logs `GF_PATHS_DATA='/var/lib/grafana' is not writable` and cannot store its data.

   ```bash
   mkdir -p grafana-data
   sudo chown 472:0 grafana-data
   ```

2. Optionally, set `GRAFANA_ADMIN_PASSWORD` in `.env` to the password of the `admin` account. Generate one with `openssl rand -hex 24`. Grafana uses it only at the first start, when it creates its database. Later changes in `.env` have no effect.
3. Optionally, set `GRAFANA_ROOT_URL` in `.env` to `https://grafana.<tailnet>.ts.net/`, with your [Tailnet DNS name](https://tailscale.com/kb/1217/tailnet-name). Grafana uses this address in links, such as in alert notifications and shared dashboards. Without it, those links point to `http://localhost:3000/`.

## Deviations from the standard setup

None.

## First run

1. Open the web interface and sign in as `admin`. The password is the one from `GRAFANA_ADMIN_PASSWORD`, or `admin` when you left it empty.
2. If you signed in with `admin`, set a new password on the next screen. Do not skip it: until you change it, anyone on your Tailnet who can reach the device can sign in.
3. Add a data source under **Connections** > **Data sources**. Grafana reaches other Tailnet devices by their Tailscale IP address, such as `http://100.64.0.1:9090` for Prometheus. To use MagicDNS names instead, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).

## Configuration

- **Plugins.** Set `GRAFANA_PLUGINS` in `.env` to a comma-separated list of plugin IDs, such as `grafana-clock-panel`. Grafana installs missing plugins in `./grafana-data/plugins` at each start.
- **Other settings.** Grafana reads every setting of its configuration file from an environment variable named `GF_<SECTION>_<KEY>`, such as `GF_AUTH_ANONYMOUS_ENABLED=true`. Add them to the `environment` list of the `application` service. See [Override configuration with environment variables](https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#override-configuration-with-environment-variables).

## Links

- [Grafana documentation](https://grafana.com/docs/grafana/latest/)
- [Run the Grafana Docker image](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
- [Grafana source code](https://github.com/grafana/grafana)
