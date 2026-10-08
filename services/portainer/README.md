# Portainer

[Portainer](https://www.portainer.io/) is a web interface to manage Docker. You start, stop, inspect, and update the containers, images, volumes, and networks of the Docker host.

This stack runs Portainer with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://portainer.<tailnet>.ts.net` |
| Service port  | `9000`                               |
| Image         | `portainer/portainer-ce`             |
| Data          | `./portainer-data/portainer_data`    |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Portainer mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to Portainer has full control over the Docker host.

## First run

1. Portainer prints a setup token to the log at the first start:

   ```bash
   docker logs app-portainer 2>&1 | grep setup_token
   ```

2. Open the web interface. Enter the setup token and create the administrator account. The password must have at least 12 characters.
3. Portainer then manages the Docker host through the mounted Docker socket.

## Links

- [Portainer documentation](https://docs.portainer.io/)
- [Portainer source code](https://github.com/portainer/portainer)
