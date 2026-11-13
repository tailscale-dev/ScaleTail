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

While the `simple` provider is off, Dozzle ignores `users.yml`. With it, Dozzle stops at startup with `invalid password hash` as long as the example user is in the file.

Dozzle also has a setup page that creates the first user, but it opens only when `/data` is empty at the first start. In this stack the folder holds the example `users.yml`, so the setup page stays closed. Follow the steps above instead.

## Upgrading

Earlier versions of this stack mounted `./dozzle-data/dozzle-data` as `/data`, but kept the example `users.yml` one level higher, where Dozzle did not read it. The stack now mounts `./dozzle-data/data`, and the example is in that folder. Move everything from `dozzle-data/dozzle-data/` to the new folder before you start the new version. Dozzle keeps its own files there as well, such as `dozzle.yml` and `users.yml` when you set up the login in its web interface. If you skip the move, Dozzle starts without them, and so without a login. Docker created the old folder, and Dozzle wrote the files in it, as `root`, so the commands need `sudo`:

```bash
docker compose down
sudo mkdir -p dozzle-data/data
sudo mv dozzle-data/dozzle-data/* dozzle-data/data/
sudo rmdir dozzle-data/dozzle-data
sudo chown "$(id -u):$(id -g)" dozzle-data/data/users.yml
docker compose up -d
```

If `dozzle-data/dozzle-data/` is empty, skip the `mv` command. Your `users.yml` replaces the example, so `git status` shows the file as changed. The `chown` command makes you the owner of that file again, so that git can read it. If you changed `SERVICE`, replace `dozzle-data` at the start of each path by `<SERVICE>-data`.

## Links

- [Dozzle documentation](https://dozzle.dev/guide/getting-started)
- [Dozzle source code](https://github.com/amir20/dozzle)
