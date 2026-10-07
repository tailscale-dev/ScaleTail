# Hemmelig

[Hemmelig](https://github.com/HemmeligOrg/Hemmelig.app) shares secrets such as passwords and API keys with a link. It encrypts the secret in the browser, and the secret is deleted after it is read or when it expires.

The upstream repository is archived, so the project gets no further updates.

This stack runs Hemmelig with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://hemmelig.<tailnet>.ts.net`         |
| Service port  | `3000`                                      |
| Image         | `hemmeligapp/hemmelig:v7`                   |
| Data          | `./hemmelig-data/database` (database)       |
|               | `./hemmelig-data/uploads` (encrypted files) |

## Before you start

- **Set the addresses in `compose.yaml`.** Change `BETTER_AUTH_URL` and `HEMMELIG_BASE_URL` to the address of the web interface, `https://hemmelig.<tailnet>.ts.net`. The sample value is `https://secrets.example.com`.
- **Set the secret in `.env`.** Set `BETTER_AUTH_SECRET` to a random value of at least 32 characters. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface. Hemmelig asks you to create the first account.

## Upgrading

Earlier versions of this stack had a sample value for `BETTER_AUTH_SECRET` in `compose.yaml`. It is now empty in `.env`, and you must set it. With a new value, everyone has to log in again.

## Links

- [Hemmelig documentation and source code](https://github.com/HemmeligOrg/Hemmelig.app)
