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
- **Change the database password.** `compose.yaml` uses the password `example` for the MySQL `root` user, in `database__connection__password` and in `MYSQL_ROOT_PASSWORD`. Replace both with the same value of your own before the first start.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with MySQL, named `db-ghost`. It uses the default Compose network, and Ghost reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Service port.** Ghost listens on port `2368`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

Open `https://ghost.<tailnet>.ts.net/ghost` and create the first account, which becomes the owner of the site.

## Links

- [Ghost documentation](https://ghost.org/docs/)
- [Ghost Docker image](https://hub.docker.com/_/ghost)
- [Ghost source code](https://github.com/TryGhost/Ghost)
