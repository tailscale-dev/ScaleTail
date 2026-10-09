# Ghost

[Ghost](https://ghost.org/) is a publishing platform for blogs, newsletters, and online publications.

This stack runs Ghost with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                               |
| ------------- | --------------------------------------------------------------------------------------------------- |
| Web interface | `https://ghost.<tailnet>.ts.net` (site) and `https://ghost.<tailnet>.ts.net/ghost` (administration) |
| Service port  | `2368`                                                                                              |
| Images        | `ghost:5-alpine`                                                                                    |
|               | `mysql:8.0`                                                                                         |
| Data          | `./ghost-data/ghost` (themes, images, and settings)                                                 |
|               | `./ghost-data/db` (MySQL database)                                                                  |

## Before you start

- **Set `GHOST_URL` in `.env`.** Use the address of the site, `https://ghost.<tailnet>.ts.net`. Ghost does not start with the sample value and reports `Invalid URL`.
- **Set `MYSQL_ROOT_PASSWORD` in `.env`.** The password of the MySQL `root` user, which Ghost uses to connect to the database. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with MySQL, named `db-ghost`. It uses the default Compose network, and Ghost reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Service port.** Ghost listens on port `2368`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

Open `https://ghost.<tailnet>.ts.net/ghost` and create the first account, which becomes the owner of the site.

## Upgrading

Earlier versions of this stack had the password `example` for the MySQL `root` user in `compose.yaml`. The password is now `MYSQL_ROOT_PASSWORD` in `.env`. It is empty, and Compose stops with an error until you set it. If you already run the stack, set it to the password that you use now, because the database applies it only at the first start. If you kept the sample value, set `MYSQL_ROOT_PASSWORD=example` again. The database still uses it.

## Links

- [Ghost documentation](https://ghost.org/docs/)
- [Ghost Docker image](https://hub.docker.com/_/ghost)
- [Ghost source code](https://github.com/TryGhost/Ghost)
