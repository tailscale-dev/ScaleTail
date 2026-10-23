# AudioMuse-AI

[AudioMuse-AI](https://github.com/NeptuneHub/AudioMuse-AI) analyzes the audio of your music library and builds similar-song lists and playlists from the sound of each track. It works with Navidrome, Jellyfin, Emby, Lyrion, and Plex, and needs a media server that already holds your music.

This stack runs AudioMuse-AI with a Tailscale sidecar, as described in [the standard setup](https://github.com/tailscale-dev/ScaleTail/blob/main/documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| Web interface | `https://audiomuse-ai.<tailnet>.ts.net`                                                                            |
| Service port  | `8000`                                                                                                             |
| Images        | `ghcr.io/neptunehub/audiomuse-ai:3.6.3`                                                                            |
|               | `postgres:15-alpine`                                                                                               |
| Data          | `./audiomuse-ai-data/db` (PostgreSQL database)                                                                     |
|               | `./audiomuse-ai-data/app` and `./audiomuse-ai-data/worker` (temporary audio files, installed plugins, and backups) |

## Before you start

- **A media server.** AudioMuse-AI reads your library from Navidrome, Jellyfin, Emby, Lyrion, or Plex. Set one up first.
- **Hardware.** Upstream asks for a 4-core Intel CPU with AVX2 or an ARM CPU, 8 GB of RAM, and an SSD. On a virtual machine, pass the host CPU through, because the default virtual CPU lacks AVX2 and the application does not start. The amd64 image is about 7 GB.
- **`POSTGRES_PASSWORD`.** Set the database password in `.env`. Compose stops with an error until you do. Generate one with `openssl rand -hex 32`. PostgreSQL applies it only when it first creates the database.

## Deviations from the standard setup

- **Extra containers.** Besides the `application` container, which runs the web interface, the stack runs a `worker` container and a `db` container. The worker runs the analysis and clustering jobs that the web interface queues in the database. Both containers use the network of the `tailscale` container, so they reach the database at `127.0.0.1`, and the worker reaches your media server in the same way as the web interface does. The worker needs no health endpoint of its own: its check looks for the queue worker process.
- **Database.** PostgreSQL listens only on the loopback address of the device, so other devices on your Tailnet cannot reach it. Upstream publishes port `5432` on the host in its example, and this stack does not. The stack pins PostgreSQL to version 15, because upstream states that it is designed for that version and that other versions can cause errors.
- **Pinned version.** The image tag is an exact version, as upstream recommends for most users. The web interface, the worker, and the media server plugin must be updated together, so one `IMAGE_URL` in `.env` sets the image of both containers.
- **Data folders.** Upstream uses named Docker volumes and keeps backups made in the web interface inside the container. The stack uses folders under `./audiomuse-ai-data/` instead, and maps the backup folder `/app/backup` as well, so that all data stays next to `compose.yaml` and backups survive an update.

## First run

1. Open the web interface. The setup wizard opens on a clean installation. Complete it right away: until you save it, anyone on your Tailnet can open the wizard and create the administrator account.
2. Choose your media server type, and enter its address and credentials. The address must work from inside the stack:
   - **Media server on your Tailnet.** Use its Tailscale IP address, for example `http://100.x.y.z:4533`. The containers resolve names through Docker's DNS, so they cannot resolve MagicDNS names. To use MagicDNS names instead, uncomment `TS_ACCEPT_DNS=true` in `compose.yaml`. That is safe in this stack, because the containers reach each other at `127.0.0.1` and not by their Compose service names.
   - **Media server on your local network.** Use its local address.
3. Set the user name and password for AudioMuse-AI itself. Login is enabled by default. AudioMuse-AI generates the secret that signs the login sessions at the first start and keeps it in the database, so you stay logged in after a restart.
4. Save the settings. AudioMuse-AI restarts, and the wizard stays available later under Administration, Setup Wizard.
5. Open "Analysis and Clustering" and start an analysis. The first analysis of a large library takes a long time.

If you use an OpenSubsonic server such as LMS, upstream advises to use an API token or API key instead of a password.

## Troubleshooting

- **The application does not start on a virtual machine.** Upstream notes that the default virtual CPU of QEMU, as used by Proxmox, lacks AVX2, which prevents AudioMuse-AI from starting. Pass the host CPU through.
- **The wizard cannot connect to the media server.** Use the Tailscale IP address of the media server and not a MagicDNS name. See "First run".

## Links

- [AudioMuse-AI documentation](https://neptunehub.github.io/AudioMuse-AI/)
- [Deployment guide](https://github.com/NeptuneHub/AudioMuse-AI/blob/main/docs/DEPLOYMENT.md)
- [Navidrome guide](https://github.com/NeptuneHub/AudioMuse-AI/blob/main/docs/NAVIDROME.md)
- [AudioMuse-AI source code](https://github.com/NeptuneHub/AudioMuse-AI)
