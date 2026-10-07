# Forgejo

[Forgejo](https://forgejo.org/) is a Git service that you host yourself. It offers repositories, pull requests, issues, packages, and CI, and a community governs its development.

This stack runs Forgejo with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                             |
| ------------- | ----------------------------------------------------------------- |
| Web interface | `https://forgejo.<tailnet>.ts.net`                                |
| Service port  | `3000`                                                            |
| Git over SSH  | Port `22` on the Tailscale IP address of `forgejo`                |
| Image         | `codeberg.org/forgejo/forgejo:12`                                 |
| Data          | `./forgejo-data/data` (repositories, database, and configuration) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Git over SSH.** The SSH server of Forgejo listens on port `22` of the Tailscale IP address of the device. It does not use Tailscale Serve.
- **Time zone.** The stack mounts `/etc/timezone` and `/etc/localtime` of the Docker host read-only, in addition to `TZ`.
- **User and group.** The image uses `USER_UID` and `USER_GID` for the owner of the data, which `compose.yaml` sets to `1000`.

## First run

Open the web interface. Forgejo shows its installation page:

1. Keep SQLite as the database, or enter the details of your own database.
2. Set the server domain to `forgejo.<tailnet>.ts.net` and the base URL to `https://forgejo.<tailnet>.ts.net/`.
3. Create the administrator account at the bottom of the page. If you skip this, the first account that registers becomes the administrator.

## Links

- [Forgejo documentation](https://forgejo.org/docs/latest/)
- [Forgejo source code](https://codeberg.org/forgejo/forgejo)
- [Video: a private Git server with Tailscale and Forgejo](https://www.youtube.com/watch?v=JcrcbkDGJuk)
