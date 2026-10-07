# NextExplorer

[NextExplorer](https://github.com/nxzai/NextExplorer) is a file explorer for your server. You browse, upload, download, and edit the files of a folder in your browser.

This stack runs NextExplorer with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                     |
| ------------- | ------------------------------------------------------------------------- |
| Web interface | `https://file-explorer.<tailnet>.ts.net`                                  |
| Service port  | `3000`                                                                    |
| Image         | `nxzai/explorer`                                                          |
| Data          | `./config` (configuration and database)                                   |
|               | `./cache` (thumbnails and unfinished uploads)                             |
|               | The folder from `ACCESS_PATH` (your files, `/mnt/Files` in the container) |

## Before you start

Set these values in `.env`:

- **`ACCESS_PATH`.** The absolute path of the folder on the Docker host that NextExplorer should show.
- **`SESSION_SECRET`.** A long random value. Generate one with `openssl rand -base64 32`.
- **`PUBLIC_URL`.** The address of the web interface, `https://file-explorer.<tailnet>.ts.net`. NextExplorer uses it for its cookies, so use this address to open the web interface.

## Deviations from the standard setup

- **Device name.** `SERVICE` in `.env` is `file-explorer`, which differs from the name of this directory.
- **Shared configuration folder.** NextExplorer stores its configuration in `./config`, the folder that also holds the Tailscale configuration files.
- **Data folders.** The data is in `./config` and `./cache`, not in a `./file-explorer-data` folder.
- **User and group.** `PUID` and `PGID` come from `.env`.

## First run

Open the web interface. NextExplorer asks you to create the first account.

## Links

- [NextExplorer documentation and source code](https://github.com/nxzai/NextExplorer)
