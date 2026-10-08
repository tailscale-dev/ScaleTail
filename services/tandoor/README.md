# Tandoor Recipes

[Tandoor Recipes](https://tandoor.dev/) manages your recipes. It also plans your meals and builds your shopping lists.

This stack runs Tandoor Recipes with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://tandoor.<tailnet>.ts.net`                        |
| Service port  | `9001`                                                    |
| Images        | `vabene1111/recipes`                                      |
|               | `postgres:16-alpine`                                      |
| Data          | `./tandoor-data/mediafiles` (uploaded images and files)   |
|               | `./tandoor-data/staticfiles` (files of the web interface) |
|               | `./tandoor-data/database` (PostgreSQL database)           |

## Before you start

Set these values in `.env`:

- **`SECRET_KEY`.** A long random value. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty.
- **`POSTGRES_PASSWORD`.** A random password of letters and digits. Compose stops with an error if it is empty.
- **`ALLOWED_HOSTS`.** The name of the device on your Tailnet, `tandoor.<tailnet>.ts.net`. Tandoor answers requests for other host names with error `400`.

## Deviations from the standard setup

- **Extra container.** The stack runs a `database` container with PostgreSQL. It uses the network of the `tailscale` container as well, so Tandoor reaches it at `127.0.0.1`. PostgreSQL therefore also listens on port `5432` of the Tailscale IP address of the device.
- **Service port.** `TANDOOR_PORT` makes Tandoor listen on the port from `SERVICEPORT`, which is `9001`.
- **The container reads the whole `.env` file.** The `application` container loads `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in its environment.

## First run

The first start can take a few minutes, because Tandoor prepares its database. Then open the web interface. Tandoor sends you to the setup page, where you create the first account.

## Upgrading

Earlier versions of this stack had sample values for `SECRET_KEY` and `POSTGRES_PASSWORD` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample value, set `POSTGRES_PASSWORD=REPLACE_WITH_RANDOM_ALPHANUMERIC_PASSWORD` again. The database still uses it.

## Links

- [Tandoor Recipes documentation](https://docs.tandoor.dev/)
- [Tandoor Recipes source code](https://github.com/TandoorRecipes/recipes)
