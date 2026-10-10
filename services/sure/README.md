# Sure

[Sure](https://sure.am) is a personal finance application and a community fork of the archived Maybe Finance project. You track bank accounts, investments, and crypto holdings and follow your net worth, with support for several currencies.

This stack runs Sure with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                      |
| ------------- | ---------------------------------------------------------- |
| Web interface | `https://sure.<tailnet>.ts.net`                            |
| Service port  | `3000`                                                     |
| Images        | `ghcr.io/we-promise/sure:stable`                           |
|               | `postgres:16`                                              |
|               | `redis`                                                    |
|               | `prodrigestivill/postgres-backup-local` (optional backups) |
| Data          | `./app-storage` (uploaded files)                           |
|               | `./postgres-data` (PostgreSQL database)                    |
|               | `./redis-data` (Redis data)                                |
|               | `./backups` (database backups)                             |

## Before you start

1. Create the data folders yourself, so that Docker does not create them as user `root`:

   ```bash
   mkdir -p config ts/state app-storage postgres-data redis-data backups
   ```

2. Set these values in `.env`:

   - **`SECRET_KEY_BASE`.** Required and empty by default. Generate a value with `openssl rand -hex 64`. Compose stops with an error until you set it.
   - **`POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.** The defaults for the user and the database are `sure_user` and `sure_production`. `POSTGRES_PASSWORD` is empty, and Compose stops with an error until you set it.
   - **`DB_HOST`, `REDIS_URL`, and `POSTGRES_HOST`.** Leave these as they are, unless you change the IP addresses of the network that the deviations describe.

## Deviations from the standard setup

- **Several application containers.** The stack has no `application` service. It runs `web` (the web interface), `worker` (background jobs with Sidekiq), `db` (PostgreSQL), `redis`, and the optional `backup`.
- **Two networks.** `web` and `worker` use the network of the `tailscale` container. `db`, `redis`, and `backup` use a separate Docker network, `sure_net`, with fixed IP addresses. The `tailscale` container is attached to that network as well, so that `web` and `worker` can reach the database and Redis.
- **MagicDNS is enabled.** The stack sets `TS_ACCEPT_DNS=true`, so that `web` and `worker` resolve Tailnet names, for example an OpenID Connect provider on your Tailnet such as [Pocket ID](../pocket-id/). The setting replaces Docker's DNS for `web` and `worker`, and they cannot resolve the names `db` and `redis`. `.env` therefore gives them the fixed IP addresses instead (`DB_HOST=172.28.0.10` and `REDIS_URL=redis://172.28.0.11:6379/1`).
- **HTTPS settings.** `.env` sets `RAILS_FORCE_SSL=true` and `RAILS_ASSUME_SSL=true`. Tailscale Serve provides HTTPS and forwards plain HTTP to port `3000`, and `RAILS_ASSUME_SSL` tells Sure that the connection is secure.
- **Data folders.** The data is in `./app-storage`, `./postgres-data`, `./redis-data`, and `./backups`, not in a `./sure-data` folder.

## First run

Open the web interface and select **create your account**. Sure has no default login. The first account that you create is yours.

## Configuration

### Database backups

The `backup` container makes scheduled backups of the database. It only runs when you start the stack with the `backup` profile:

```bash
docker compose --profile backup up -d
```

The backups are in `./backups`. `SCHEDULE`, `BACKUP_KEEP_DAYS`, `BACKUP_KEEP_WEEKS`, and `BACKUP_KEEP_MONTHS` in `.env` set the schedule and how long backups are kept.

### AI features

Sure can use OpenAI for chat and rules. Set `OPENAI_ACCESS_TOKEN` in `.env` to enable it. This causes costs on your OpenAI account, so set a spending limit first. See the [Sure AI documentation](https://github.com/we-promise/sure/blob/main/docs/hosting/ai.md).

### OpenID Connect

Sure can use an OpenID Connect provider for the login, such as Keycloak, Authentik, or [Pocket ID](../pocket-id/). Set `OIDC_ISSUER`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, and `OIDC_REDIRECT_URI` in `.env`. The redirect address has the form `https://sure.<tailnet>.ts.net/auth/openid_connect/callback`. See the [Sure OIDC documentation](https://github.com/we-promise/sure/blob/main/docs/hosting/oidc.md).

### Passkeys

If you use passkeys or security keys as a second factor, set `WEBAUTHN_RP_ID` and `WEBAUTHN_ALLOWED_ORIGINS` before anyone registers a passkey. See the [WebAuthn configuration guide](https://github.com/we-promise/sure/blob/main/docs/hosting/webauthn.md).

## Troubleshooting

### Sync of stock prices or exchange rates fails

If a sync fails with `Failed to open TCP connection to fc.yahoo.com`, DNS probably returns an IPv6 address for Yahoo Finance first, which the container cannot reach. The upstream Compose file forces IPv4 DNS servers for `web` and `worker`. This stack leaves that out, because Tailscale handles their DNS. See the note in the [Sure Docker guide](https://github.com/we-promise/sure/blob/main/docs/hosting/docker.md) for workarounds.

### Redirect loop without HTTPS

If you open Sure over plain HTTP and get redirect errors, set `RAILS_FORCE_SSL` and `RAILS_ASSUME_SSL` in `.env` to `false`.

## Upgrading

Earlier versions of this stack had a sample value for `POSTGRES_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample value, set `POSTGRES_PASSWORD=sure_password` again. The database still uses it.

## Links

- [Sure Docker guide](https://github.com/we-promise/sure/blob/main/docs/hosting/docker.md)
- [Sure website](https://sure.am)
- [Sure source code](https://github.com/we-promise/sure)
