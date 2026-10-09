# Nanote

[Nanote](https://github.com/omarmir/nanote) is a lightweight note-taking application. It stores your notes as Markdown files in folders, so that you can use them with other tools as well.

This stack runs Nanote with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                          |
| ------------- | ---------------------------------------------- |
| Web interface | `https://nanote.<tailnet>.ts.net`              |
| Service port  | `3000`                                         |
| Image         | `omarmir/nanote`                               |
| Data          | `./nanote-data` (your notes as Markdown files) |

## Before you start

Set `SECRET_KEY` in `.env` to your own secret, for example from `openssl rand -hex 32`. Nanote uses it as the key to log in. Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with the value of `SECRET_KEY`.

## Upgrading

Earlier versions of this stack had the sample value `<yourkey>` for `SECRET_KEY` in `compose.yaml`. The key is now in `.env`. It is empty, and Compose stops with an error until you set it. If you already run the stack, set it to the key that you use now. If you kept the sample value, choose a new key. Nanote does not store the key, so you only have to log in again.

## Links

- [Nanote documentation and source code](https://github.com/omarmir/nanote)
