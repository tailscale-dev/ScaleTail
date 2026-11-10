# Dozzle

[Dozzle](https://dozzle.dev/) is a web interface to follow the logs of your Docker containers in real time.

This stack runs Dozzle with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://dozzle.<tailnet>.ts.net` |
| Service port  | `8080`                            |
| Image         | `amir20/dozzle`                   |
| Data          | `./dozzle-data/dozzle-data`       |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Dozzle mounts `/var/run/docker.sock` read-only to read the logs of all containers on the Docker host. The `:ro` flag only makes the socket file read-only. It does not limit what the service can do through the Docker API, so treat access to the socket as root access to the Docker host.

## First run

Dozzle has no login by default. Open the web interface to see the containers of the Docker host. Everyone who can reach the device on your Tailnet can read these logs.

## Configuration

### Require a login

Dozzle can ask for a username and password. See [Dozzle authentication](https://dozzle.dev/guide/authentication) for the `simple` provider and its `users.yml` file. The file `dozzle-data/users.yml` in this directory is an example of that format.

## Links

- [Dozzle documentation](https://dozzle.dev/guide/getting-started)
- [Dozzle source code](https://github.com/amir20/dozzle)
