# Clean Slate

[Clean Slate](https://github.com/successible/cleanslate) is a calorie tracker that logs food, recipes, and exercise without judgment. It works in any browser and signs you in with a long personal token instead of a username and password.

This stack runs Clean Slate with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://cleanslate.<tailnet>.ts.net`                         |
| Service port  | `3000` (client), `3001` (authentication), `8080` (Hasura API) |
| Images        | `ghcr.io/successible/cleanslate/client:latest`                |
|               | `ghcr.io/successible/cleanslate/graphql-server:latest`        |
|               | `ghcr.io/successible/cleanslate/authentication-server:latest` |
|               | `postgres:15`                                                 |
| Data          | `./cleanslate-data/db` (PostgreSQL database)                  |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`HASURA_GRAPHQL_ADMIN_SECRET`.** The password of the Hasura console and the API. Generate one with `openssl rand -hex 32`.
- **`JWT_SIGNING_SECRET`.** The key that signs the login tokens. Hasura needs at least 32 characters. Generate one with `openssl rand -hex 32`.
- **`POSTGRES_PASSWORD`.** The password of the database. Generate one with `openssl rand -hex 32`. Use letters and digits only, because the value is part of the database address. PostgreSQL applies it only when it first creates the database.

## Deviations from the standard setup

- **Four containers.** Clean Slate has three parts that share the network of the `tailscale` container: `application` (the web client), `graphql` (Hasura, `app-cleanslate-graphql`), and `auth` (the authentication server, `app-cleanslate-auth`). The fourth container, `database` (PostgreSQL, `app-cleanslate-db`), uses the default Compose network. Hasura reaches it by its service name through Docker's DNS, so keep `TS_ACCEPT_DNS` disabled. The authentication server reaches Hasura at `127.0.0.1:8080`, because both run in the same network namespace.
- **Several Serve routes.** Clean Slate expects one address for all its parts, so Tailscale Serve forwards by path: `/auth` to the authentication server (`3001`), `/v1/`, `/v1alpha1/`, `/v2/`, `/console`, and `/healthz` to Hasura (`8080`), and everything else to the client (`3000`). The Hasura console reads its server settings from `/v1alpha1/config`. The upstream project uses a Caddy reverse proxy for this, which this stack replaces.
- **No LAN port.** The `ports` block stays commented out. The client calls the API on the same address and port 443, so the stack works only through Tailscale Serve.
- **Hasura console.** `HASURA_GRAPHQL_ENABLE_CONSOLE` is on, as upstream, because you need the console to create your profile. It is reachable on your Tailnet at `/console` and protected by the admin secret. Your browser loads the console assets from the Hasura CDN, so the console needs internet access.
- **Firebase login.** Upstream can use Firebase for sign-in. That needs images built from the source with your Firebase settings, so this stack supports only the default token login.
- **Image tags.** The three Clean Slate images use `latest`, as the upstream Compose file does, and they belong together: update all three at the same time. PostgreSQL stays on `15`, the major version upstream uses.

## First run

Create a profile in the Hasura console. Clean Slate has no sign-up page.

1. Open `https://cleanslate.<tailnet>.ts.net/console` and enter the value of `HASURA_GRAPHQL_ADMIN_SECRET`.
2. Go to **Data**, then **default**, then **public**, then **profiles**, and select **Insert Row**. Select **Save** without changing anything.
3. Select **Browse Rows** and copy the `apiToken` of the new row. This long token is your password.
4. Open `https://cleanslate.<tailnet>.ts.net` and log in with the token.

Repeat these steps to create a profile for another person. Do not share a token: anyone who has it can use that account. To replace a token, edit the `apiToken` of the row in the console.

## Configuration

- **`HASURA_GRAPHQL_CORS_DOMAIN`.** The origin that may call the API from a browser. The default `*` allows any origin. To restrict it, set the exact address of the web interface, such as `https://cleanslate.<tailnet>.ts.net`. Browsers then block API calls from other origins, and Hasura refuses their websocket connections. Recreate the stack after you change the value.

## Links

- [Clean Slate documentation](https://github.com/successible/cleanslate#how-do-i-host-clean-slate)
- [Clean Slate source code](https://github.com/successible/cleanslate)
