# Copyparty

[Copyparty](https://github.com/9001/copyparty) is a file server. You upload, download, and share the files of a folder in your browser, and it also offers protocols such as WebDAV.

This stack runs Copyparty with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                |
| ------------- | -------------------------------------------------------------------- |
| Web interface | `https://copyparty.<tailnet>.ts.net`                                 |
| Service port  | `3923`                                                               |
| Image         | `copyparty/ac`                                                       |
| Data          | The folder that you mount at `/w` (your files)                       |
|               | `./config` (Copyparty configuration folder, `/cfg` in the container) |

## Before you start

- **Choose the folder to share.** Replace `/path/to/your/fileshare/top/folder` in `compose.yaml` with the absolute path of a folder on the Docker host. User `1000` needs write access to it.
- **Set the password.** Set `COPYPARTY_PASSWORD` in `.env` to the password of the account `admin`. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty. Use letters and digits only: Copyparty reads the password from one line of its configuration file, and it cuts a line at a `#` that follows two spaces.

## Deviations from the standard setup

- **Configuration in `compose.yaml`.** The `copyparty-config` block is the Copyparty configuration file. It defines the account and gives it read and write access to the shared folder.
- **Fixed user.** The `application` container runs as user and group `1000` through the `user` setting.
- **Shared configuration folder.** Copyparty mounts `./config`, the folder that also holds the Tailscale configuration files.

## First run

Open the web interface and log in as `admin` with the value of `COPYPARTY_PASSWORD` in `.env`. Copyparty then shows the files of your folder.

## Upgrading

Earlier versions of this stack created the account `admin` with the password `changeme` in `compose.yaml`. The password is now in `.env`, and Compose stops with an error until you set `COPYPARTY_PASSWORD`. If you changed the password in `compose.yaml`, move it to `.env`. If you kept `changeme`, set `COPYPARTY_PASSWORD=changeme` to keep the same login, or choose a new password. Then restart the stack.

## Links

- [Copyparty documentation and source code](https://github.com/9001/copyparty)
