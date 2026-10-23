# Storyteller

[Storyteller](https://storyteller-platform.dev/) is a self-hosted platform for creating and reading ebooks with synced narration. It aligns audiobooks and ebooks that you already own, so that you can read, listen, or do both.

This stack runs Storyteller with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                  |
| ------------- | ------------------------------------------------------ |
| Web interface | `https://storyteller.<tailnet>.ts.net`                 |
| Service port  | `8001`                                                 |
| Image         | `registry.gitlab.com/storyteller-platform/storyteller` |
| Data          | `./storyteller-data/data` (database, books, uploads)   |

## Before you start

Set this value in `.env`. Compose stops with an error if it is empty.

- **`STORYTELLER_SECRET_KEY`.** The key that signs the login tokens. Generate one with `openssl rand -base64 32`. Keep it: a new key logs everyone out.

## Deviations from the standard setup

None.

## First run

Open the web interface. Storyteller sends you to its setup page. Enter an email address, your name, a username, and a password to create the first account, which is the administrator account. Then add your ebooks and audiobooks from the web interface.

## Links

- [Storyteller documentation](https://storyteller-platform.dev/docs/welcome)
- [Storyteller self-hosting guide](https://storyteller-platform.dev/docs/installation/self-hosting/)
- [Storyteller source code](https://gitlab.com/storyteller-platform/storyteller)
