# Mattermost

[Mattermost](https://mattermost.com/) is a collaboration platform for teams, with channels, direct messages, file sharing, and integrations. It is an open-source alternative to Slack.

This stack runs Mattermost with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                                     |
| ------------- | --------------------------------------------------------------------------------------------------------- |
| Web interface | `https://mattermost.<tailnet>.ts.net`                                                                     |
| Service port  | `8065`                                                                                                    |
| Images        | `mattermost/mattermost-team-edition`                                                                      |
|               | `postgres:17-alpine`                                                                                      |
| Data          | `./mattermost-data/config`, `data`, `logs`, `plugins`, `client/plugins`, and `bleve-indexes` (Mattermost) |
|               | `./mattermost-data/postgres/data` (PostgreSQL database)                                                   |

## Before you start

1. Create the Mattermost folders yourself and make user `2000` their owner. Docker creates missing folders as user `root`. The Mattermost image runs as user and group `2000` and then fails with `could not create config file: open /mattermost/config/config.json: permission denied`. Do not change the owner of the `postgres` folder, which PostgreSQL manages itself.

   ```bash
   DATA_DIR=mattermost-data
   mkdir -p "$DATA_DIR"/{config,data,logs,plugins,client/plugins,bleve-indexes}
   sudo chown -R 2000:2000 "$DATA_DIR"/{config,data,logs,plugins,client,bleve-indexes}
   ```

   If you changed `SERVICE` in `.env`, set `DATA_DIR` to `<SERVICE>-data`.

2. Set these values in `.env`:

   - **`DOMAIN`.** The name of the device on your Tailnet, `mattermost.<tailnet>.ts.net`. The stack builds the site address, `MM_SERVICESETTINGS_SITEURL`, from it.
   - **`POSTGRES_USER` and `POSTGRES_PASSWORD`.** The login of the database. `POSTGRES_PASSWORD` is empty, and Compose stops with an error until you set it. Use letters and digits only, because the database address contains it.

## Deviations from the standard setup

- **Extra container.** The stack runs a `database` container with PostgreSQL, named `db-mattermost`. It uses the default Compose network, and Mattermost reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve that name.
- **Data paths in `.env`.** The `*_PATH` variables in `.env` set the data folders. They are relative to this directory.
- **Reduced privileges.** Both containers set `no-new-privileges` and a limit on the number of processes. The database container has a read-only file system.
- **Service port.** Mattermost listens on port `8065`. `SERVICEPORT` in `.env` is only used by the optional `ports` block.

## First run

Open the web interface and create the first account, which becomes the system administrator. Then create your team.

## Upgrading

Earlier versions of this stack had a sample value for `POSTGRES_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample value, set `POSTGRES_PASSWORD=MMus3r_P4ssword` again. The database still uses it.

## Links

- [Mattermost documentation](https://docs.mattermost.com/)
- [Mattermost Docker deployment](https://docs.mattermost.com/deployment-guide/server/deploy-containers.html)
- [Mattermost source code](https://github.com/mattermost/mattermost)
