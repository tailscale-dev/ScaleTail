# Outline

[Outline](https://www.getoutline.com/) is a team wiki and knowledge base with real-time collaborative editing.

Outline has no built-in Tailscale support, so this stack runs it with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                              |
| ------------- | -------------------------------------------------- |
| Web interface | `https://outline.<tailnet>.ts.net`                 |
| API           | `https://outline.<tailnet>.ts.net/api`             |
| Service port  | `3000`                                             |
| Images        | `docker.getoutline.com/outlinewiki/outline:latest` |
|               | `postgres:18`                                      |
|               | `redis:8-alpine`                                   |
| Data          | `./outline-data/data` (attachments and images)     |
|               | `./outline-data/postgres` (PostgreSQL database)    |
|               | `./outline-data/redis` (Redis data)                |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it, as `URL`.
- **`SECRET_KEY`.** Encrypts stored data and signs logins. Generate one with `openssl rand -hex 32`, which gives the 64 hexadecimal characters that Outline requires. Do not change it later, or users can no longer log in.
- **`UTILS_SECRET`.** Protects the internal endpoint that runs scheduled tasks. Generate one with `openssl rand -hex 32`.
- **`POSTGRES_PASSWORD`.** The password of the database. Generate one with `openssl rand -hex 32`. Use letters and digits only, because the value is part of the database address. PostgreSQL applies it only when it first creates the database.

Create the attachments folder before the first start, and give it to the user that runs Outline inside the container, `nodejs` with the ID `1001`. Docker would otherwise create it as `root`, and every upload would fail:

```sh
mkdir -p outline-data/data
sudo chown 1001:1001 outline-data/data
```

## Deviations from the standard setup

- **Extra containers.** Outline needs PostgreSQL and Redis, so the stack runs `postgres` (`app-outline-db`) and `redis` (`app-outline-redis`), as in the [upstream Compose file](https://docs.getoutline.com/s/hosting/doc/docker-7pfeLP5a8t). Both use the default Compose network, not the network of the `tailscale` container, so your Tailnet cannot reach them. Outline finds them by their Compose service names, so keep `TS_ACCEPT_DNS` disabled.
- **Settings.** `compose.yaml` passes the settings of Outline to the application. The upstream Compose file reads a whole `docker.env` file instead.
- **Public address.** `URL` is built from `SERVICE` and `TAILNET_NAME`, so keep both in line with the name of the Tailnet device. Outline uses it for links, such as those in emails, and for the live connection of the editor.
- **No LAN access.** Outline redirects plain HTTP requests to HTTPS and builds its links from `URL`, so the optional `ports` block does not give a working LAN address. Use the Tailnet address.
- **Database without TLS.** Outline connects to PostgreSQL over TLS by default. `PGSSLMODE=disable` turns that off, because the database runs in this stack and has no certificate.
- **Local file storage.** `FILE_STORAGE=local` keeps attachments in `./outline-data/data`. Outline uses S3 by default.
- **Redis data.** The stack keeps the Redis data in `./outline-data/redis`. The upstream Compose file keeps none.
- **No usage statistics.** By default, Outline sends a daily report to `updates.getoutline.com` with its version and the number of users, workspaces, collections, and documents. `ENABLE_UPDATES=false` turns that off. Outline then also stops showing the notices about important updates that this service returns.

## First run

1. Open the web interface right after the first start. Outline shows the **Create workspace** form. Anyone on your Tailnet who opens Outline before you can create the workspace and become its admin.
2. Enter the workspace name, your name, and your email address, and select **Continue**. Outline creates the workspace, makes you its admin, and signs you in.
3. Add a passkey straight away, under **Settings** > **Passkeys** > **Add passkey**. Outline has no passwords. Without a passkey, [email](#configuration), or single sign-on, you cannot sign in again after you sign out or on another device.

## Configuration

- **Email.** Outline sends invites and notifications by email, and offers sign-in with a link sent by email. Set `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, and `SMTP_FROM_EMAIL` in `.env`, and run `docker compose up -d`. `SMTP_SECURE=false` uses STARTTLS when the server offers it, usually on port `587`. `SMTP_SECURE=true` uses TLS from the start, usually on port `465`. Users that you invite need email or single sign-on for their first sign-in, because they can add a passkey only once they are signed in.
- **Single sign-on.** Outline can also sign users in through Google, Microsoft Entra ID, Slack, Discord, or an OpenID Connect provider. Add the variables of the provider, listed in the [authentication documentation](https://docs.getoutline.com/s/hosting/doc/authentication-7ViKRmRY5o), to the `environment` of the `application` service in a `compose.override.yaml`, as in [Keep your changes in an override file](../../README.md#keep-your-changes-in-an-override-file).
- **Changing the address.** A passkey works only for the address where you added it. Before you change `SERVICE` or `TAILNET_NAME`, set up email or single sign-on. Then add a new passkey at the new address.

## Links

- [Outline self-hosting documentation](https://docs.getoutline.com/s/hosting)
- [Outline Docker installation](https://docs.getoutline.com/s/hosting/doc/docker-7pfeLP5a8t)
- [Outline settings (`.env.sample`)](https://github.com/outline/outline/blob/main/.env.sample)
- [Outline source code](https://github.com/outline/outline)
