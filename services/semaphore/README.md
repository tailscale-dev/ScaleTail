# Semaphore UI

[Semaphore UI](https://semaphoreui.com/) is a web interface to run Ansible playbooks, Terraform and OpenTofu, and shell scripts, by hand or on a schedule, with a history of every run.

This stack runs Semaphore UI with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                           |
| ------------- | --------------------------------------------------------------- |
| Web interface | `https://semaphore.<tailnet>.ts.net`                            |
| Service port  | `3000`                                                          |
| Image         | `semaphoreui/semaphore:latest`                                  |
| Data          | `./semaphore-data/config/` (`config.json`)                      |
|               | `./semaphore-data/data/` (SQLite database)                      |

## Before you start

1. Create the data folders yourself and make user `1001` their owner. Docker creates missing folders as user `root`. Semaphore runs as user `1001` and stops with `panic: open /etc/semaphore/config.json: permission denied` when it cannot write to them.

   ```bash
   mkdir -p semaphore-data/config semaphore-data/data
   sudo chown 1001:0 semaphore-data/config semaphore-data/data
   ```

2. Set these values in `.env`. Compose stops with an error until both are set.
   - `SEMAPHORE_ADMIN_PASSWORD`: the password of the admin account. Generate one with `openssl rand -hex 24`.
   - `SEMAPHORE_ACCESS_KEY_ENCRYPTION`: the key that encrypts the SSH keys and passwords that Semaphore stores. Generate it with `head -c32 /dev/urandom | base64`. Keep it, together with a backup of `./semaphore-data`, and do not change it later, or Semaphore can no longer read the secrets it stored.
3. Optionally, change `SEMAPHORE_ADMIN`, `SEMAPHORE_ADMIN_NAME`, and `SEMAPHORE_ADMIN_EMAIL`. Semaphore creates the admin account only at the first start, so later changes to these values and to the password in `.env` have no effect. Change the account in the web interface instead.

## Deviations from the standard setup

None.

## First run

1. Open the web interface and sign in with the admin account from `.env`.
2. Create a project, then add a key store entry, a repository, an inventory, an environment, and a task template. See the [Semaphore UI documentation](https://docs.semaphoreui.com/).

## Configuration

- **Your hosts.** Semaphore reaches other Tailnet devices by their Tailscale IP address, which you put in the inventory. To use MagicDNS names instead, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns). Your Tailnet policy must allow SSH from this device.
- **Database.** Upstream's Compose example runs a MySQL container. This stack sets `SEMAPHORE_DB_DIALECT=sqlite`, which Semaphore supports since version 2.16, so it needs no database container.
- **Other settings.** Semaphore reads more settings from `./semaphore-data/config/config.json` and from environment variables. See [Configuration](https://docs.semaphoreui.com/administration-guide/configuration/).

## Links

- [Semaphore UI documentation](https://docs.semaphoreui.com/)
- [Semaphore UI Docker instructions](https://docs.semaphoreui.com/administration-guide/installation/docker/)
- [Semaphore UI source code](https://github.com/semaphoreui/semaphore)
