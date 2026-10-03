# Mail Archiver with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Mail Archiver](https://mail-archiver.org/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Mail Archiver

[Mail Archiver](https://mail-archiver.org/) is an open-source, self-hosted email archiver. It collects mail from IMAP accounts, Microsoft 365, and imported files, and offers full-text search across message metadata and content. Pairing it with Tailscale keeps your email archive off the public internet and reachable only from devices on your Tailnet.

## Configuration Overview

In this setup, the `tailscale` service (container `tailscale-mail-archiver`) runs Tailscale, which manages secure networking for Mail Archiver. The `application` service (container `app-mail-archiver`) uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

The `db` service (container `app-mail-archiver-db`) runs PostgreSQL in the same network namespace, so Mail Archiver reaches it at `127.0.0.1`. The database is not exposed outside the stack.

## Prerequisites

The stack needs no extra user groups or devices beyond `/dev/net/tun` for the Tailscale container. Both containers start as root, so Docker can create the `mail-archiver-data` folders on the first start; you do not need to create them beforehand.

## Before the first start

- Set `TS_AUTHKEY`, `APP_PW`, and `DB_PW` in `.env`. The stack does not work with empty passwords.
- Use only letters and digits in `DB_PW`. The password is inserted into the database connection string, so characters such as `;` or `=` break it.
- PostgreSQL applies `DB_USER` and `DB_PW` only when it creates the database on the first start. Changing them later in `.env` does not change the existing database user.
- `APP_USER` and `APP_PW` define the first admin account. Log in with them after the first start.

## Access

Tailscale Serve publishes the web interface over HTTPS at `https://mail-archiver.<your-tailnet>.ts.net`. Serve proxies to Mail Archiver on port `5000`; this port is set in the `ts-serve` config in `compose.yaml` and does not follow `SERVICEPORT`. The first request can take a few seconds while Tailscale issues the certificate.

The commented `ports:` mapping is not needed for Tailnet access. Enable it only if you also want to reach Mail Archiver on port `5000` from your local network.

## OAuth/OIDC login (optional)

To log in through an identity provider, set `OAUTH_SETUP=true` and fill in `OAUTH_URL`, `OAUTH_CLIENTID`, and `OAUTH_SECRET`. Use `https://mail-archiver.<your-tailnet>.ts.net/oidc-signin-completed` as the redirect URI in your provider. `OAUTH_DISPLAYNAME` sets the text on the login button. Password login stays enabled, and new OAuth users need approval by an admin.

## Volumes

- `./mail-archiver-data/db` stores the PostgreSQL database, which holds the archived mail.
- `./mail-archiver-data/data-protection-keys` stores the keys that protect login cookies. Keeping it means users stay logged in when the container is recreated.

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variables `TS_AUTHKEY`, `APP_PW`, `DB_PW`

## Useful links

- [Mail Archiver website](https://mail-archiver.org/)
- [Mail Archiver on GitHub](https://github.com/s1t5/mail-archiver)
- [Mail Archiver documentation](https://github.com/s1t5/mail-archiver/tree/main/doc)
