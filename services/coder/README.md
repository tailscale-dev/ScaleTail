# Coder

[Coder](https://coder.com/) provisions development environments on your own infrastructure. You define a workspace as a Terraform template and open it in your browser or your local editor.

This stack runs Coder with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                           |
| ------------- | ----------------------------------------------- |
| Web interface | `https://coder.<tailnet>.ts.net`                |
| Service port  | `7080`                                          |
| Images        | `ghcr.io/coder/coder`                           |
|               | `postgres:17`                                   |
| Data          | `./coder-data/coder-home` (Coder home folder)   |
|               | `./coder-data/coder-data` (PostgreSQL database) |

## Before you start

1. Create the home folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. The Coder image runs as user and group `1000` and then fails with `mkdir /home/coder/.cache: permission denied`.

   ```bash
   mkdir -p coder-data/coder-home
   sudo chown 1000:1000 coder-data/coder-home
   ```

2. Set these values in `.env`:

   - **`CODER_ACCESS_URL`.** The address of the web interface, `https://coder.<tailnet>.ts.net`.
   - **`POSTGRES_PASSWORD`.** The password of the database. Use letters and digits only, because the database address contains it. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **Extra container.** The stack runs a `database` container with PostgreSQL. It uses the network of the `tailscale` container as well, so Coder reaches it at `localhost`. PostgreSQL therefore also listens on port `5432` of the Tailscale IP address of the device.
- **Docker socket.** Coder mounts `/var/run/docker.sock` read-only, so that templates can use Docker on the host. The `:ro` flag only makes the socket file read-only. It does not limit what the service can do through the Docker API, so treat access to the socket as root access to the Docker host.
- **Image version.** `CODER_VERSION` in `.env` selects the version of the Coder image.

## First run

Open the web interface and create the first account, which becomes the administrator.

## Upgrading

Earlier versions of this stack had a sample value for `POSTGRES_PASSWORD` in `.env`. It is now empty, and Compose stops with an error until you set it. If you already run the stack, keep the values that you use now. This is required for the database password, because the database applies it only at the first start. If you kept the sample value, set `POSTGRES_PASSWORD=strongpassword` again. The database still uses it.

## Links

- [Coder documentation](https://coder.com/docs)
- [Coder source code](https://github.com/coder/coder)
