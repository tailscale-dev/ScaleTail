# Dozzle

[Dozzle](https://dozzle.dev/) is a web interface to follow the logs of your Docker containers in real time.

This stack runs Dozzle with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://dozzle.<tailnet>.ts.net` |
| Service port  | `8080`                            |
| Image         | `amir20/dozzle`                   |
| Data          | `./dozzle-data/data/`             |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Docker socket.** Dozzle mounts `/var/run/docker.sock` read-only to read the logs of all containers on the Docker host. The `:ro` flag only makes the socket file read-only. It does not limit what the service can do through the Docker API, so treat access to the socket as root access to the Docker host.

## First run

Dozzle has no login by default. Open the web interface to see the containers of the Docker host. Everyone who can reach the device on your Tailnet can read these logs.

## Configuration

### Require a login

Dozzle can ask for a username and password with its `simple` provider. See [Dozzle authentication](https://dozzle.dev/guide/authentication).

1. Replace the example user in `dozzle-data/data/users.yml` with your own. The comment at the top of the file shows the command that creates a user. Dozzle reads this file as `/data/users.yml`.
2. Add `- DOZZLE_AUTH_PROVIDER=simple` to the `environment` of the `application` service in `compose.yaml`.
3. Run `docker compose up -d --force-recreate`.

Without `DOZZLE_AUTH_PROVIDER=simple`, Dozzle ignores `users.yml`. With it, Dozzle stops at startup with `invalid password hash` as long as the example user is in the file.

## Upgrading

Earlier versions of this stack mounted `./dozzle-data/dozzle-data` as `/data`, but kept the example `users.yml` one level higher, where Dozzle did not read it. The stack now mounts `./dozzle-data/data`, and the example is in that folder. If you created files in `dozzle-data/dozzle-data/`, such as your own `users.yml`, move them to the new folder before you start the new version:

```bash
docker compose down
mv dozzle-data/dozzle-data/* dozzle-data/data/
rmdir dozzle-data/dozzle-data
docker compose up -d
```

If `dozzle-data/dozzle-data/` is empty, skip the `mv` command. Your `users.yml` replaces the example, so `git status` shows the file as changed. If you change `SERVICE`, use the folder name `${SERVICE}-data` in these commands.

## Links

- [Dozzle documentation](https://dozzle.dev/guide/getting-started)
- [Dozzle source code](https://github.com/amir20/dozzle)
