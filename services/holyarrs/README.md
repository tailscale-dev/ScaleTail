# HolyArrs

[HolyArrs](https://github.com/HolyArrs/HolyArrs) is one app that manages your shows, movies, and music, from requests and downloads to your library.

This stack runs HolyArrs with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://holyarrs.<tailnet>.ts.net` |
| Service port  | `6262`                              |
| Image         | `holyarrs/holyarrs`                 |
| Data          | `./holyarrs-data/`                  |

## Before you start

- **`TAILNET_NAME`.** Set it in `.env` to your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. Compose stops with an error until it is set. `compose.yaml` builds the allowed host name `<SERVICE>.<TAILNET_NAME>.ts.net` from it.
- **Data folder.** HolyArrs expects one folder with your downloads and your media, mounted at `/data`, so that a finished download reaches your library as a hardlink or a move instead of a copy. Point the `/data` volume in `compose.yaml` at that folder on the host, and mount it at `/data` in your download client too. Without a change, it is the empty folder `./holyarrs-data/data`.
- **Folder owner.** HolyArrs runs as user and group `1000` and does not change the owner of the data folder. Docker creates a missing folder as `root`. Create the folders before the first start and give them to `1000`, for example with `mkdir -p holyarrs-data/data/downloads holyarrs-data/data/media/movies holyarrs-data/data/media/tv holyarrs-data/data/media/music` and `sudo chown -R 1000:1000 holyarrs-data/data`. HolyArrs refuses a Library folder that does not exist.
- **Local disk.** Keep `./holyarrs-data/app/config` on a local disk. HolyArrs refuses a config folder on a network share or in memory, because its databases need working file locks.

## Deviations from the standard setup

- **Allowed host name.** `HOLYARRS_ALLOWED_HOSTS` in `compose.yaml` holds the Tailnet address of the service, built from `SERVICE` and `TAILNET_NAME`. HolyArrs accepts only IP addresses, `localhost`, and the host names it knows. Without this value it answers `403 Forbidden` to every save made through `https://holyarrs.<tailnet>.ts.net`, including the creation of the owner account.
- **Trusted proxy.** `HOLYARRS_TRUSTED_PROXIES=127.0.0.1` tells HolyArrs that Tailscale Serve, which forwards from inside the shared network namespace, is a proxy. HolyArrs then trusts its `X-Forwarded-For` and `X-Forwarded-Proto` headers, sets the `Secure` flag on its session cookie, and uses the real client address for sign-in limits and single sign-on.

## First run

Open the web interface and create the owner account right away. HolyArrs has no default password, and whoever opens a new install first becomes the owner. The setup that follows asks where your media is: enter the folders under `/data`, such as `/data/media/movies`, `/data/media/tv`, and `/data/media/music`.

HolyArrs encrypts stored passwords and keys with a master key, which it creates at the first start as `./holyarrs-data/app/config/holyarrs.key`. Backups do not contain this key. Keep a copy somewhere else, for example with **Download key kit** under Settings > Backups.

## Configuration

- **Remote access plugin.** HolyArrs has its own Tailscale plugin for remote access. This stack does not need it: the sidecar already puts HolyArrs on your Tailnet with an auth key, direct connections, and an HTTPS certificate. Do not install the plugin as well. It joins your Tailnet as a second device, signed in through the web interface and always over Tailscale's relays, and its default device name `holyarrs` is the same as the one of this stack.

## Troubleshooting

- **"Saving is blocked because HolyArrs doesn't know the name …".** The address in your browser differs from `HOLYARRS_ALLOWED_HOSTS`. Check that `TAILNET_NAME` holds only your Tailnet name, without `.ts.net`, and that the device is called `holyarrs` in your Tailnet, not `holyarrs-1`. Fix `.env` and run `docker compose up -d --force-recreate`.
- **Checks.** The image has no shell, so `docker exec` runs only HolyArrs' own commands. `docker exec app-holyarrs /holyarrs doctor` checks the config folder, the data folders, the network, and the clock, and says how to fix each problem.

## Links

- [HolyArrs documentation](https://docs.holyarrs.com)
- [Install with Docker](https://docs.holyarrs.com/start/install/)
- [Folders](https://docs.holyarrs.com/start/folders/)
- [Environment variables](https://docs.holyarrs.com/reference/env-vars/)
- [HolyArrs source code](https://github.com/HolyArrs/HolyArrs)
- [HolyArrs on Docker Hub](https://hub.docker.com/r/holyarrs/holyarrs)
