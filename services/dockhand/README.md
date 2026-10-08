# Dockhand

[Dockhand](https://github.com/Finsys/dockhand) is a web interface to manage Docker. You manage containers, images, volumes, networks, and Compose stacks on local and remote Docker hosts.

This stack runs Dockhand with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://dockhand.<tailnet>.ts.net` |
| Service port  | `3000`                              |
| Image         | `fnsys/dockhand`                    |
| Data          | `./dockhand-data`                   |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Dockhand mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can reach Dockhand has full control over the Docker host.

## First run

Open the web interface. Dockhand has no login by default, so everyone who can reach the device on your Tailnet can manage Docker. Enable authentication in the settings.

## Links

- [Dockhand documentation and source code](https://github.com/Finsys/dockhand)
