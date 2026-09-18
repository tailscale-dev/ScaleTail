# Seafile with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Seafile Community Edition](https://www.seafile.com/en/product/seafile_on_premise/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Seafile

[Seafile Community Edition](https://www.seafile.com/en/product/seafile_on_premise/) is an open‑source, self‑hosted file syncing and collaboration platform that lets individuals and small teams store, share, and version their files on their own servers. It provides fast, reliable file synchronization and team collaboration features. Think self-hosted OneDrive or Dropbox.

## Configuration Overview

In this setup, the `tailscale-seafile` service runs Tailscale, which manages secure networking for Seafile. The Seafile service utilizes the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## Notes

- This configuration is intended for small (single digit) groups of users. It omits the SeaDoc, Collabora and Notification servers, and uses Memcached instead of Redis. You would probably want all of those things in a large deployment.
- Keep `SEAFILE_MEMCACHED_IMAGE` on a Debian-based tag. The Memcached health check needs perl, which Alpine tags lack, and Seafile waits for Memcached to be healthy before it starts.
- Additional Docker Compose settings for Seafile can be found here: <https://manual.seafile.com/latest/setup/setup_ce_by_docker/>

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `TS_AUTHKEY`: Paste in an Auth Key for your Tailnet.
- Volumes: Update the locations for the `SEAFILE_VOLUME` and `SEAFILE_MYSQL_VOLUME` in .ENV.
- Passwords: There are three passwords (for MySQL/MariaDB and initial Seafile administrator) which need to be set in .ENV.
- Admin Email: Update `INIT_SEAFILE_ADMIN_EMAIL`. This doesn't have to be a valid email address, although you can configure SMTP notifications in Seafile, which will require a valid email address.
- `JWT_PRIVATE_KEY`: Generate this by running `pwgen -s 40 1` or `openssl rand -base64 40`
- `SEAFILE_SERVER_HOSTNAME`: Update the FQDN to match your Tailnet MagicDNS suffix.

## Troubleshooting

### Seafile cannot connect to the database

Seafile waits for the database before it starts and logs nothing while it waits. The `app-seafile` container stays up, turns `unhealthy`, and the web interface answers `502 Bad Gateway`. Two causes are common.

**`TS_ACCEPT_DNS=true` is enabled.** Seafile shares the network of the Tailscale container and reaches the database and Memcached through the Compose service names `db` and `memcached`. With `TS_ACCEPT_DNS=true`, Tailscale replaces Docker DNS and those names no longer resolve. Check whether the names resolve:

```bash
docker exec app-seafile getent hosts db memcached
```

If the command prints nothing, comment out `TS_ACCEPT_DNS` in `compose.yaml` and run `docker compose up -d`. Seafile does not need MagicDNS, and Tailscale Serve works without this setting.

**The database passwords changed after the first start.** MariaDB applies `INIT_SEAFILE_MYSQL_ROOT_PASSWORD` only when it creates an empty data directory, and Seafile creates its database user with `SEAFILE_MYSQL_DB_PASSWORD` on the first start. Later changes in `.env` do not reach the existing database, so Seafile can no longer log in and `docker logs app-seafile-db` shows `Access denied for user`. Restore the original passwords. On a new installation without data, you can instead stop the stack, delete the `SEAFILE_MYSQL_VOLUME` and `SEAFILE_VOLUME` directories, and start again.
