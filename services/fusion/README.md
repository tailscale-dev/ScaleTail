# Fusion

[Fusion](https://github.com/0x2E/fusion) is a lightweight feed reader for RSS, Atom, and JSON feeds, with a Fever API for apps such as Reeder and Unread.

This stack runs Fusion with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://fusion.<tailnet>.ts.net`  |
| Service port  | `8080`                             |
| Image         | `ghcr.io/0x2e/fusion`              |
| Data          | `./fusion-data/` (SQLite database) |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the allowed browser origin `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it.
- **`FUSION_PASSWORD`.** The password of the web interface. Generate one with `openssl rand -hex 32`. Fusion reads it at every start and never stores it, so you change the password by changing this value and running `docker compose up -d --force-recreate`. That also ends every open session, because Fusion keeps sessions in memory.

## Deviations from the standard setup

- **Allowed browser origin.** `FUSION_CORS_ALLOWED_ORIGINS` in `compose.yaml` holds the Tailnet address of the service, built from `SERVICE` and `TAILNET_NAME`. Fusion answers `403 Forbidden` to any request that carries another `Origin` header, so a browser can only use the service at that address. An empty value would accept every origin instead. For the same reason the optional `ports` block alone does not give access from your local network: the login request from a page on the address of the Docker host is rejected. To use that address as well, add it to the comma-separated list.

## First run

Open the web interface and log in with the password from `FUSION_PASSWORD`. Fusion has no user accounts, so the login form asks for the password only. A session lasts 30 days.

Add your first feed with the Add button. Fusion discovers the feed of a site when you give it the address of the page itself, and it pulls every feed every 30 minutes.

## Configuration

- **Single sign-on.** Fusion can add a login through an OIDC provider. Set `FUSION_OIDC_ISSUER`, `FUSION_OIDC_CLIENT_ID`, and `FUSION_OIDC_CLIENT_SECRET` in `.env`, then uncomment the four `FUSION_OIDC` lines in `compose.yaml`. Register `https://fusion.<tailnet>.ts.net/api/oidc/callback` as the redirect URI with your provider, because it must match the value that `compose.yaml` sends. Your provider must be reachable from the Fusion container, and from the browser you log in with. The password login stays available next to it, and `FUSION_PASSWORD` stays required: Fusion refuses to start with an empty password unless you also set `FUSION_ALLOW_EMPTY_PASSWORD=true`.
- **Fever API clients.** Reeder, Unread, and other Fever clients use `https://fusion.<tailnet>.ts.net` as the server address, with the account type Fever, the username `fusion`, and your password. A client that asks for the endpoint itself takes `https://fusion.<tailnet>.ts.net/fever`. The device must be connected to your Tailnet. Fusion derives the Fever API key from the username and `FUSION_PASSWORD`, so a new password also means a new key in every client.
- **Feed pulling.** `FUSION_PULL_INTERVAL`, `FUSION_PULL_TIMEOUT`, and `FUSION_PULL_CONCURRENCY` change how often and how fast Fusion pulls feeds. The [variable reference](https://github.com/0x2E/fusion/blob/main/.env.example) lists the defaults.

## Links

- [Fusion documentation and source code](https://github.com/0x2E/fusion)
- [Fever API guide](https://github.com/0x2E/fusion/blob/main/docs/fever-api.md)
