# Home Assistant

[Home Assistant](https://www.home-assistant.io/) is a home automation platform. It controls and automates the smart devices in your home from one interface and runs locally.

This stack runs Home Assistant with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                          |
| ------------- | ---------------------------------------------- |
| Web interface | `https://home-assistant.<tailnet>.ts.net`      |
| Service port  | `8123`                                         |
| Image         | `ghcr.io/home-assistant/home-assistant:stable` |
| Data          | `./home-assistant-data/config`                 |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Privileged container.** The `application` container runs with `privileged: true`, so that Home Assistant can use the devices of the Docker host, such as USB sticks for Zigbee or Z-Wave.
- **D-Bus.** The stack mounts `/run/dbus` of the Docker host read-only, which the Bluetooth integration needs.
- **Time zone.** The stack mounts `/etc/localtime` of the Docker host read-only, in addition to `TZ`.
- **Not on your local network.** Home Assistant uses the network of the `tailscale` container and not that of the Docker host. Integrations that discover devices in your local network by broadcast may therefore not find them.

## First run

1. Start the stack once. Home Assistant creates its configuration in `./home-assistant-data/config`.
2. Home Assistant rejects requests through a reverse proxy that it does not know, and answers `400: Bad Request`. Add this block to `./home-assistant-data/config/configuration.yaml` to trust Tailscale Serve:

   ```yaml
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 127.0.0.1
   ```

3. Restart the stack with `docker compose restart application`.
4. Open the web interface and follow the onboarding. You create the owner account and set your location.

## Links

- [Home Assistant documentation](https://www.home-assistant.io/docs/)
- [Home Assistant HTTP integration](https://www.home-assistant.io/integrations/http/), for the reverse proxy settings
- [Home Assistant source code](https://github.com/home-assistant/core)
