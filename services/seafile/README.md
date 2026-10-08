# Seafile

[Seafile Community Edition](https://www.seafile.com/en/product/seafile_on_premise/) is a file synchronisation and sharing platform. You store your files in libraries, synchronise them with the desktop and mobile clients, and share them with others.

This stack runs Seafile with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                    |
| ------------- | -------------------------------------------------------- |
| Web interface | `https://seafile.<tailnet>.ts.net`                       |
| Service port  | `80`                                                     |
| Images        | `seafileltd/seafile-mc:13.0-latest`                      |
|               | `mariadb:10.11`                                          |
|               | `memcached:1.6.29`                                       |
| Data          | `./seafile-data` (Seafile, set by `SEAFILE_VOLUME`)      |
|               | `./db` (MariaDB database, set by `SEAFILE_MYSQL_VOLUME`) |

## Before you start

Set these values in `.env`:

- **`SEAFILE_SERVER_HOSTNAME`.** The name of the device on your Tailnet, `seafile.<tailnet>.ts.net`.
- **`INIT_SEAFILE_MYSQL_ROOT_PASSWORD` and `SEAFILE_MYSQL_DB_PASSWORD`.** The passwords of the database. Use random values of letters and digits. Compose stops with an error if either is empty.
- **`INIT_SEAFILE_ADMIN_EMAIL` and `INIT_SEAFILE_ADMIN_PASSWORD`.** The administrator account that Seafile creates at the first start. The password is empty, and Compose stops with an error until you set it. The address does not need to exist, unless you configure email notifications later.
- **`JWT_PRIVATE_KEY`.** A random value. Generate one with `openssl rand -base64 40`.
- **`SEAFILE_VOLUME` and `SEAFILE_MYSQL_VOLUME`.** The data folders. Change them to store the data elsewhere.

MariaDB and Seafile apply the database passwords only at the first start.

## Deviations from the standard setup

- **Service names.** The application service is called `seafile`, not `application`, and its container has no fixed name.
- **Extra containers.** The stack runs `db` (MariaDB) and `memcached`. They use the default Compose network, and Seafile reaches them by their service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Images are set in `.env`.** The stack does not use `IMAGE_URL`. `SEAFILE_IMAGE`, `SEAFILE_DB_IMAGE`, and `SEAFILE_MEMCACHED_IMAGE` select the images. Keep the Memcached image on a Debian-based tag, because its health check needs `perl`, which Alpine tags lack.
- **Small deployment.** The stack is meant for a handful of users. It leaves out the SeaDoc, Collabora, and notification servers, and it uses Memcached instead of Redis.
- **Data folders.** The data is in `./seafile-data` and `./db`.

## First run

Open the web interface and log in with the administrator account from `.env`.

## Troubleshooting

### Seafile cannot connect to the database

Seafile waits for the database before it starts and logs nothing while it waits. The Seafile container stays up, turns `unhealthy`, and the web interface answers `502 Bad Gateway`. Two causes are common.

**`TS_ACCEPT_DNS=true` is enabled.** With this setting, Tailscale replaces Docker's DNS, and the names `db` and `memcached` no longer resolve. Check whether the names resolve:

```bash
docker compose exec seafile getent hosts db memcached
```

If the command prints nothing, comment out `TS_ACCEPT_DNS` in `compose.yaml` and run `docker compose up -d`. Seafile does not need MagicDNS, and Tailscale Serve works without this setting.

**The database passwords changed after the first start.** Later changes in `.env` do not reach the existing database, so Seafile can no longer log in, and `docker logs app-seafile-db` shows `Access denied for user`. Restore the original passwords. On a new installation without data, you can instead stop the stack, delete the folders from `SEAFILE_MYSQL_VOLUME` and `SEAFILE_VOLUME`, and start again.

## Upgrading

Earlier versions of this stack had sample values for `INIT_SEAFILE_MYSQL_ROOT_PASSWORD`, `SEAFILE_MYSQL_DB_PASSWORD`, and `INIT_SEAFILE_ADMIN_PASSWORD` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample value, set `SEAFILE_MYSQL_DB_PASSWORD=REPLACE_WITH_RANDOM_ALPHANUMERIC_PASSWORD` again. The database still uses it.

## Links

- [Seafile Docker setup](https://manual.seafile.com/latest/setup/setup_ce_by_docker/)
- [Seafile administration manual](https://manual.seafile.com/latest/)
- [Seafile source code](https://github.com/haiwen/seafile)
