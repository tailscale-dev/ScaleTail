# Gramps Web

[Gramps Web](https://www.grampsweb.org/) is a web application to browse and edit your family tree together with others. It works with the data of the Gramps desktop application.

This stack runs Gramps Web with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                                             |
| ------------- | ----------------------------------------------------------------------------------------------------------------- |
| Web interface | `https://grampsweb.<tailnet>.ts.net`                                                                              |
| Service port  | `5000`                                                                                                            |
| Images        | `ghcr.io/gramps-project/grampsweb`                                                                                |
|               | `docker.io/library/redis:7.2.4-alpine`                                                                            |
| Data          | `./grampsweb-data/gramps_db` (family tree database)                                                               |
|               | `./grampsweb-data/gramps_media` (media files)                                                                     |
|               | `./grampsweb-data/gramps_users` (user database)                                                                   |
|               | `./grampsweb-data/gramps_secret` (secret key)                                                                     |
|               | `./grampsweb-data/gramps_index`, `gramps_thumb_cache`, `gramps_cache`, and `gramps_tmp` (search index and caches) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Extra containers.** The stack runs `grampsweb_celery`, a worker for background tasks that uses the same image and the same data folders, and `grampsweb_redis`. The worker uses the network of the `tailscale` container, like Gramps Web itself. Redis uses the default Compose network, and Gramps Web reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Tree name.** `GRAMPSWEB_TREE` in `compose.yaml` sets the name of the family tree to `Gramps Web`.

## First run

Open the web interface. Gramps Web asks you to create the owner account. Then start an empty tree or import a Gramps XML file.

## Links

- [Gramps Web documentation](https://www.grampsweb.org/)
- [Gramps Web source code](https://github.com/gramps-project/gramps-web)
