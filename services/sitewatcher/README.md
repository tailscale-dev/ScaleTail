# SiteWatcher

[SiteWatcher](https://github.com/NikKurkov/sitewatcher) keeps a history of the uptime and response times of your websites, and warns you before their HTTPS certificates and domain registrations expire.

This stack runs SiteWatcher with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). SiteWatcher has no built-in Tailscale support and its image contains no Tailscale client, so the sidecar publishes the web interface over HTTPS with Tailscale Serve.

## At a glance

| Item          | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| Web interface | `https://sitewatcher.<tailnet>.ts.net`                      |
| Service port  | `8080`                                                      |
| Image         | `ghcr.io/nikkurkov/sitewatcher`                             |
| Data          | `./sitewatcher-data/` (SQLite database, web secret, cache) |

## Before you start

1. Create the data folder yourself and make user `10001` its owner. Docker creates missing folders as user `root`, and the image runs as user and group `10001`. With the wrong owner, SiteWatcher cannot create its database.

   ```bash
   mkdir -p ./sitewatcher-data
   sudo chown -R 10001:10001 ./sitewatcher-data
   ```

2. Set **`TAILNET_NAME`** in `.env` to your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the allowed host name `<SERVICE>.<TAILNET_NAME>.ts.net` from it. Compose stops with an error until you set it.

## Deviations from the standard setup

- **Worker container.** Besides the `application` container, which runs the web interface, the stack runs a `worker` container (`app-sitewatcher-worker`). The worker runs the scheduled checks and the history cleanup, and it sends the alerts. Both containers use the same image and the same `./sitewatcher-data` folder, and the worker uses the network of the `tailscale` container as well. As in the upstream Compose file, the worker starts after the web interface is healthy. Its health check looks for the worker process.
- **Image tag.** Upstream publishes no version tag and no `latest` tag. Each image tag is named after the commit it was built from, so `.env` sets one of those tags. See [Update SiteWatcher](#update-sitewatcher).
- **Allowed host names.** `SITEWATCHER_WEB_ALLOWED_HOSTS` in `compose.yaml` lists `127.0.0.1`, `localhost`, and the Tailnet address of the service. SiteWatcher rejects requests for any other name and does not accept wildcards.
- **HTTPS settings.** Tailscale Serve provides HTTPS and forwards plain HTTP to port `8080`. `SITEWATCHER_WEB_HTTPS=1` marks the session and CSRF cookies as secure, and `SITEWATCHER_WEB_TRUST_PROXY=1` lets SiteWatcher read the `X-Forwarded-Proto` header that Serve sends. Without it, signing in fails with `403 Forbidden`. Upstream turns both off, for plain HTTP on the local computer.
- **Loopback only.** The web interface listens on `127.0.0.1:8080`, so port `8080` is not reachable at the Tailscale IP address of the device, and the optional `ports` block gives no access from your local network. Upstream listens on all addresses inside the container and publishes the port on the loopback address of the host. Use the Tailnet address instead.
- **Data folder.** Upstream uses the named volume `sitewatcher-data`. The stack uses the folder `./sitewatcher-data` instead, which must belong to user `10001`.
- **No setup or bot container.** Upstream defines a `setup` container for the first account and an optional `bot` container that answers Telegram commands. The stack runs the setup command in the `application` container instead, as described under [First run](#first-run), and leaves the bot out. The worker still sends Telegram alerts when you set up Telegram in the web interface.

## First run

1. Start the stack, then create the owner account:

   ```bash
   docker compose exec application sitewatcher setup
   ```

   The command asks for a username and a password of at least 8 characters. Run it only once: on an existing installation it stops with `An owner is already configured; use sitewatcher password`.

2. Open `https://sitewatcher.<tailnet>.ts.net`, sign in, and select **Add domain** (the **+** icon at the top). The worker then checks the site at the interval that you set for it, every 5 minutes by default.

## Configuration

- **Alerts.** SiteWatcher sends alerts by email, Telegram, or both. Set them up in **Settings**, as the [user guide](https://github.com/NikKurkov/sitewatcher/blob/main/docs/usage.en.md#telegram) describes.
- **Forgotten password.** Run `docker compose exec application sitewatcher password`. It sets a new password and ends all sessions, and it keeps the monitoring data.
- **Backups.** Stop the stack before you copy `./sitewatcher-data`, so that the database and its `sitewatcher.db-wal` file match. The files belong to user `10001`, and some can only be read by that user, so copy them with `sudo cp -a`. Keep `sitewatcher.db.web-secret` and the other `sitewatcher.db.*` files with the copy, because they hold the web secret and the saved credentials. The [operations guide](https://github.com/NikKurkov/sitewatcher/blob/main/docs/operations.md#back-up-and-restore) shows how to back up while SiteWatcher runs.

### Update SiteWatcher

1. Make a backup, as described above.
2. Pick a newer tag from the [package page](https://github.com/NikKurkov/sitewatcher/pkgs/container/sitewatcher) and set it in `IMAGE_URL` in `.env`.
3. Run `docker compose pull` and `docker compose up -d`.

Do not run `sitewatcher setup` again after an update. Sign in and check that an existing site and its history are still there.

## Troubleshooting

- **`Cannot start local dashboard; check database permissions and --port`.** The `application` container keeps restarting with this message, because `./sitewatcher-data` does not belong to user `10001`. Stop the stack, run the `chown` command from [Before you start](#before-you-start), and start the stack again.
- **`Bad Request (400)` when you open the web interface.** The address does not match the allowed host name. Use `https://<SERVICE>.<TAILNET_NAME>.ts.net`, and check `TAILNET_NAME` in `.env`. After you change it, run `docker compose up -d`.

## Links

- [SiteWatcher user guide](https://github.com/NikKurkov/sitewatcher/blob/main/docs/usage.en.md)
- [SiteWatcher operations guide](https://github.com/NikKurkov/sitewatcher/blob/main/docs/operations.md)
- [SiteWatcher Compose file](https://github.com/NikKurkov/sitewatcher/blob/main/compose.yaml)
- [SiteWatcher source code](https://github.com/NikKurkov/sitewatcher)
- [SiteWatcher container image](https://github.com/NikKurkov/sitewatcher/pkgs/container/sitewatcher)
