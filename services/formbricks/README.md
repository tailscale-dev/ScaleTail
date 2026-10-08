# Formbricks

[Formbricks](https://formbricks.com/) is a survey and feedback platform. You build surveys, show them in your website, app, or by link, and analyse the answers on your own server.

This stack runs Formbricks with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                    |
| ------------- | -------------------------------------------------------- |
| Web interface | `https://formbricks.<tailnet>.ts.net`                    |
| Service port  | `3000`                                                   |
| Images        | `ghcr.io/formbricks/formbricks:4.9.7`                    |
|               | `pgvector/pgvector:pg17`                                 |
|               | `valkey/valkey`                                          |
| Data          | `./formbricks-data/postgres` (PostgreSQL database)       |
|               | `./formbricks-data/redis` (Valkey data)                  |
|               | `./formbricks-data/saml-connection` (SAML configuration) |

## Before you start

Set these values in `.env`:

- **`TS_URL`.** The name of the device on your Tailnet, `formbricks.<tailnet>.ts.net`.
- **`WEBAPP_URL`.** The address that you use to open Formbricks. The sample value is `http://${TS_URL}:3000`, which is the direct port on the Tailnet. To use the HTTPS address of Tailscale Serve, change it to `https://${TS_URL}`. `NEXTAUTH_URL` and `PUBLIC_URL` follow this value.
- **`NEXTAUTH_SECRET`, `ENCRYPTION_KEY`, and `CRON_SECRET`.** The sample values are public. Replace each with its own random value from `openssl rand -hex 32`.
- **The `SMTP_*` and `MAIL_FROM` values.** The details of your mail server, if Formbricks should send email. The sample values do not work.

## Deviations from the standard setup

- **Service name.** The application service is called `formbricks`, not `application`.
- **Extra containers.** The stack runs `postgres` and `redis` (Valkey). They use the default Compose network, and Formbricks reaches them by their service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Database password.** The password of the database is `postgres`, set in `compose.yaml` and in `DATABASE_URL` in `.env`. Change both to the same value before the first start.
- **Pinned version.** The stack pins Formbricks to `4.9.7`. Formbricks 5.0 and later also need the Cube, Hub, and SpiceDB services, which this stack does not include. See the [upstream Compose file](https://github.com/formbricks/formbricks/blob/main/docker/docker-compose.yml) before you upgrade.
- **Email verification and password reset are off.** `.env` sets `EMAIL_VERIFICATION_DISABLED="1"` and `PASSWORD_RESET_DISABLED="1"`, so Formbricks works without a mail server.

## First run

The first start takes about three minutes, because Formbricks prepares its database. Then open the web interface at the address from `WEBAPP_URL` and create the first account, which becomes the owner of the organisation.

## Links

- [Formbricks self-hosting documentation](https://formbricks.com/docs/self-hosting/overview)
- [Formbricks source code](https://github.com/formbricks/formbricks)
