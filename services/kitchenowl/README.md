# KitchenOwl

[KitchenOwl](https://kitchenowl.org/) is a grocery list and recipe manager for households. You share shopping lists, collect recipes, plan your meals, and track expenses together.

This stack runs KitchenOwl with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://kitchenowl.<tailnet>.ts.net` |
| Service port  | `8080`                                |
| Image         | `tombursch/kitchenowl`                |
| Data          | `./kitchenowl-data`                   |

## Before you start

Set `JWT_SECRET_KEY` in `.env` to a long random value, for example from `openssl rand -hex 32`.

## Deviations from the standard setup

- **Service name.** The application service is called `kitchenowl`, not `application`.
- **The container reads the whole `.env` file.** The `kitchenowl` container loads `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in its environment.

## First run

Open the web interface and create the first account, which becomes the administrator. Then create your household and invite the other members.

In the KitchenOwl apps, use `https://kitchenowl.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Configuration

### OpenID Connect

KitchenOwl can use an OpenID Connect provider for the login, such as Authentik, Authelia, Keycloak, or [Pocket ID](../pocket-id/).

1. Set `FRONT_URL` in `.env` to the exact address of the web interface, and fill in `OIDC_ISSUER`, `OIDC_CLIENT_ID`, and `OIDC_CLIENT_SECRET`.
2. Uncomment the matching lines in the `environment` block of `compose.yaml`.

See the [KitchenOwl OpenID Connect documentation](https://docs.kitchenowl.org/latest/self-hosting/oidc/).

## Links

- [KitchenOwl documentation](https://docs.kitchenowl.org/)
- [KitchenOwl source code](https://github.com/TomBursch/kitchenowl)
