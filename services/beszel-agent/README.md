# Beszel Agent

[Beszel](https://beszel.dev/) is a lightweight server monitoring platform. The agent collects the statistics of one system and its Docker containers for a [Beszel hub](../beszel-hub/).

This stack runs Beszel Agent with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                 |
| ------------- | ----------------------------------------------------- |
| Web interface | None                                                  |
| Agent port    | `45876` on the Tailscale IP address of `beszel-agent` |
| Image         | `henrygd/beszel-agent`                                |
| Data          | None                                                  |

## Before you start

The agent only starts with the public key of your hub.

1. In the web interface of the hub, select **Add System** and copy the public key.
2. In `compose.yaml`, replace the value of `KEY` with that key.

Without a valid key, the `application` container keeps restarting.

## Deviations from the standard setup

- **No web interface.** The stack has no Tailscale Serve configuration and no `./config` folder. The hub connects to the agent on port `45876` of its Tailscale IP address.
- **Docker socket.** The agent mounts `/var/run/docker.sock` read-only to read the statistics of the containers on the Docker host. The `:ro` flag only makes the socket file read-only. It does not limit what the service can do through the Docker API, so treat access to the socket as root access to the Docker host.
- **No data folder.** The agent stores nothing on disk.

## First run

In the **Add System** dialog of the hub, enter the Tailscale IP address of the `beszel-agent` device and port `45876`. Your Tailnet policy must allow the hub to reach the agent on that port.

## Links

- [Beszel documentation](https://beszel.dev/guide/getting-started)
- [Beszel source code](https://github.com/henrygd/beszel)
