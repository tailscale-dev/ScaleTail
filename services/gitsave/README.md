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

- **`JWT_SECRET`.** A long random value. Generate one with `openssl rand -hex 32`.
- **`ENCRYPTION_SECRET`.** A random value of exactly 32 characters, for example from `openssl rand -hex 16`. Compose stops with an error if `JWT_SECRET` or `ENCRYPTION_SECRET` is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface and create the first account.

## Upgrading

Earlier versions of this stack had sample values for `JWT_SECRET` and `ENCRYPTION_SECRET` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now.

## Links

- [GitSave documentation and source code](https://github.com/TimWitzdam/GitSave)
