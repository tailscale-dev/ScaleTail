# BookLore

[BookLore](https://github.com/booklore-app/booklore) manages your book collection and lets you read it in the browser. It supports several users and many book formats, and it synchronises with Kobo and KOReader devices.

This stack runs BookLore with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                |
| ------------- | ---------------------------------------------------- |
| Web interface | `https://booklore.<tailnet>.ts.net`                  |
| Service port  | `6060`                                               |
| Images        | `ghcr.io/booklore-app/booklore`                      |
|               | `lscr.io/linuxserver/mariadb`                        |
| Data          | `./data` (application data)                          |
|               | `./books` (book library, `/books1` in the container) |
|               | `./mariadb_config` (database)                        |

## Before you start

- **Set the database passwords.** `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` in `.env` are empty. Give both a random value. Compose stops with an error until you set them.
- **Choose your book folder.** To use an existing collection, point the `/books1` volume in `compose.yaml` at your own folder. Otherwise the stack starts with an empty `./books` folder.

## Deviations from the standard setup

- **Extra container.** The stack runs a `mariadb` container for the database. It uses the default Compose network, and BookLore reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Data folders.** The data is in `./data`, `./books`, and `./mariadb_config`, not in a `./booklore-data` folder.
- **Service port.** BookLore listens on port `6060`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

Open the web interface and create the administrator account. Then create a library with `/books1` as its folder.

## Links

- [BookLore documentation and source code](https://github.com/booklore-app/booklore)
