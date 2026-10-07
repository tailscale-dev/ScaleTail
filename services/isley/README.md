# Isley

[Isley](https://github.com/dwot/isley) is a grow journal for home growers. You log your plants, watering, and feeding, follow sensor data from your grow equipment, and keep track of seeds and harvests.

This stack runs Isley with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                          |
| ------------- | ---------------------------------------------- |
| Web interface | `https://isley.<tailnet>.ts.net`               |
| Service port  | `8080`                                         |
| Image         | `dwot/isley`                                   |
| Data          | `./isley-data/isley-db` (database)             |
|               | `./isley-data/isley-uploads` (uploaded images) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with username `admin` and password `isley`. Isley then asks you to set a new password.

## Links

- [Isley documentation and source code](https://github.com/dwot/isley)
