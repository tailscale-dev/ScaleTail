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

Set `VIKUNJA_SERVICE_PUBLICURL` in `.env` to the address of the web interface with a slash at the end, `https://vikunja.<tailnet>.ts.net/`.

## Deviations from the standard setup

- **Runs as `root`.** The `application` container runs as user and group `0` through the `user` setting, so that Vikunja can write to the data folders that Docker creates.
- **Database.** `VIKUNJA_DATABASE_PATH` in `.env` puts the SQLite database in the mounted `./vikunja-data/db` folder.

## First run

Open the web interface and register the first account.

## Configuration

### Configuration file

This directory contains `config.yml`, a sample configuration file with all settings as comments. To use it, edit the file and uncomment the line that mounts it in the `volumes` block of `compose.yaml`.

## Links

- [Vikunja documentation](https://vikunja.io/docs)
- [Vikunja source code](https://github.com/go-vikunja/vikunja)
