# Cozy

[Cozy](https://cozy.io/) (now Twake Workplace) is a self-hosted personal cloud with apps for files, photos, notes, and contacts. The `cozy-stack` server runs the apps, and each app has its own address.

This stack runs Cozy with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). Because Cozy serves every app on its own host name, it adds one extra Tailnet device per app.

## At a glance

| Item          | Value                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| Web interface | `https://cozy.<tailnet>.ts.net` (login and API)                                                                    |
| Apps          | `https://cozy-home.<tailnet>.ts.net`, `-settings`, and `-drive`, each its own device                               |
| Service port  | `8080`                                                                                                             |
| Images        | `cozy/cozy-stack`                                                                                                  |
|               | `couchdb:3.3`                                                                                                      |
| Data          | `./cozy-data/app/etc` (admin passphrase hash and keys), `./cozy-data/app/data` (files), `./cozy-data/db` (CouchDB) |

## Before you start

Set these values in `.env`:

- **`SERVICE`.** Keep letters and digits only, with no hyphen. Cozy joins the instance name and the app name with a hyphen, so `my-cozy` is rejected as an instance name.
- **`TS_AUTHKEY`.** The stack starts four Tailnet devices with this key. Use a reusable key, because a single-use key only lets the first device join.
- **`COUCHDB_PASSWORD`.** The password of the database. Use letters and digits only, because it is part of an address. Compose stops with an error until it is set.
- **`COZY_ADMIN_PASSPHRASE`.** The passphrase for the `cozy-stack` command line. The image stores its hash at the first start. Compose stops with an error until it is set.

Remove any old devices called `cozy`, `cozy-home`, `cozy-settings`, or `cozy-drive` from the [Tailscale admin console](https://login.tailscale.com/admin/machines) first. A device that is still listed makes Tailscale name the new one `cozy-1`, and the addresses below stop matching.

## Deviations from the standard setup

- **One device per app.** `cozy-stack` serves every app at `<SERVICE>-<app>.<tailnet>.ts.net` (the `flat` subdomain layout, set in the `cozy-config` entry of `compose.yaml`), and Tailscale Serve publishes one name per device. The stack therefore runs the `tailscale-home`, `tailscale-settings`, and `tailscale-drive` containers next to `tailscale`, each with its own device and its own state folder `./ts/state-<app>`. They have no `./config` folder, because their Serve configuration needs no file on the host. They forward to `cozy-stack` in the network of the `tailscale` container. Tailscale Serve keeps the `Host` header, which is how `cozy-stack` picks the app.
- **Extra container.** The `couchdb` container (`app-<service>-db`) runs the CouchDB database. It stays on the Compose network and joins neither the Tailnet nor the network of the `tailscale` container. The stack reaches it by the name `couchdb`.
- **Configuration file.** `compose.yaml` writes the `cozy-stack` configuration to `/etc/cozy/cozy.yml` with a `configs` entry. It is the configuration of the upstream Compose repository, except that the administration port `6060` listens on the loopback address only, so your Tailnet cannot reach it.
- **Port 8080 on the Tailnet.** `cozy-stack` listens on all addresses of the `tailscale` container, so the sibling devices can reach it. The port is also reachable at the Tailscale IP address of the device when your Tailnet policy allows it, but `cozy-stack` needs a valid instance name in the `Host` header to answer.
- **No mail server.** The configuration has no mail relay, and the embedded Postfix is off. Cozy cannot send e-mail, for example for sharing invitations and password resets.
- **Health check.** `cozy-stack` calls its own `/status` endpoint with `curl`. CouchDB calls its `/_up` endpoint with `curl`. Neither image defines a check.

## First run

Create your instance with the `cozy-stack` command line. Replace `<tailnet>.ts.net` with your [Tailnet DNS name](https://tailscale.com/kb/1217/tailnet-name), and use your own e-mail address, language, and time zone. The instance name must be `<SERVICE>.<tailnet>.ts.net`, the address of the main device:

```sh
docker exec app-cozy cozy-stack instances add \
  --apps home,settings,drive \
  --email you@example.com \
  --locale en \
  --tz Europe/Amsterdam \
  cozy.<tailnet>.ts.net
```

The command prints a link that ends in `?registerToken=...`. Open it in a browser on a device that is on your Tailnet, and choose your password. The first request can take up to a minute while Tailscale requests the certificates of the devices. Then open the apps at the addresses in the table above.

## Configuration

To use another app, such as `photos` or `notes`, give it a device and install it:

1. Copy the `tailscale-drive` block in `compose.yaml` and rename it to `tailscale-<app>`. Change `container_name`, `hostname`, and the state folder to match, then run `docker compose up -d`.
2. Install the app: `docker exec app-cozy cozy-stack apps install --domain cozy.<tailnet>.ts.net <app>`.

## Troubleshooting

- **A device is named `cozy-1`.** An older device with the same name is still in your Tailnet. Remove it in the admin console, delete the `./ts/state*` folders, and start the stack again.
- **`Domain name contains illegal characters`.** The instance name has a hyphen in its first part. Use a `SERVICE` without a hyphen.
- **The browser shows a certificate error on the first visit.** Wait up to a minute for each device and reload the page. Each of the four devices requests its own certificate.
- **The certificate error stays, and the Tailscale log shows `rateLimited`.** Let's Encrypt limits new registrations to 10 per 3 hours for each IP address, and every device that starts without `./ts/state*` uses one, so this stack uses four. Keep the `./ts/state*` folders when you recreate the stack, and retry at the time the log gives.

## Links

- [Cozy self-hosting documentation](https://docs.cozy.io/en/tutorials/selfhosting/docker/)
- [cozy-stack documentation](https://docs.cozy.io/en/cozy-stack/)
- [cozy-stack source code](https://github.com/cozy/cozy-stack)
- [cozy-stack Docker Compose repository](https://github.com/cozy/cozy-stack-compose)
