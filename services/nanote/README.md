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

Replace `<yourkey>` in `SECRET_KEY` in `compose.yaml` with your own secret. Nanote uses it as the key to log in.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with the value of `SECRET_KEY`.

## Links

- [Nanote documentation and source code](https://github.com/omarmir/nanote)
