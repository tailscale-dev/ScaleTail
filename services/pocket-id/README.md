# Pocket ID

[Pocket ID](https://pocket-id.org/) is a simple OpenID Connect (OIDC) provider. Users sign in to your services with passkeys instead of passwords, which gives the services on your Tailnet a single sign-on.

This stack runs Pocket ID with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://pocket-id.<tailnet>.ts.net` |
| Service port  | `1411`                               |
| Image         | `ghcr.io/pocket-id/pocket-id:v2`     |
| Data          | `./pocket-id-data`                   |

## Before you start

- **Enable HTTPS certificates.** HTTPS certificates must be [enabled for your Tailnet](https://console.tailscale.com/admin/dns) (**DNS** > **HTTPS Certificates**). Passkeys only work over HTTPS.
- **Set `APP_URL` in `.env`.** Use the address of the web interface, `https://pocket-id.<tailnet>.ts.net`. Pocket ID uses it for its OIDC issuer, its endpoints, and passkeys, and it does not start with the sample value.
- **Set `ENCRYPTION_KEY` in `.env`.** Generate the key with `openssl rand -base64 32`. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **The container reads the whole `.env` file.** The `application` container loads `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in its environment.
- **Trusted proxy.** `TRUST_PROXY=true` in `.env` makes Pocket ID accept the client address that Tailscale Serve forwards.
- **User and group.** `PUID` and `PGID` come from `.env`.

## First run

Open `https://pocket-id.<tailnet>.ts.net/setup` to create the administrator account and its first passkey.

## Configuration

- **`APP_URL` must match `SERVICE`.** Tailscale Serve publishes Pocket ID on the device name, which comes from `SERVICE`. `APP_URL` does not change that address. When the two differ, Pocket ID answers on the `SERVICE` name while it sends clients to an address that does not exist, and passkey sign-in fails.
- **Use another name.** To serve Pocket ID at, for example, `https://id.<tailnet>.ts.net`, set `SERVICE=id` and set `APP_URL` to that address. Choose the name before users register passkeys, because a passkey is bound to the host name in `APP_URL`.
- **Rename an existing deployment.** The data folder is `./<SERVICE>-data`, so a new `SERVICE` value starts Pocket ID with an empty folder. Run `docker compose down`, change `SERVICE` and `APP_URL`, rename the folder (for example `mv pocket-id-data id-data`), and run `docker compose up -d`. Tailscale renames the existing device from the stored state, so you need no new auth key. A device that you renamed by hand in the admin console keeps that name.
- **Custom domains.** Tailscale Serve only serves the `ts.net` name of the device. A custom domain in `APP_URL` needs your own DNS and reverse proxy, which this stack does not include.
- **Local network access.** The `ports` block stays commented out. If you enable it, the stack publishes plain HTTP on the Docker host, where passkeys do not work.

## Upgrading

Earlier versions of this stack had an empty `ENCRYPTION_KEY` in `.env`, and Compose started the stack without an error. Pocket ID then stopped at start. Compose now stops with an error until you set `ENCRYPTION_KEY`. If you already run the stack with a key, keep the value that you use now, because Pocket ID encrypts its stored data with it. If you use `ENCRYPTION_KEY_FILE`, set `ENCRYPTION_KEY` as well, because Compose still requires it.

## Links

- [Pocket ID installation](https://pocket-id.org/docs/setup/installation)
- [Pocket ID environment variables](https://pocket-id.org/docs/configuration/environment-variables)
- [Pocket ID source code](https://github.com/pocket-id/pocket-id)
