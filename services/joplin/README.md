# Joplin Server

[Joplin Server](https://joplinapp.org/) is the sync server for the Joplin note-taking apps. Your notes, notebooks, and attachments stay in sync between your devices without a cloud service.

This stack runs Joplin Server with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://joplin.<tailnet>.ts.net`           |
| Service port  | `22300`                                     |
| Images        | `joplin/server`                             |
|               | `postgres:16`                               |
| Data          | `./joplin-data/db` (PostgreSQL database)    |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the base address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it.
- **`POSTGRES_PASSWORD`.** The password of the database. Generate one with `openssl rand -hex 32`. PostgreSQL applies it only when it first creates the database.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with PostgreSQL. It uses the network of the `tailscale` container as well, so Joplin Server reaches it at `localhost`. PostgreSQL listens only on the loopback address of the device, so other devices on your Tailnet cannot reach it. Joplin Server keeps all notes and attachments in this database, so the stack has no other data folder.
- **Base address.** `APP_BASE_URL` in `compose.yaml` is the Tailnet address of the service. Joplin Server answers only requests for that address, and it uses the address in its links and redirects. If you change `SERVICE` or `TAILNET_NAME`, the address changes with them. For the same reason the optional `ports` block does not give access from your local network: a request to the address of the Docker host gets the error `Invalid origin`.

## First run

Open the web interface and log in with the default administrator account, `admin@localhost` with the password `admin`. Use the Profile button in the upper right to change the administrator password right away: until you do, anyone on your Tailnet can log in as administrator.

Joplin recommends a separate user for syncing. Open the Users page and create one.

To sync a Joplin app, open its synchronisation settings and choose Joplin Server as the synchronisation target. Enter `https://joplin.<tailnet>.ts.net` as the URL, and the email address and password of your user. The device must be connected to your Tailnet.

## Troubleshooting

- **`db: Could not connect ... host.docker.internal` in the logs.** `POSTGRES_HOST` is set to `localhost` or `127.0.0.1`. Joplin Server in Docker replaces those values with `host.docker.internal`, which does not exist in this stack. Remove the variable from `compose.yaml`, so that Joplin Server connects to `localhost`.
- **`Invalid origin` when you open the service.** You used an address other than `APP_BASE_URL`, such as the IP address of the Docker host. Use `https://<SERVICE>.<TAILNET_NAME>.ts.net`.

## Links

- [Joplin Server installation guide](https://github.com/laurent22/joplin/blob/dev/packages/server/README.md)
- [Joplin synchronisation documentation](https://joplinapp.org/help/apps/sync/)
- [Joplin source code](https://github.com/laurent22/joplin)
