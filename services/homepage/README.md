# Homepage

[Homepage](https://gethomepage.dev/) is a dashboard for your services and bookmarks. It shows live information from many applications and from Docker.

This stack runs Homepage with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://homepage.<tailnet>.ts.net` |
| Service port  | `3000`                              |
| Image         | `ghcr.io/gethomepage/homepage`      |
| Data          | `./homepage-data/config`            |

## Before you start

Set `TAILNET_NAME` in `.env` to your Tailnet name, without `.ts.net`. Homepage only answers requests for the host name in `HOMEPAGE_ALLOWED_HOSTS`, which `compose.yaml` builds as `homepage.<TAILNET_NAME>.ts.net`.

## Deviations from the standard setup

- **Allowed host.** `HOMEPAGE_ALLOWED_HOSTS` contains the fixed name `homepage`. If you change `SERVICE` in `.env`, change this value in `compose.yaml` as well.
- **Docker socket.** Homepage mounts `/var/run/docker.sock` read-only for its Docker integration. Remove the line if you do not use it. The `:ro` flag only makes the socket file read-only. It does not limit what the service can do through the Docker API, so treat access to the socket as root access to the Docker host.

## First run

Homepage has no login. Open the web interface, then edit the YAML files in `./homepage-data/config` to add your services, bookmarks, and widgets.

## Links

- [Homepage documentation](https://gethomepage.dev/configs/)
- [Homepage source code](https://github.com/gethomepage/homepage)
