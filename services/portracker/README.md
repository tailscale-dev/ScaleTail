# Portracker

[Portracker](https://github.com/mostafa-wahied/portracker) discovers the services on your systems and shows which ports they use, so that you have a live map of your ports.

This stack runs Portracker with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://portracker.<tailnet>.ts.net` |
| Service port  | `4999`                                |
| Image         | `mostafawahied/portracker`            |
| Data          | `./portracker-data/data`              |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Portracker mounts `/var/run/docker.sock` read-only to discover the containers on the Docker host.
- **No access to host processes.** Upstream also uses `pid: host` and the `SYS_PTRACE` and `SYS_ADMIN` capabilities to discover the ports of processes on the host. This stack does not set them. See the upstream documentation if you need these ports.

## First run

Portracker has no login by default. Open the web interface. To require a login, set `ENABLE_AUTH=true` in the `environment` block of `compose.yaml`. Portracker then shows a setup wizard for the administrator account.

## Links

- [Portracker documentation and source code](https://github.com/mostafa-wahied/portracker)
