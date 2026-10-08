# XWiki

[XWiki](https://www.xwiki.org) is a wiki platform for documentation and knowledge management. It has structured pages, rights management, and many extensions.

This stack runs XWiki with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                     |
| ------------- | ----------------------------------------- |
| Web interface | `https://xwiki.<tailnet>.ts.net`          |
| Service port  | `8080`                                    |
| Images        | `xwiki:stable-mariadb-tomcat`             |
|               | `mariadb:12`                              |
| Data          | `./xwiki-data/xwiki` (XWiki data)         |
|               | `./xwiki-data/mariadb` (MariaDB database) |

## Before you start

Set `DB_PASSWORD` and `MARIADB_ROOT_PASSWORD` in `.env` before the first start. Both are empty, and Compose stops with an error until you set them. Use random values of letters and digits.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with MariaDB, named `db-xwiki`. It uses the default Compose network, and XWiki reaches it by its container name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Database setup.** This directory contains `init.sql`, which the database container runs when it first creates the database.
- **Service port.** XWiki listens on port `8080`. `SERVICEPORT` in `.env` is only used by the optional `ports` block.

## First run

Open the web interface. The first start takes a few minutes. XWiki then shows its distribution wizard, where you create the administrator account and install the standard flavor.

## Upgrading

Earlier versions of this stack had sample values for `DB_PASSWORD` and `MARIADB_ROOT_PASSWORD` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample values, set `DB_PASSWORD` and `MARIADB_ROOT_PASSWORD` to `xwiki` again. The database still uses them.

## Links

- [XWiki documentation](https://www.xwiki.org/xwiki/bin/view/Documentation/)
- [XWiki Docker image](https://github.com/xwiki/xwiki-docker)
