# Dockge

[Dockge](https://github.com/louislam/dockge) is a web interface to manage Docker Compose stacks. You create, edit, start, and update your `compose.yaml` files in the browser.

This stack runs Dockge with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                              |
| ------------- | -------------------------------------------------- |
| Web interface | `https://dockge.<tailnet>.ts.net`                  |
| Service port  | `5001`                                             |
| Image         | `louislam/dockge:1`                                |
| Data          | `./dockge-data/app/config` (Dockge settings)       |
|               | The folder from `STACKS_DIR` (your Compose stacks) |

## Before you start

Set `STACKS_DIR` in `.env` to the absolute path of the folder on the Docker host that holds your stacks. The stack mounts it at the same path in the container. The default is `/opt/stacks`.

## Deviations from the standard setup

- **Docker socket.** Dockge mounts `/var/run/docker.sock` with write access, which it needs to manage your stacks. Everyone who can log in to Dockge has full control over the Docker host.
- **Stacks folder.** The stacks are in the folder from `STACKS_DIR`, outside this directory.
- **User and group.** `PUID` and `PGID` in `.env` set the owner of the stack files.

## First run

Open the web interface and create the administrator account.

## Links

- [Dockge documentation and source code](https://github.com/louislam/dockge)
