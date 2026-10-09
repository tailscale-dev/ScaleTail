# EspoCRM

[EspoCRM](https://www.espocrm.com/) is a customer relationship management application. You manage your contacts, companies, opportunities, and projects in one web interface.

This stack runs EspoCRM with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                       |
| ------------- | --------------------------------------------------------------------------- |
| Web interface | `https://espocrm.<tailnet>.ts.net`                                          |
| Service port  | `80`                                                                        |
| Images        | `espocrm/espocrm`                                                           |
|               | `mariadb:12.2`                                                              |
| Data          | `./espocrm-data/data` (application data)                                    |
|               | `./espocrm-data/custom` and `./espocrm-data/client/custom` (customisations) |
|               | `./espocrm-db` (MariaDB database)                                           |

## Before you start

Set these values in `.env`:

- **`TS_DOMAIN`.** Your Tailnet name with `.ts.net`. The stack builds the address of the site, `ESPOCRM_SITE_URL`, from `SERVICE` and this value.
- **`ESPOCRM_ADMIN_USERNAME` and `ESPOCRM_ADMIN_PASSWORD`.** The administrator account that EspoCRM creates at the first start. The default user is `admin`. The password is empty, and Compose stops with an error until you set it.
- **`MARIADB_ROOT_PASSWORD`, `MARIADB_PASSWORD`, and `ESPOCRM_DATABASE_PASSWORD`.** The passwords of the database. They are empty, and Compose stops with an error until you set them. `MARIADB_PASSWORD` and `ESPOCRM_DATABASE_PASSWORD` must be the same.

## Deviations from the standard setup

- **Extra container.** The stack runs a `database` container with MariaDB, named `db-espocrm`. It uses the default Compose network, and EspoCRM reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Data folders.** The database is in `./espocrm-db`, outside the `./espocrm-data` folder.

## First run

Open the web interface and log in with the administrator account from `.env`.

## Upgrading

From EspoCRM 10, the upstream Docker setup no longer mounts the whole `/var/www/html` folder. This stack follows it and mounts only `data`, `custom`, and `client/custom` from `./espocrm-data`, so existing data and customisations stay in place.

1. Back up `./espocrm-data`.
2. Run `docker compose down`, then `docker compose pull` and `docker compose up -d`.
3. Optionally, remove the files that older images copied into `./espocrm-data`, such as `application`, `vendor`, and `bootstrap.php`. The [EspoCRM 10 migration guide](https://docs.espocrm.com/administration/docker/installation/#migration-to-espocrm-10) lists them all.

Earlier versions of this stack had sample values for `ESPOCRM_ADMIN_PASSWORD`, `MARIADB_ROOT_PASSWORD`, `MARIADB_PASSWORD`, and `ESPOCRM_DATABASE_PASSWORD` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample values, set `MARIADB_ROOT_PASSWORD`, `MARIADB_PASSWORD`, and `ESPOCRM_DATABASE_PASSWORD` to `password` again. The database still uses it.

`ESPOCRM_ADMIN_PASSWORD` only creates the administrator at the first start. A new value does not change an existing account. If you still log in as `admin` with the password `password`, change the password in the web interface.

## Links

- [EspoCRM documentation](https://docs.espocrm.com/)
- [EspoCRM Docker installation](https://docs.espocrm.com/administration/docker/installation/)
- [EspoCRM source code](https://github.com/espocrm/espocrm)
