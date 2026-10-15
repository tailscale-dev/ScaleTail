# Wallabag

[Wallabag](https://wallabag.org/) is a read-it-later app. It saves web pages as clean articles that you can tag, annotate, and read later, from the web interface, the mobile apps, or a browser extension.

This stack runs Wallabag with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://wallabag.<tailnet>.ts.net`         |
| Service port  | `80`                                        |
| Images        | `wallabag/wallabag`                         |
|               | `mariadb:11.8`                              |
| Data          | `./wallabag-data/db` (MariaDB database)     |
|               | `./wallabag-data/images` (article pictures) |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it.
- **`WALLABAG_SECRET`.** Signs sessions and tokens. Generate one with `openssl rand -hex 32`. Without it, the image falls back to a fixed secret that is public.
- **`DATABASE_PASSWORD`.** The password of the `wallabag` database user. Generate one with `openssl rand -hex 32`. MariaDB applies it only when it first creates the database.
- **`MYSQL_ROOT_PASSWORD`.** The password of the database root user. Generate one with `openssl rand -hex 32`. MariaDB applies it only when it first creates the database. Wallabag uses it on the first start to create its database and user.

Create the folder for article pictures before the first start, and give it to the user that runs Wallabag inside the container, `nobody` with the ID `65534`. Docker would otherwise create it as `root`, and Wallabag could not save pictures there when you turn on "Download images locally" in the Misc section of the internal settings:

```sh
mkdir -p wallabag-data/images
sudo chown 65534:65534 wallabag-data/images
```

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with MariaDB. Wallabag reaches it by its Compose service name over the Docker network, and it is not reachable from your Tailnet.
- **No Redis.** The upstream Compose example adds Redis, which Wallabag uses only for asynchronous imports, and only with a separate import worker. Wallabag imports without it, so this stack leaves both out. Keep "Enable Redis to import data asynchronously" and "Enable RabbitMQ to import data asynchronously" off in the Import section of the internal settings.
- **Base address.** `SYMFONY__ENV__DOMAIN_NAME` in `compose.yaml` is the Tailnet address of the service. Wallabag uses it for the links it generates. If you change `SERVICE` or `TAILNET_NAME`, the address changes with them.

## First run

Open the web interface and log in with the default account: user `wallabag`, password `wallabag`. Change the password right away on the Config page: until you do, anyone on your Tailnet can log in. After the first login, Wallabag shows a quickstart page.

To add an article, paste its address into the add field at the top of the page. The browser extensions and the mobile apps connect to `https://wallabag.<tailnet>.ts.net`, and the device must be connected to your Tailnet. The [Wallabag documentation](https://doc.wallabag.org/) explains how to create the API client they need.

## Troubleshooting

- **`WARN: MySQL database is already configured` in the logs.** The Wallabag container found its database on a later start. The message is harmless: the entrypoint creates the database only once.

## Links

- [Wallabag documentation](https://doc.wallabag.org/)
- [Wallabag Docker image and Compose example](https://github.com/wallabag/docker)
- [Wallabag source code](https://github.com/wallabag/wallabag)
