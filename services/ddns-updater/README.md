# DDNS Updater

[DDNS Updater](https://github.com/qdm12/ddns-updater) keeps the DNS records of your domains pointed at your current public IP address. It supports many DNS providers and shows the state of each record in a web interface.

This stack runs DDNS Updater with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                  |
| ------------- | ---------------------------------------------------------------------- |
| Web interface | `https://ddns-updater.<tailnet>.ts.net`                                |
| Service port  | `8000`                                                                 |
| Image         | `qmcgaw/ddns-updater`                                                  |
| Data          | `./ddns-updater-data/data` (your `config.json` and the update history) |

## Before you start

Create the data folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. DDNS Updater runs as user `1000` and then exits with `permission denied` when it writes `config.json`.

```bash
mkdir -p ddns-updater-data/data
sudo chown -R 1000:1000 ddns-updater-data
```

## Deviations from the standard setup

- **Settings through environment variables.** `compose.yaml` sets the update period, the services that report your public IP address, and the port of the web interface.

## First run

1. Start the stack once. DDNS Updater creates an empty `config.json` in `./ddns-updater-data/data`.
2. Add your domains and DNS providers to that file. The [DDNS Updater documentation](https://github.com/qdm12/ddns-updater#configuration) describes the format for each provider.
3. Restart the stack. The web interface has no login and shows the state of each record.

## Links

- [DDNS Updater documentation and source code](https://github.com/qdm12/ddns-updater)
