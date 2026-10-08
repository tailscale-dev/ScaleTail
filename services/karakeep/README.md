# Karakeep

[Karakeep](https://karakeep.app/) is a bookmark manager for links, notes, and images. It archives the pages that you save, searches their full text, and can tag them automatically with AI.

This stack runs Karakeep with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                    |
| ------------- | -------------------------------------------------------- |
| Web interface | `https://karakeep.<tailnet>.ts.net`                      |
| Service port  | `3000`                                                   |
| Images        | `ghcr.io/karakeep-app/karakeep`                          |
|               | `ghcr.io/karakeep-app/karakeep-chrome:release`           |
|               | `getmeili/meilisearch:v1.11.1`                           |
| Data          | `./karakeep-data/data` (bookmarks, assets, and database) |
|               | `./karakeep-data/meilisearch` (search index)             |

## Before you start

Set these values in `.env`:

- **`NEXTAUTH_URL`.** The address of the web interface, `https://karakeep.<tailnet>.ts.net`. Karakeep does not start with the sample value.
- **`NEXTAUTH_SECRET` and `MEILI_MASTER_KEY`.** Two different random values, for example from `openssl rand -base64 36`. The sample values are public.

## Deviations from the standard setup

- **Service name.** The application service is called `web`, not `application`, and its container is `app-karakeep-web`.
- **Extra containers.** The stack runs `chrome`, a headless browser that fetches the pages, and `meilisearch` for the search. They use the default Compose network, and Karakeep reaches them by their service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Images are set in `compose.yaml`.** The stack does not use `IMAGE_URL`. `KARAKEEP_VERSION` in `.env` selects the version of the Karakeep image.
- **The containers read the whole `.env` file.** The `web` and `meilisearch` containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in their environment.

## First run

Open the web interface and sign up. The first account becomes the administrator. To stop others from registering afterwards, set `DISABLE_SIGNUPS=true` in `.env` and restart the stack.

## Links

- [Karakeep documentation](https://docs.karakeep.app/)
- [Karakeep source code](https://github.com/karakeep-app/karakeep)
