# Umami

[Umami](https://umami.is/) is a web analytics platform that respects the privacy of your visitors. It uses no cookies and collects no personal data.

This stack runs Umami with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                      |
| ------------- | ------------------------------------------ |
| Web interface | `https://umami.<tailnet>.ts.net`           |
| Service port  | `3000`                                     |
| Images        | `ghcr.io/umami-software/umami:latest`      |
|               | `postgres:15-alpine`                       |
| Data          | `./umami-data/db` (PostgreSQL database)    |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`APP_SECRET`.** A random value. Generate one with `openssl rand -hex 32`.
- **`DB_PASSWORD`.** The password of the database. Use letters and digits only, because the value is part of the database address. PostgreSQL applies it only when it first creates the database.

## Deviations from the standard setup

- **Extra container.** The stack runs `database` (PostgreSQL). It uses the default Compose network, and Umami reaches it by its service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve this name.
- **Two Serve configurations.** `compose.yaml` defines `ts-serve-private` and `ts-serve-public`. `SERVE_CONFIG` in `.env` selects one of them. The default is `private`, which matches the standard setup.
- **Funnel in public mode.** With `SERVE_CONFIG=public`, Tailscale Funnel publishes `/script.js` and `/api/send` on port 443 to the public internet. The web interface moves to `https://umami.<tailnet>.ts.net:8443` and stays Tailnet-only.

## First run

Open the web interface and log in with the username `admin` and the password `umami`. Change this password right after the first login.

Then add a website in Umami and embed its tracking script in your site, as described in the [Umami documentation](https://umami.is/docs/collect-data):

```html
<script defer src="https://umami.<tailnet>.ts.net/script.js" data-website-id="..."></script>
```

## Configuration

- **`SERVE_CONFIG`.** Use `private` when all visitors of your websites are on your Tailnet. Use `public` to collect data from websites with visitors outside your Tailnet. Public mode needs [Funnel](https://tailscale.com/kb/1223/funnel) allowed for the device in your Tailnet policy. Recreate the stack after you change the value.

## Links

- [Umami documentation](https://umami.is/docs)
- [Umami source code](https://github.com/umami-software/umami)
