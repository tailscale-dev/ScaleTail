# Radicale

[Radicale](https://radicale.org/) is a small CalDAV and CardDAV server. It synchronises your calendars, to-do lists, and contacts between your devices.

This stack runs Radicale with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                  |
| ------------- | ------------------------------------------------------ |
| Web interface | `https://radicale.<tailnet>.ts.net`                    |
| Service port  | `5232`                                                 |
| Image         | `tomsquest/docker-radicale`                            |
| Data          | `./radicale-data/app/data` (calendars and contacts)    |
|               | `./radicale-data/config/radicale.conf` (configuration) |
|               | `./radicale-data/users` (users and password hashes)    |

## Before you start

Radicale needs its configuration file and its user file before the first start. Run the commands from this directory.

1. Create the configuration folder:

   ```bash
   mkdir -p ./radicale-data/config
   ```

2. Create the user file with your first user. The `htpasswd` tool is in the package `apache2-utils` on Debian and Ubuntu, and in `httpd-tools` on Fedora.

   ```bash
   htpasswd -B -c ./radicale-data/users <username>
   ```

   To add more users later, leave out `-c`, which would overwrite the file:

   ```bash
   htpasswd -B ./radicale-data/users <username>
   ```

3. Create `./radicale-data/config/radicale.conf` with this content:

   ```ini
   [auth]
   type = htpasswd
   htpasswd_filename = /config/users
   htpasswd_encryption = bcrypt

   [storage]
   filesystem_folder = /data/collections
   ```

## Deviations from the standard setup

- **Configuration and user file.** The stack mounts `radicale.conf` and the user file as single files and starts Radicale with that configuration file.
- **File ownership.** `TAKE_FILE_OWNERSHIP=true` makes the image set the owner of the data folder at each start.

## First run

Open the web interface and log in with a user from the user file. Create your calendars and address books there, then add the account to your devices with `https://radicale.<tailnet>.ts.net` as the server address.

## Links

- [Radicale documentation](https://radicale.org/v3.html)
- [tomsquest/docker-radicale image](https://github.com/tomsquest/docker-radicale)
