# Arcane

[Arcane](https://getarcane.app/) is a web interface to manage Docker. You manage containers, images, networks, volumes, and Compose projects without the command line.

This stack runs Arcane with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://arcane.<tailnet>.ts.net`     |
| Service port  | `3552`                                |
| Image         | `ghcr.io/getarcaneapp/arcane`         |
| Data          | `./arcane-data` (application data)    |
|               | `./opt/dockerdata` (Compose projects) |

## Before you start

- **Set your Tailnet name.** Set `TAILNET_NAME` in `.env` to your Tailnet name, without `.ts.net`. `compose.yaml` builds the address of the application, `APP_URL`, from it.
- **Set the secrets.** Set `ENCRYPTION_KEY` and `JWT_SECRET` in `.env` to two different random values. Generate each with `openssl rand -base64 32`. Compose stops with an error if one of them is empty.

## Deviations from the standard setup

- **Docker socket.** Arcane mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to Arcane has full control over the Docker host.
- **Data folders.** The Compose projects are in `./opt/dockerdata`, outside the `./arcane-data` folder.

## First run

Open the web interface and log in with username `arcane` and password `arcane-admin`. Arcane creates this account at the first start and asks you to change the password at the first login.

## Upgrading

Earlier versions of this stack had sample values for `ENCRYPTION_KEY` and `JWT_SECRET` in `compose.yaml`. Both are now empty in `.env`, and you must set them.

- If you replaced the values in `compose.yaml` before, move your values to `.env`.
- If you still used the sample values, set new ones. With a new `JWT_SECRET`, everyone has to log in again. Arcane cannot decrypt what it encrypted with the previous `ENCRYPTION_KEY`, so keep the previous value if you need that data.

## Links

- [Arcane documentation](https://getarcane.app/docs)
- [Arcane source code](https://github.com/getarcaneapp/arcane)
