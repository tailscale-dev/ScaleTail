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
- **Change the password.** The `copyparty-config` block in `compose.yaml` creates the account `admin` with the password `changeme`. Replace the password.

## Deviations from the standard setup

- **Configuration in `compose.yaml`.** The `copyparty-config` block is the Copyparty configuration file. It defines the account and gives it read and write access to the shared folder.
- **Fixed user.** The `application` container runs as user and group `1000` through the `user` setting.
- **Shared configuration folder.** Copyparty mounts `./config`, the folder that also holds the Tailscale configuration files.

## First run

Open the web interface and log in with the password from the `copyparty-config` block. Copyparty then shows the files of your folder.

## Links

- [Copyparty documentation and source code](https://github.com/9001/copyparty)
