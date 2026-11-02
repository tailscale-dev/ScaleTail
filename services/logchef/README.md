# Logchef

[Logchef](https://logchef.app) is a log analytics interface for logs that already live in ClickHouse or VictoriaLogs. It queries them with its own LogchefQL syntax or with SQL, and keeps its teams, sources and saved queries in a local SQLite file.

This stack runs Logchef with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | `https://logchef.<tailnet>.ts.net`     |
| Service port  | `8125`                                 |
| Image         | `ghcr.io/mr-karan/logchef:latest`      |
| Data          | `./logchef-data/app` (SQLite database) |

## Before you start

Logchef reads logs from a ClickHouse or VictoriaLogs instance that you already run. It never stores or copies the logs themselves, so have the address and credentials of that backend ready. Nothing in this stack writes logs for it.

Create the data folder and give it to the user inside the container, which runs as uid 1000:

```sh
mkdir -p logchef-data/app
sudo chown 1000:1000 logchef-data/app
```

The folder is named after `SERVICE`, so use `<SERVICE>-data/app` if you changed it. Create it before the first start. Docker otherwise creates it as root, and the application container then stops with `unable to open database file (14)`.

Set these in `.env`. Compose stops with an error such as `required variable API_TOKEN_SECRET is missing a value` until you do:

- `API_TOKEN_SECRET`: hashes the API tokens. At least 32 characters. Generate it with `openssl rand -hex 32`.
- `ADMIN_EMAIL`: the address you sign in with.
- `ADMIN_PASSWORD`: at least 10 characters. Generate one with `openssl rand -hex 16`.

## Deviations from the standard setup

None.

## First run

Open `https://logchef.<tailnet>.ts.net` and sign in with `ADMIN_EMAIL` and `ADMIN_PASSWORD`. Logchef creates that administrator at every start, so changing the password in `.env` and restarting the stack applies the new one.

Before you can query anything, connect a source and grant yourself access to it:

1. Go to **Sources > Manage Sources**, then **Add Source**. For ClickHouse, give the host as `address:9000`, the native protocol port, together with the database, the table and the timestamp field. For VictoriaLogs, give the base URL, such as `http://address:9428`. Test the connection and save.
2. Go to **Access > Teams**, add a team, and add your own address to it.
3. Assign the source to that team.

The source then appears in the explorer.

## Configuration

**Reaching a backend elsewhere on your Tailnet.** To address ClickHouse by its MagicDNS name, such as `clickhouse.<tailnet>.ts.net:9000`, uncomment `TS_ACCEPT_DNS=true` in `compose.yaml`. This stack has no second container, so losing Docker DNS costs nothing here.

**Share links.** Set the public address under **Administration > System Settings** so that shared queries carry the full `https://logchef.<tailnet>.ts.net` address.

## Troubleshooting

**The login page reloads instead of signing in.** Logchef marks its session cookie as secure, so a browser only keeps it over HTTPS. Use the `https://` Tailnet address. If you publish the LAN port and sign in over plain HTTP, add `LOGCHEF_SERVER__SECURE_COOKIE=false` to the application's `environment`.

**The application container stops with `unable to open database file (14)`.** The data folder does not belong to uid 1000, so Logchef cannot create its SQLite database. Run the `chown` command from "Before you start" and recreate the stack.

**A source stays disconnected.** Logchef still starts when a backend is unreachable and reports it per source. Check that the backend address is reachable from the host, and that ClickHouse uses its native port, `9000`, rather than the HTTP port, `8123`.

## Links

- [Logchef documentation](https://logchef.app)
- [Logchef source code](https://github.com/mr-karan/logchef)
