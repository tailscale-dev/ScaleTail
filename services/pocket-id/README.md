# Pocket ID with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Pocket ID](https://pocket-id.org/) with Tailscale as a sidecar container, enabling secure access to your self-hosted identity provider over a private Tailscale network. With this setup, your Pocket ID instance remains private and accessible only from devices on your Tailnet, over HTTPS.

## Pocket ID

[Pocket ID](https://github.com/pocket-id/pocket-id) is a simple, self-hosted OpenID Connect (OIDC) provider that lets users sign in to your services with passkeys instead of passwords. It is a lightweight alternative to larger identity providers such as Keycloak, and gives the other services on your Tailnet a single sign-on.

## Key Features

- **Passkey-Only Sign-In** – Users authenticate with passkeys; there are no passwords to manage.
- **OIDC Provider** – Add single sign-on to any application that supports OpenID Connect.
- **Security Key Support** – Physical security keys, such as a YubiKey, work as passkeys.
- **Simple to Run** – One container and a SQLite database by default.
- **Self-Hosted** – Users, clients, and signing keys stay on your own hardware.
- **Private by Default with Tailscale** – No public exposure, no reverse proxies or port forwarding, and HTTPS handled by Tailscale Serve.

## Configuration Overview

In this setup, the `tailscale` service (container `tailscale-pocket-id`) runs Tailscale and joins your Tailnet as the host `pocket-id`. The `application` service (container `app-pocket-id`) uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. Tailscale Serve terminates HTTPS on port 443 and proxies to Pocket ID on `127.0.0.1:1411` inside that shared namespace. This keeps the app Tailnet-only unless you intentionally expose ports.

## Prerequisites

- HTTPS certificates [enabled for your Tailnet](https://console.tailscale.com/admin/dns) (**DNS → HTTPS Certificates**). Pocket ID requires a secure context, so passkeys do not work without HTTPS.

## Files to check

Please verify the following files and variables before deploying:

- `.env` — set `TS_AUTHKEY`, `APP_URL`, and `ENCRYPTION_KEY`. Generate the key with `openssl rand -base64 32`.
- `compose.yaml` — confirm the volume paths and the `Proxy` port in the `ts-serve` config.

## Usage Notes

- **`APP_URL` must match `SERVICE`.** Tailscale Serve publishes Pocket ID on the machine name, which comes from `SERVICE`, so the app is reached at `https://<SERVICE>.<YOUR-TAILSCALE-DOMAIN>.ts.net`. `APP_URL` does not change that address. It only tells Pocket ID which URL to use for its OIDC issuer, its endpoints, and passkeys. When the two differ, the app answers on the `SERVICE` name while clients are sent to an address that does not exist, and passkey sign-in fails.
- **Using another name.** To serve Pocket ID at, for example, `https://id.<YOUR-TAILSCALE-DOMAIN>.ts.net`, set `SERVICE=id` and set `APP_URL` to that URL. Choose the name before users register passkeys, because passkeys are bound to the hostname in `APP_URL`.
- **Renaming an existing deployment.** The data folder is `./${SERVICE}-data`, so a new `SERVICE` value starts Pocket ID with an empty folder. Run `docker compose down`, change `SERVICE` and `APP_URL`, rename the folder (for example `mv pocket-id-data id-data`), and run `docker compose up -d`. Tailscale renames the existing machine from the stored state, so no new auth key is needed. A machine that you renamed by hand in the admin console keeps that name.
- **Custom domains.** Tailscale Serve only serves the machine's `ts.net` name. A custom domain in `APP_URL` needs your own DNS and reverse proxy, which this stack does not include.
- **First run.** Open `https://pocket-id.<YOUR-TAILSCALE-DOMAIN>.ts.net/setup` to create the admin account and its first passkey.
- **Health check.** The image defines its own health check (`/app/pocket-id healthcheck`), so `compose.yaml` does not override it.
- **Ports.** The `ports` block stays commented out; the Tailnet is the only way in. Uncommenting it publishes plain HTTP on the host, where passkeys do not work.

## References

- [Pocket ID website](https://pocket-id.org/)
- [Pocket ID on GitHub](https://github.com/pocket-id/pocket-id)
- [Pocket ID installation](https://pocket-id.org/docs/setup/installation)
- [Pocket ID environment variables](https://pocket-id.org/docs/configuration/environment-variables)
- [Tailscale Serve documentation](https://tailscale.com/kb/1242/tailscale-serve)
- [Tailscale auth keys](https://tailscale.com/kb/1085/auth-keys)
