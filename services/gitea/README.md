# Gitea

[Gitea](https://about.gitea.com/) is a lightweight Git service that you host yourself. It offers repositories, pull requests, issues, packages, and CI.

This stack runs Gitea with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                           |
| ------------- | --------------------------------------------------------------- |
| Web interface | `https://gitea.<tailnet>.ts.net`                                |
| Service port  | `3000`                                                          |
| Git over SSH  | Port `22` on the Tailscale IP address of `gitea`                |
| Image         | `docker.gitea.com/gitea`                                        |
| Data          | `./gitea-data/data` (repositories, database, and configuration) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Git over SSH.** The SSH server of Gitea listens on port `22` of the Tailscale IP address of the device. It does not use Tailscale Serve.
- **Time zone.** The stack mounts `/etc/timezone` and `/etc/localtime` of the Docker host read-only, in addition to `TZ`.
- **User and group.** The image uses `USER_UID` and `USER_GID` for the owner of the data, which `compose.yaml` sets to `1000`.
- **Fixed data folder.** The data folder is always `./gitea-data`, also when you change `SERVICE` in `.env`.

## First run

Open the web interface. Gitea shows its installation page:

1. Keep SQLite as the database, or enter the details of your own database.
2. Set the server domain to `gitea.<tailnet>.ts.net` and the base URL to `https://gitea.<tailnet>.ts.net/`.
3. Create the administrator account at the bottom of the page. If you skip this, the first account that registers becomes the administrator.

## Links

- [Gitea documentation](https://docs.gitea.com/)
- [Gitea source code](https://github.com/go-gitea/gitea)
