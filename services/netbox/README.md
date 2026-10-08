# NetBox

[NetBox](https://netboxlabs.com/oss/netbox/) is the source of truth for your network. You document your IP addresses, racks, devices, connections, and circuits in it.

This stack runs NetBox with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                 |
| ------------- | --------------------------------------------------------------------- |
| Web interface | `https://netbox.<tailnet>.ts.net`                                     |
| Service port  | `8080`                                                                |
| Images        | `docker.io/netboxcommunity/netbox`                                    |
|               | `docker.io/postgres:17-alpine`                                        |
|               | `docker.io/valkey/valkey:8.1-alpine`                                  |
| Data          | `./netbox/media`, `./netbox/reports`, and `./netbox/scripts` (NetBox) |
|               | `./netbox/postgres/data` (PostgreSQL database)                        |
|               | `./netbox/redis/data` and `./netbox/redis/cache` (Valkey)             |
|               | `./config` (NetBox configuration files, also used by Tailscale)       |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`SUPER_SECRET`.** The base value for the passwords of PostgreSQL and Valkey. Use letters and digits only. Generate one with `openssl rand -hex 16`. PostgreSQL applies its password only when it first creates the database.
- **`SECRET_KEY`.** A random value of at least 50 characters. Generate one with `openssl rand -base64 48`.

## Deviations from the standard setup

- **Extra containers.** The stack runs `netbox-worker`, `postgres`, `redis`, and `redis-cache`. The worker uses the network of the `tailscale` container, like NetBox itself. The other three use the default Compose network, and NetBox reaches them by their container name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Service and container names.** The application service is called `netbox`, not `application`, and the containers are named `netbox`, `worker-netbox`, `netbox-postgres`, `netbox-redis`, and `netbox-rediscache`.
- **Configuration files.** This directory contains the NetBox configuration files in `./config`, which the stack mounts read-only. The `tailscale` container stores its files in the same folder.
- **Data folder.** The data is in `./netbox`, not in a `./netbox-data` folder.
- **The containers read the whole `.env` file.** All containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in their environment.
- **No administrator at the first start.** `SKIP_SUPERUSER=true` in `.env` stops NetBox from creating a default administrator.

## First run

The first start takes about four minutes, because NetBox prepares its database. Then create the administrator account:

```bash
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser
```

Open the web interface and log in with that account.

## Upgrading

If you are upgrading, set `SUPER_SECRET` to the value from your previous `.env`, including the old default if you never changed it. Otherwise NetBox cannot log in to the existing database.

## Links

- [NetBox documentation](https://netboxlabs.com/docs/netbox/)
- [netbox-docker wiki](https://github.com/netbox-community/netbox-docker/wiki)
- [NetBox source code](https://github.com/netbox-community/netbox)
