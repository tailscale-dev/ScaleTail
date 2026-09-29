# EspoCRM with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [EspoCRM](https://www.espocrm.com/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## EspoCRM

[EspoCRM](https://www.espocrm.com/) is a web application that allows users to see, enter and evaluate all your company relationships regardless of the type. People, companies, projects or opportunities — all in an easy and intuitive interface.

## Configuration Overview

In this setup, the `tailscale-EspoCRM` service runs Tailscale, which manages secure networking for EspoCRM. The `EspoCRM` service utilizes the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## What to document for users

- Links: [EspoCRM Features](https://www.espocrm.com/features/) [Environment Details](https://docs.espocrm.com/administration/docker/installation/#installation-environments)

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variable `TS_AUTHKEY`
- `.env` // Required for normal operation. `TS_DOMAIN`

## Upgrading from an older ScaleTail configuration

From EspoCRM 10, the upstream Docker setup no longer mounts the whole `/var/www/html` directory. This configuration follows it and mounts only `data`, `custom`, and `client/custom` from `./espocrm-data`, so existing data and customizations stay in place.

1. Back up `./espocrm-data`.
2. Run `docker compose down`, then `docker compose pull` and `docker compose up -d`.
3. Optionally, remove the files that older images copied into `./espocrm-data`, such as `application`, `vendor`, and `bootstrap.php`. The [EspoCRM 10 migration guide](https://docs.espocrm.com/administration/docker/installation/#migration-to-espocrm-10) lists them all.
