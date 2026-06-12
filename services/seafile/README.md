# Seafile with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Seafile Community Edition](https://www.seafile.com/en/product/seafile_on_premise/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Seafile

[Seafile Community Edition](https://www.seafile.com/en/product/seafile_on_premise/) is an open‑source, self‑hosted file syncing and collaboration platform that lets individuals and small teams store, share, and version their files on their own servers. It provides fast, reliable file synchronization and team collaboration features. Think self-hosted OneDrive or Dropbox.

## Configuration Overview

In this setup, the `tailscale-seafile` service runs Tailscale, which manages secure networking for Seafile. The Seafile service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## Notes

- This configuration is intended for small (single digit) groups of users. It omits the SeaDoc, Collabora and Notification servers, and uses Memcached instead of Redis. You would probably want all of those things in a large deployment.
- Additional Docker Compose settings for Seafile can be found here: <https://manual.seafile.com/latest/setup/setup_ce_by_docker/>

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `TS_AUTHKEY`: Paste in an Auth Key for your Tailnet.
- Volumes: Update the locations for the `SEAFILE_VOLUME` and `SEAFILE_MYSQL_VOLUME` in .ENV.
- Passwords: There are three passwords (for MySQL/MariaDB and intial Seafile administrator) which need to be set in .ENV.
- Admin Email: Update `INIT_SEAFILE_ADMIN_EMAIL`. This doesn't have to be a valid email address, although you can configure SMTP notifications in Seafile, which will require a valid email address.
- `JWT_PRIVATE_KEY`: Generate this by running `pwgen -s 40 1` or `openssl rand -base64 40`
- `SEAFILE_SERVER_HOSTNAME`: Update the FQDN to match your Tailnet MagicDNS suffix.
