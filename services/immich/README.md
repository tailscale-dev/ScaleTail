# Immich

[Immich](https://immich.app/) is a self-hosted photo and video library. It backs up the media from your mobile devices and lets you browse, search, and share it.

This stack runs Immich with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://immich.<tailnet>.ts.net`                             |
| Service port  | `2283`                                                        |
| Images        | `ghcr.io/immich-app/immich-server`                            |
|               | `ghcr.io/immich-app/immich-machine-learning`                  |
|               | `docker.io/valkey/valkey`                                     |
|               | `ghcr.io/immich-app/postgres`                                 |
| Data          | `./immich-data/upload` (photos and videos)                    |
|               | `./immich-data/database` (Postgres database)                  |
|               | `./immich-data/model-cache` (machine learning models)         |

## Before you start

* **Set a database password.** Set `DB_PASSWORD` in `.env` to a random value. Use only the characters `A-Za-z0-9`. It is empty, and Compose stops with an error until you set it.
* **Choose where your media is stored.** To keep your photos and videos on another disk, set `UPLOAD_LOCATION` before the first start. See [Storage locations](#storage-locations).
* **Compare with upstream.** Immich changes its [Compose file](https://docs.immich.app/install/docker-compose) often. We try to keep this stack in line with it, but check for yourself before you deploy.

## Deviations from the standard setup

* **Extra containers.** Besides `application`, the stack runs `immich-machine-learning`, `redis` (Valkey), and `database` (Postgres). These three use the default Compose network and not the network of the `tailscale` container. Immich reaches them by their service name through Docker's DNS.
* **Images are set in `compose.yaml`.** The stack does not use `IMAGE_URL`. `IMMICH_VERSION` in `.env` selects the version of the server and machine learning images.
* **Keep `TS_ACCEPT_DNS` disabled.** The `application` service shares the DNS configuration of the `tailscale` service. With `TS_ACCEPT_DNS=true`, Tailscale replaces Docker's DNS with MagicDNS, which cannot resolve the `database`, `redis`, and `immich-machine-learning` services. Immich then fails to start with `getaddrinfo ENOTFOUND database`. You can reach Immich over your Tailnet without this setting.
* **The containers read the whole `.env` file.** As in the upstream Compose file, the Immich containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in the environment of the `application` and `immich-machine-learning` containers.

## First run

Open the web interface and select **Getting Started**. The first user to register becomes the administrator and can add other users.

In the Immich mobile app, use `https://immich.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Configuration

### Storage locations

`UPLOAD_LOCATION` and `DB_DATA_LOCATION` in `.env` set where Immich stores your media and its database. The defaults are `./immich-data/upload` and `./immich-data/database`. To move your media to another disk, set `UPLOAD_LOCATION` to an absolute path. Keep the database on a local disk, because Immich does not support network shares for it.

### MagicDNS names

If Immich itself must look up other Tailnet devices by name, such as an OAuth provider or SMTP server, uncomment the `dns` block of the `tailscale` service and set `100.100.100.100` as the DNS server. Docker keeps resolving the service names and forwards all other lookups to MagicDNS. Use the full name, such as `device.example.ts.net`.

### Remote machine learning

If you run the machine learning container on another Tailnet device, your Tailnet policy must allow the Immich node to reach that device on TCP port `3003`. Otherwise the `tailscale` service logs `rejected due to acl`. A grant from the Immich node to the machine learning host with `"ip": ["tcp:3003"]` is enough. Keep `TS_USERSPACE=false`, because Immich must open connections to the Tailnet. Use the host's Tailscale IP address in the machine learning URL, or its MagicDNS name with the `dns` block described above.

### Renamed services

Immich connects to the hostnames `database` and `redis` by default. If you rename these services in `compose.yaml`, set `DB_HOSTNAME` and `REDIS_HOSTNAME` in `.env` to the new names.

## Upgrading

Earlier versions of this stack ignored `UPLOAD_LOCATION` and `DB_DATA_LOCATION` and always used the default folders. If your `.env` still contains `UPLOAD_LOCATION=./library` or `DB_DATA_LOCATION=./postgres`, replace them with the defaults from [Storage locations](#storage-locations) before you restart. Otherwise Immich starts with an empty library and a new database. Your existing files stay untouched in `./immich-data`.

Earlier versions of this stack had a sample value for `DB_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start.

## Links

* [Immich documentation](https://docs.immich.app/)
* [Immich environment variables](https://docs.immich.app/install/environment-variables)
* [Immich source code](https://github.com/immich-app/immich)
