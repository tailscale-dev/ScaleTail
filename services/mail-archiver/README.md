# MAIL ARCHIVER

[Mail Archiver](https://mail-archiver.org/) is an open-source, self-hosted email archiver. It collects mail from IMAP accounts, Microsoft 365, and imported files, and offers full-text search across message metadata and content. Pairing it with Tailscale keeps your email archive off the public internet and reachable only from devices on your Tailnet.

This stack runs Mail Archiver with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://mail-archiver.<tailnet>.ts.net` |
| Service port  | `5000`                               |
| Image         | `s1t5/mailarchiver:latest`<br>`postgres:17-alpine`                            |
| Data          | `./mail-archiver-data/`                  |

## Before you start

Go through the [Quick Start](../../README.md#quick-start).

In addition:

- Set `TS_AUTHKEY`, `APP_PW`, and `DB_PW` in `.env`. Only APP_PW and DB_PW are required and Compose stops with an error until they are set. TS_AUTHKEY is only needed for the first start.
- Use only letters and digits in `DB_PW`. The password is inserted into the database connection string, so characters such as `;` or `=` break it.
- PostgreSQL applies `DB_USER` and `DB_PW` only when it creates the database on the first start. Changing them later in `.env` does not change the existing database user.
- `APP_USER` and `APP_PW` define the first admin account. Log in with them after the first start.

## Deviations from the standard setup

The stack adds a `db` service (`app-mail-archiver-db`) running PostgreSQL. Mail Archiver keeps its data in a database, so it cannot run as a single container. The database listens on localhost only, at `127.0.0.1`. The database is not exposed outside the stack.

## First run

The first run can take a few seconds while Tailscale issues the certificate. Open the web interface and log in with the initial credentials, a password change will be forced for added security.

## Links

- [Mail Archiver documentation](https://github.com/s1t5/mail-archiver/blob/main/doc/index.md)
- [Mail Archiver source code](https://github.com/s1t5/mail-archiver/)
