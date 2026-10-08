# Paperless-ngx

[Paperless-ngx](https://docs.paperless-ngx.com/) is a document management system. It turns your scans and files into a searchable archive with text recognition, tags, and correspondents.

This stack runs Paperless-ngx with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                            |
| ------------- | -------------------------------------------------------------------------------- |
| Web interface | `https://paperless.<tailnet>.ts.net`                                             |
| Service port  | `80`                                                                             |
| Images        | `ghcr.io/paperless-ngx/paperless-ngx`                                            |
|               | `docker.io/library/postgres`                                                     |
|               | `docker.io/library/redis`                                                        |
| Data          | `./paperless-data/consume` (inbox: Paperless-ngx imports files from this folder) |
|               | `./paperless-data/media` (your documents)                                        |
|               | `./paperless-data/data` (search index and logs)                                  |
|               | `./paperless-data/export` (exports)                                              |
|               | `./paperless-data/pgdata` (PostgreSQL database)                                  |
|               | `./paperless-data/redisdata` (Redis data)                                        |

## Before you start

Change these values in `.env`:

- **`PAPERLESS_SECRET_KEY`.** A long random value. Generate one with `openssl rand -hex 32`. Paperless-ngx uses it to sign session tokens. Compose stops with an error if it is empty.
- **`PAPERLESS_ADMIN_USER` and `PAPERLESS_ADMIN_PASSWORD`.** The administrator account that Paperless-ngx creates at the first start. The default user is `admin`. The password is empty, and Compose stops with an error until you set it.
- **`POSTGRES_PASSWORD`.** The password of the database. Compose stops with an error if it is empty.
- **`PAPERLESS_OCR_LANGUAGE`.** The language of your documents as a three-letter code, such as `eng` or `nld`.
- **`PAPERLESS_TIME_ZONE`.** Your time zone.

## Deviations from the standard setup

- **Extra containers.** The stack runs `db` (PostgreSQL) and `broker` (Redis). They use the default Compose network, and Paperless-ngx reaches them by their service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Service port.** `PAPERLESS_PORT=80` makes Paperless-ngx listen on port `80` and not on its default port `8000`.
- **HTTPS behind Tailscale Serve.** `PAPERLESS_PROXY_SSL_HEADER` tells Paperless-ngx that Tailscale Serve provides HTTPS.

## First run

Open the web interface and log in with the administrator account from `.env`. To import documents, upload them in the web interface or put them in `./paperless-data/consume`.

## Upgrading

Earlier versions of this stack had sample values for `PAPERLESS_SECRET_KEY`, `PAPERLESS_ADMIN_PASSWORD`, and `POSTGRES_PASSWORD` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start.

## Links

- [Paperless-ngx documentation](https://docs.paperless-ngx.com/)
- [Paperless-ngx source code](https://github.com/paperless-ngx/paperless-ngx)
