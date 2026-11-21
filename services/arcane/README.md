# Arcane

[Arcane](https://getarcane.app/) is a web interface to manage Docker containers, images, networks, volumes, and Compose projects.

This stack runs the Arcane manager with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). To manage Docker on other hosts from the same manager, run the [Arcane Agent](../arcane-agent/) stack on each of them.

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://arcane.<tailnet>.ts.net`     |
| Service port  | `3552`                                |
| Image         | `ghcr.io/getarcaneapp/manager`        |
| Data          | `./arcane-data` (application data)    |
|               | `./opt/dockerdata` (Compose projects) |

## Before you start

- **Set your Tailnet name.** Set `TAILNET_NAME` in `.env` to your Tailnet name, without `.ts.net`. `compose.yaml` builds the address of the application, `ARCANE_APP_URL`, from it.
- **Set the encryption key.** Set `ENCRYPTION_KEY` in `.env` to a random value of at least 32 characters. Generate it with `openssl rand -hex 32`. Compose stops with an error while it is empty.

## Deviations from the standard setup

- **Docker socket.** Arcane mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to Arcane has full control over the Docker host.
- **Data folders.** The Compose projects are in `./opt/dockerdata`, outside the `./arcane-data` folder.

## First run

Arcane creates the user `arcane` with a random password at the first start, and writes the password to `./arcane-data/initial-admin-password`. The file belongs to UID `1000`, the `PUID` in `compose.yaml`, and only that user can read it:

```sh
cat ./arcane-data/initial-admin-password
```

Open the web interface and log in with username `arcane` and that password. Arcane asks you to change the password at the first login.

## Upgrading

### Arcane 3

Arcane 3 renamed its image and its settings. Follow the [Arcane migration guide](https://getarcane.app/docs/get-started/migrate-v3) together with these steps:

1. Upgrade to Arcane 2.17.3 first. The previous image of this stack, `ghcr.io/getarcaneapp/arcane`, stays at 2.17.3. Run `docker compose pull` and `docker compose up -d` with the previous files, and wait until the container is healthy.
2. Update `compose.yaml`. It now passes the `ARCANE_` names, such as `ARCANE_APP_URL` and `ARCANE_ENCRYPTION_KEY`. Arcane 3 does not start while an old name such as `APP_URL` is set. If you added your own variables, rename them as the migration guide describes.
3. In your `.env`, set `IMAGE_URL=ghcr.io/getarcaneapp/manager:latest` and delete `JWT_SECRET`, which Arcane 3 no longer uses. Keep `ENCRYPTION_KEY`.
4. Run `docker compose pull` and `docker compose up -d`. Arcane migrates its database at the first start, and your users, settings, and API keys stay.
5. Upgrade every agent to Arcane 3 as well, for example with the [Arcane Agent](../arcane-agent/) stack. The manager and its agents must run the same major version.

### Secrets in `.env`

Earlier versions of this stack had a sample value for `ENCRYPTION_KEY` in `compose.yaml`. It is now empty in `.env`, and you must set it.

- If you replaced the value in `compose.yaml` before, move your value to `.env`.
- If you still used the sample value, set a new one. Arcane cannot decrypt what it encrypted with the previous `ENCRYPTION_KEY`, so keep the previous value if you need that data.

## Links

- [Arcane documentation](https://getarcane.app/docs)
- [Arcane installation](https://getarcane.app/docs/get-started/installation)
- [Arcane source code](https://github.com/getarcaneapp/arcane)
