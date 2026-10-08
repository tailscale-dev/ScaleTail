# Slink

[Slink](https://github.com/andrii-kryvoviaz/slink) is an image sharing platform. You upload images and share them with a link.

This stack runs Slink with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                      |
| ------------- | ------------------------------------------ |
| Web interface | `https://slink.<tailnet>.ts.net`           |
| Service port  | `3000`                                     |
| Image         | `anirdev/slink`                            |
| Data          | `./slink-data/var/data` (application data) |
|               | `./slink-data/images` (uploaded images)    |

## Before you start

Set `ORIGIN` in `compose.yaml` to the address of the web interface, `https://slink.<tailnet>.ts.net`. Slink needs the correct address for its cookies, so the sample value `https://your-domain.com` does not work.

## Deviations from the standard setup

None.

## First run

1. Open `https://slink.<tailnet>.ts.net/profile/signup` and create your account.
2. The stack sets `USER_APPROVAL_REQUIRED=true`, so a new account must be activated first:

   ```bash
   docker exec -it app-slink slink user:activate --email=<user-email>
   ```

3. Make your account an administrator:

   ```bash
   docker exec -it app-slink slink user:grant:role --email=<user-email> ROLE_ADMIN
   ```

## Links

- [Slink documentation](https://docs.slinkapp.io/)
- [Slink source code](https://github.com/andrii-kryvoviaz/slink)
