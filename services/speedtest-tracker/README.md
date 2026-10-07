# Speedtest Tracker

[Speedtest Tracker](https://docs.speedtest-tracker.dev/) tests the speed of your internet connection on a schedule. It keeps the history and shows it in graphs.

This stack runs Speedtest Tracker with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                   |
| ------------- | ------------------------------------------------------- |
| Web interface | `https://speedtest-tracker.<tailnet>.ts.net`            |
| Service port  | `8888`                                                  |
| Image         | `lscr.io/linuxserver/speedtest-tracker`                 |
| Data          | `./speedtest-tracker-data` (configuration and database) |
|               | `./nginx/default.conf` (web server configuration)       |

## Before you start

Set `APP_KEY` in `.env`. Generate the value with `echo "base64:$(openssl rand -base64 32)"`. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **Web server port.** This directory contains `nginx/default.conf`, which makes the web server in the container listen on port `8888`. The stack mounts it over the configuration of the image.
- **Database.** `DB_CONNECTION=sqlite` makes Speedtest Tracker store its data in a SQLite database in the data folder.

## First run

Open the web interface and log in with the default account `admin@example.com` and password `password`. Change both right after you log in.

## Upgrading

If you set `APP_KEY` in `compose.yaml` before, move that value to `.env`. A new key cannot decrypt the data that Speedtest Tracker already encrypted.

## Links

- [Speedtest Tracker documentation](https://docs.speedtest-tracker.dev/)
- [Speedtest Tracker source code](https://github.com/alexjustesen/speedtest-tracker)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-speedtest-tracker/)
