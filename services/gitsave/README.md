# GitSave

[GitSave](https://github.com/TimWitzdam/GitSave) backs up your Git repositories on a schedule. You add the repositories in a web interface and GitSave keeps copies of them on your server.

This stack runs GitSave with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                   |
| ------------- | ------------------------------------------------------- |
| Web interface | `https://gitsave.<tailnet>.ts.net`                      |
| Service port  | `3000`                                                  |
| Image         | `timwitzdam/gitsave`                                    |
| Data          | `./gitsave-data/gitsave` (database)                     |
|               | `./gitsave-data/backups` (backups of your repositories) |

## Before you start

Replace these values in `.env`:

- **`JWT_SECRET`.** A long random value.
- **`ENCRYPTION_SECRET`.** A random value of exactly 32 characters, for example from `openssl rand -hex 16`. GitSave does not start with the sample value and reports `ENCRYPTION_SECRET must be 32 bytes`.

## Deviations from the standard setup

None.

## First run

Open the web interface and create the first account.

## Links

- [GitSave documentation and source code](https://github.com/TimWitzdam/GitSave)
