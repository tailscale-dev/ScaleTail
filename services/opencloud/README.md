# OpenCloud

[OpenCloud](https://opencloud.eu) is a self-hosted file sync and sharing platform, a fork of ownCloud Infinite Scale. You store files in personal and shared spaces, share them with links, and synchronise them with the desktop and mobile clients.

This stack runs OpenCloud with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://opencloud.<tailnet>.ts.net`          |
| Service port  | `9200`                                        |
| Image         | `opencloudeu/opencloud-rolling:8.1.0`         |
| Data          | `./opencloud-data/data` (files and metadata)  |
|               | `./opencloud-data/config` (config and secrets) |

## Before you start

Set these values in `.env`. Compose stops with an error until both are set:

- **`TAILNET_NAME`.** Your Tailnet name without `.ts.net`, such as `tail1234`. OpenCloud builds its public address, `https://<SERVICE>.<TAILNET_NAME>.ts.net`, from it and uses that address for the login.
- **`INITIAL_ADMIN_PASSWORD`.** The password of the `admin` user. OpenCloud reads it only at the first start, when it creates the admin user.

Create the data folders before the first start, and give them to the user that runs OpenCloud inside the container, which has the ID `1000`. Docker would otherwise create them as `root`, and OpenCloud could not write to them:

```sh
mkdir -p opencloud-data/config opencloud-data/data
sudo chown -R 1000:1000 opencloud-data
```

## Deviations from the standard setup

- **Start command.** The container runs `opencloud init`, then `opencloud server`. The first command creates the config, with random secrets, in `./opencloud-data/config`. It reports `config file already exists` at every later start, which is expected and ignored.
- **Plain HTTP behind Serve.** `PROXY_TLS=false` makes OpenCloud listen on plain HTTP at port `9200`, because Tailscale Serve terminates TLS. `OC_INSECURE=false` answers the question of `opencloud init` about disabling certificate checks.
- **Public address.** OpenCloud must know its public address and reach it from inside the container. `OC_URL` is built from `SERVICE` and `TAILNET_NAME`, so keep both in line with the name of the Tailnet device.
- **MagicDNS on.** `TS_ACCEPT_DNS=true` is set, because OpenCloud resolves its own Tailnet address to check sign-ins, and Docker's DNS cannot resolve MagicDNS names. The stack has no other container that would need Docker's DNS.
- **Built-in identity provider.** The stack uses the identity provider and user directory that OpenCloud includes. It does not start Collabora, Tika search, antivirus, Radicale, or Keycloak, which the [upstream compose project](https://github.com/opencloud-eu/opencloud-compose) offers as add-ons.

## First run

Open the web interface and sign in as `admin` with the value of `INITIAL_ADMIN_PASSWORD`.

## Links

- [OpenCloud documentation](https://docs.opencloud.eu)
- [OpenCloud source code](https://github.com/opencloud-eu/opencloud)
- [OpenCloud Compose project](https://github.com/opencloud-eu/opencloud-compose)
