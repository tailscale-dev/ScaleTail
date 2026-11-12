# Gatus

[Gatus](https://github.com/TwiN/gatus) checks your websites and services over HTTP, ICMP, TCP, and DNS on a schedule, shows the results on a status page, and can send alerts when a check fails.

This stack runs Gatus with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                        |
| ------------- | ------------------------------------------------------------ |
| Web interface | `https://gatus.<tailnet>.ts.net`                             |
| Service port  | `8080`                                                       |
| Image         | `twinproduction/gatus:stable`                                |
| Data          | `./gatus-data/config/` (the endpoints to check)              |
|               | `./gatus-data/data/` (SQLite database with the results)      |

## Before you start

- **Second copy.** The configuration file lives in `./gatus-data`. When you change `SERVICE`, rename that folder to `<SERVICE>-data` as well. Otherwise Gatus finds no configuration file, stops with `configuration file not found`, and restarts in a loop.

## Deviations from the standard setup

- **Tracked configuration file.** The repository includes `./gatus-data/config/config.yaml`, with an exception in `.gitignore`, because Gatus does not start without a configuration file.
- **Configuration folder.** `GATUS_CONFIG_PATH=/config` makes Gatus read every YAML file in `./gatus-data/config` and merge them. Your endpoints then live in a file of your own, which git ignores, and an update of the repository does not touch it.
- **No health check.** The image contains only the `gatus` binary, with no shell, HTTP client, or health command, so the stack defines no health check for the `application` container.
- **Runs as root.** The image runs Gatus as `root`, so the files in `./gatus-data/data` belong to `root`.

## First run

Nothing to set up. Open the web interface. The first results appear after the first check, within a minute.

## Configuration

- **Add your endpoints.** Create a file of your own in `./gatus-data/config`, such as `endpoints.yaml`, with an `endpoints:` list. The tracked `config.yaml` checks only Gatus itself, and it has a commented example for a device on your Tailnet. Leave `config.yaml` as it is: when git replaces a file that holds your endpoints during an update, Gatus loads it without them and deletes their history. See [Endpoints](https://github.com/TwiN/gatus#endpoints) for the options.
- **Change the endpoints.** Gatus checks the configuration files for changes every 30 seconds and then reloads them. By default, Gatus stops when a file is invalid, and it cannot start again until you fix the file. Check the log after each change with `docker compose logs application`.
- **Tailnet devices.** Gatus reaches other Tailnet devices by their Tailscale IP address, such as `http://100.64.0.1:8080/`. To use MagicDNS names instead, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns). Your Tailnet policy must allow the connection.
- **Alerts.** Gatus can send alerts to many services, such as ntfy, Gotify, Discord, and email. See [Alerting](https://github.com/TwiN/gatus#alerting).

## Links

- [Gatus documentation](https://github.com/TwiN/gatus#table-of-contents)
- [Gatus source code](https://github.com/TwiN/gatus)
- [Gatus on Docker Hub](https://hub.docker.com/r/twinproduction/gatus)
