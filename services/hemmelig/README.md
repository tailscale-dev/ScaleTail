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

Change these values in `compose.yaml`:

- **`BETTER_AUTH_URL` and `HEMMELIG_BASE_URL`.** The address of the web interface, `https://hemmelig.<tailnet>.ts.net`. The sample value is `https://secrets.example.com`.
- **`BETTER_AUTH_SECRET`.** A random value of at least 32 characters. The sample value is public.

## Deviations from the standard setup

None.

## First run

Open the web interface. Hemmelig asks you to create the first account.

## Links

- [Hemmelig documentation and source code](https://github.com/HemmeligOrg/Hemmelig.app)
