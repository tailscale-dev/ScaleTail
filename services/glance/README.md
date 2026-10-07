# Glance

[Glance](https://github.com/glanceapp/glance) is a dashboard that puts your feeds on one page, such as RSS, weather, markets, and the status of your services.

This stack runs Glance with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                      |
| ------------- | ---------------------------------------------------------- |
| Web interface | `https://glance.<tailnet>.ts.net`                          |
| Service port  | `8080`                                                     |
| Image         | `glanceapp/glance`                                         |
| Data          | `./glance-data/config` (configuration files)               |
|               | `./glance-data/assets` (custom assets, such as `user.css`) |

## Before you start

Glance needs its configuration files before the first start. Without `glance.yml`, the `application` container keeps restarting.

1. Add `glance.yml` and `home.yml` to `./glance-data/config`. You find both in the [`config` folder of the Glance template](https://github.com/glanceapp/docker-compose-template/tree/main/root/config).
2. Add `user.css` to `./glance-data/assets`. You find it in the [`assets` folder of the Glance template](https://github.com/glanceapp/docker-compose-template/tree/main/root/assets).

## Deviations from the standard setup

None.

## First run

Glance has no login by default. Open the web interface, then edit the files in `./glance-data/config` to build your pages.

## Links

- [Glance configuration documentation](https://github.com/glanceapp/glance/blob/main/docs/configuration.md)
- [Glance source code](https://github.com/glanceapp/glance)
