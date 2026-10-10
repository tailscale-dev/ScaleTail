# Vikunja

[Vikunja](https://vikunja.io) is a to-do and project management application. It has lists, boards, Gantt charts, labels, reminders, and recurring tasks, and you can share projects with others.

This stack runs Vikunja with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://vikunja.<tailnet>.ts.net`    |
| Service port  | `3456`                                |
| Image         | `vikunja/vikunja`                     |
| Data          | `./vikunja-data/files` (attachments)  |
|               | `./vikunja-data/db` (SQLite database) |

## Before you start

Set these values in `.env`:

- **`VIKUNJA_SERVICE_PUBLICURL`.** The address of the web interface with a slash at the end, `https://vikunja.<tailnet>.ts.net/`.
- **`VIKUNJA_SERVICE_SECRET`.** A long random value that signs the login tokens. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **Runs as `root`.** The `application` container runs as user and group `0` through the `user` setting, so that Vikunja can write to the data folders that Docker creates.
- **Database.** `VIKUNJA_DATABASE_PATH` in `.env` puts the SQLite database in the mounted `./vikunja-data/db` folder.

## First run

Open the web interface and register the first account.

## Configuration

### Configuration file

This directory contains `config.yml`, a sample configuration file with all settings as comments. To use it, edit the file and uncomment the line that mounts it in the `volumes` block of `compose.yaml`.

## Upgrading

Earlier versions of this stack did not set `VIKUNJA_SERVICE_SECRET`, so Vikunja generated a new secret at every start. The stack now requires the secret in `.env`, and Compose stops with an error until you set it. Add a value with `openssl rand -hex 32`. The secret is fixed from now on, so a login stays valid across restarts. Link shares and clients that hold only a JWT stop working after the change, so they must log in again.

## Links

- [Vikunja documentation](https://vikunja.io/docs)
- [Vikunja source code](https://github.com/go-vikunja/vikunja)
