# AFFiNE

[AFFiNE](https://affine.pro/) is a workspace that combines documents, whiteboards, and databases. It is an open-source alternative to tools such as Notion and Miro.

This stack runs AFFiNE with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://affine.<tailnet>.ts.net`   |
| Service port  | `3010`                              |
| Images        | `ghcr.io/toeverything/affine`       |
|               | `pgvector/pgvector:pg16`            |
|               | `redis`                             |
| Data          | `./affine-storage` (uploaded files) |
|               | `./affine-config` (configuration)   |
|               | `./postgres` (PostgreSQL database)  |

## Before you start

Set these values in `.env`:

- **`AFFINE_SERVER_EXTERNAL_URL`.** The address of the web interface, `https://affine.<tailnet>.ts.net`. AFFiNE does not start with the sample value, because the `affine_migration` container fails.
- **`DB_PASSWORD`.** The password of the database. It is empty, and Compose stops with an error until you set it.

## Deviations from the standard setup

- **Extra containers.** The stack runs `postgres`, `redis`, and `affine_migration`. The migration container prepares the database and then exits. All three use the default Compose network, and AFFiNE reaches them by their service name through Docker's DNS. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve these names.
- **Image version.** `AFFINE_REVISION` in `.env` selects the version of the AFFiNE image.
- **Data folders.** The data is in `./affine-storage`, `./affine-config`, and `./postgres`, not in a `./affine-data` folder.
- **The containers read the whole `.env` file.** The `application` and `affine_migration` containers load `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in their environment.

## First run

Open the web interface. AFFiNE sends you to its setup page, where you create the administrator account.

## Upgrading

Earlier versions of this stack had a sample value for `DB_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start.

## Links

- [AFFiNE self-hosting documentation](https://docs.affine.pro/self-host-affine)
- [AFFiNE source code](https://github.com/toeverything/affine)
