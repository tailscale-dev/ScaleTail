# Invoice Ninja

[Invoice Ninja](https://invoiceninja.com/) is an invoicing and billing app for quotes, invoices, recurring invoices, expenses, and payments, with a client portal.

This stack runs Invoice Ninja with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                           |
| ------------- | --------------------------------------------------------------- |
| Web interface | `https://invoiceninja.<tailnet>.ts.net`                         |
| API           | `https://invoiceninja.<tailnet>.ts.net/api/v1`                  |
| Service port  | `80`                                                            |
| Images        | `invoiceninja/invoiceninja-octane:5`                            |
|               | `mysql:8.4`                                                     |
|               | `redis:8-alpine`                                                |
| Data          | `./invoiceninja-data/storage` (uploads, logos, logs, and cache) |
|               | `./invoiceninja-data/db` (MySQL database)                       |
|               | `./invoiceninja-data/redis` (Redis data)                        |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it, as `APP_URL`.
- **`APP_KEY`.** Encrypts sessions and stored secrets. Generate one with `echo "base64:$(openssl rand -base64 32)"`.
- **`DB_PASSWORD`.** The password of the `ninja` database user. Generate one with `openssl rand -hex 32`. MySQL applies it only when it first creates the database.
- **`DB_ROOT_PASSWORD`.** The password of the database root user. Generate one with `openssl rand -hex 32`. MySQL applies it only when it first creates the database.
- **`IN_USER_EMAIL` and `IN_PASSWORD`.** The email address and password of the first administrator. Invoice Ninja creates this account on the first start only. A new value later does not change the account.

Create the storage folder before the first start, and give it to the user that runs Invoice Ninja inside the container, `ninja` with the ID `999`. Docker would otherwise create it as `root`, and Invoice Ninja could not write to it:

```sh
mkdir -p invoiceninja-data/storage
sudo chown 999:999 invoiceninja-data/storage
```

## Deviations from the standard setup

- **Image.** The stack uses the official Octane image, in which FrankenPHP serves the web interface on port `80`. The older `invoiceninja/invoiceninja` image is deprecated. The official Debian image runs PHP-FPM and needs a separate nginx container.
- **Extra containers.** Two more containers run the same image, and two run its dependencies. Only the application uses the network of the `tailscale` container. The others use the default Compose network, and none is reachable from your Tailnet. Keep `TS_ACCEPT_DNS` disabled, because the containers find each other by their Compose service names.
  - `worker` (`app-invoiceninja-worker`) runs the job queue, which sends emails and runs background jobs. The upstream Compose file runs two workers. This stack runs one, because a container with a fixed name cannot have replicas.
  - `scheduler` (`app-invoiceninja-scheduler`) runs recurring invoices, reminders, and other scheduled tasks.
  - `db` (`app-invoiceninja-db`) runs MySQL.
  - `redis` (`app-invoiceninja-redis`) runs Redis, for the cache, the sessions, and the job queue. It logs each write to an append-only file, which the upstream Compose file does not, so a crash loses at most about one second of queued jobs.
- **Scheduler command.** The scheduler runs `php artisan schedule:work`, not the FrankenPHP command of the upstream Compose file. Through FrankenPHP, every scheduled task fails with `unknown command "artisan" for "frankenphp"`, see [invoiceninja/dockerfiles#902](https://github.com/invoiceninja/dockerfiles/issues/902).
- **Health checks.** The worker and the scheduler check their own process with `pgrep`, because the health check of the image calls the web server, which runs only in the application container.
- **Settings.** `compose.yaml` passes the settings of Invoice Ninja to each container. The upstream Compose file reads the whole `.env` instead, which would also give the containers your Tailscale auth key and the root password of the database.
- **HTTPS.** Tailscale Serve handles HTTPS. `REQUIRE_HTTPS` is `false`, because Invoice Ninja receives plain HTTP from Serve.
- **No Caddy data.** The upstream Compose file keeps the `/data` folder of the built-in Caddy server. This stack does not, because Caddy serves only plain HTTP here and stores no certificates.

## First run

Open the web interface and log in with `IN_USER_EMAIL` and `IN_PASSWORD` from `.env`. Then change the password in the web interface. The first password stays in `.env`, because Compose needs both values at every start, although Invoice Ninja reads them only at the first.

## Configuration

- **Email.** By default, `MAIL_MAILER=log` writes each email to `./invoiceninja-data/storage/logs/laravel.log` instead of sending it. To send emails, set `MAIL_MAILER=smtp`, and set `MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`, `MAIL_ENCRYPTION`, `MAIL_FROM_ADDRESS`, and `MAIL_FROM_NAME` in `.env`. Then run `docker compose up -d` to recreate the containers.
- **Clients outside your Tailnet.** The web interface and the client portal are reachable only on your Tailnet. By default, an email to a client links to the client portal, so a client who is not on your Tailnet cannot open the invoice or pay it online. To send the invoice itself, enable "Attach PDF" under Settings > Email Settings in the web interface. Payment gateways and email providers cannot reach Invoice Ninja with webhooks either, so features that depend on them, such as payment updates from a gateway, do not work.

## Links

- [Invoice Ninja self-hosting documentation](https://invoiceninja.github.io/en/self-host-installation/)
- [Invoice Ninja environment variables](https://invoiceninja.github.io/en/env-variables/)
- [Invoice Ninja Docker images and Compose files](https://github.com/invoiceninja/dockerfiles/tree/octane)
- [Invoice Ninja source code](https://github.com/invoiceninja/invoiceninja)
