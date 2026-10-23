# openGym

[openGym](https://opengym.ch/) is a self-hosted gym and body-weight tracker. You plan routines, log workouts, and follow your progress, and your data stays on your own server.

This stack runs openGym with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). openGym has no Tailscale support of its own, and neither of its images contains `tailscale` or `tailscaled`.

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://opengym.<tailnet>.ts.net`                        |
| Service port  | `8080`                                                    |
| Images        | `ghcr.io/duartesantos8/opengym-web`                       |
|               | `ghcr.io/duartesantos8/opengym-api`                       |
| Data          | `./opengym-data/`                                         |

## Before you start

Set this value in `.env`. Compose stops with an error if it is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it. openGym binds passkeys to that address, so choose it before anyone creates a profile.

## Deviations from the standard setup

- **Extra container.** The stack runs an `api` container (`app-<service>-api`) next to the `application` container. `application` is the web server, which serves the app and forwards `/api` to the API on `127.0.0.1:3000`. Both containers use the network of the `tailscale` container.
- **Service port.** The web server listens on port `8080` instead of its default `80`, through `NGINX_PORT`, so that the optional `ports` block can use the same port on the host. Tailscale Serve forwards to `8080`.
- **Passkey address.** `RP_ID` and `ORIGIN` in `compose.yaml` are the Tailnet address of the service. openGym accepts sign-ins and syncs only from that address, so the optional `ports` block does not give a working sign-in from your local network. Changing `SERVICE` or `TAILNET_NAME` changes the address and invalidates existing passkeys.
- **Settings.** `compose.yaml` passes only the settings listed in `.env` to the API, not the whole `.env` file as upstream does, so that `TS_AUTHKEY` stays out of the application containers.
- **One address for all visitors.** Tailscale Serve connects to the web server from `127.0.0.1`, and the web server passes that address on to the API, so openGym counts every visitor as the same address. Its per-address limits on wrong passwords, invite codes, and device links therefore apply to everyone together: one person who keeps entering a wrong password can pause password sign-in for everybody for up to 15 minutes. Passkeys keep working. Upstream's `TRUST_PROXY` setting would not change this, and it stays off, because the API also listens on the Tailscale IP address of the device, where a client could set the forwarded address itself.
- **Image health checks.** Both images define their own health check, which runs every five minutes. Compose shows `starting` for the first five minutes after a start.

## First run

Open the web interface and choose to create a new profile. openGym asks you to register a passkey, so open it from a device that is connected to your Tailnet and has a passkey provider. Anyone who can reach the address can create a profile, and each profile has its own data.

To make the first profile an admin, set `FIRST_USER_ADMIN=1` in `.env` before you create it, and run `docker compose up -d`. Admins get an Admin dashboard link under Settings > Account.

## Configuration

These optional settings in `.env` are empty by default, which keeps the upstream defaults. After a change, run `docker compose up -d`.

| Variable           | Purpose                                                                  |
| ------------------ | ------------------------------------------------------------------------ |
| `FIRST_USER_ADMIN` | Set to `1` to make the first profile on a new instance an admin.         |
| `ADMIN_UIDS`       | Account IDs of more admins, separated by commas.                         |
| `INVITE_ONLY`      | Set to `1` to require an invite code for new profiles.                   |
| `ALLOW_GUEST`      | Set to `0` to remove the "Continue without account" button.              |
| `PASSWORD_LOGIN`   | Set to `1` to allow sign-in with a name and password next to passkeys.   |
| `DEFAULT_LANG`     | Language code of the sign-in screen and of new profiles, such as `de`.   |
| `RP_NAME`          | Name shown in the passkey prompt.                                        |

Upstream documents more settings, such as the activity log and the session length, in [the self-hosting guide](https://github.com/DuarteSantos8/openGym/blob/main/docs/SELF_HOSTING.md). To use one of them, add it to the `environment` list of the `api` service in `compose.yaml`.

Back up `./opengym-data/`. It holds the accounts, the passkeys, all workouts, and the key that signs sessions.

## Links

- [openGym documentation](https://github.com/DuarteSantos8/openGym/blob/main/docs/SELF_HOSTING.md)
- [openGym source code](https://github.com/DuarteSantos8/openGym)
