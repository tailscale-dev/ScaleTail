# ImageMaid

[ImageMaid](https://github.com/Kometa-Team/ImageMaid) removes unused poster and background images from the metadata folder of a Plex server, for example after you stop using Kometa overlays. It can also clean the photo transcoder cache, empty the trash, clean bundles, and optimize the database.

This stack runs ImageMaid with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                     |
| ------------- | ------------------------------------------------------------------------- |
| Web interface | None                                                                      |
| Image         | `kometateam/imagemaid:latest`                                             |
| Data          | `./imagemaid-data/config` (logs and the copy of the Plex database)        |
|               | `PLEX_DATA_DIR` in `.env` (the Plex data folder, mounted at `/plex`)      |

## Before you start

ImageMaid changes files in the Plex data folder, so it must run on the host that holds that folder.

- **Plex data folder.** `PLEX_DATA_DIR` in `.env` must point to the folder of your Plex server that contains `Cache`, `Metadata`, and `Plug-in Support`. The default is the folder of the [Plex stack](../plex/README.md) in this repository. Change it when Plex runs elsewhere. Compose stops with an error when the folder does not exist.
- **Schedule.** Keep `SCHEDULE` set in `.env`. When it is empty, ImageMaid runs once and exits, and `restart: always` then starts it again at once, over and over.
- **Mode.** `MODE=report` only lists the images that ImageMaid would remove. Check the list in the log, then set `MODE=move` to move them to an `ImageMaid Restore` folder, which you can restore. `MODE=remove` deletes them for good.
- **Plex access.** ImageMaid needs the Plex database to know which images are in use. Set `PLEX_URL` and `PLEX_TOKEN` to download it through the Plex API, or leave both empty to copy it from `PLEX_DATA_DIR`. Upstream recommends restarting Plex and keeping it idle before a copy.

## Deviations from the standard setup

- **No web interface.** The stack has no Tailscale Serve configuration, no `./config` folder, and no `ports` block. ImageMaid only makes outgoing connections: to Plex, and to Discord or Gotify when you set them up.
- **Plex data folder outside the stack.** The Plex data folder is mounted from `PLEX_DATA_DIR` instead of from `./imagemaid-data`, because ImageMaid works on the files of Plex. The mount fails when the folder is missing, so Docker does not create an empty one.
- **Runs as root.** The image has no `user` setting and runs as root, as upstream documents. Files that ImageMaid creates in `./imagemaid-data/config` belong to root.
- **Health check.** The image has no health check and no `pgrep`, so the check looks for the `python3` process, which is ImageMaid.

## First run

1. Start the stack. ImageMaid does not run at once. The log shows the schedule:

   ```bash
   docker compose logs application
   ```

2. To reach Plex over your Tailnet, for example the Plex stack of this repository, set `PLEX_URL` to the Tailscale IP address of the Plex device, such as `http://100.64.0.1:32400`. To use its MagicDNS name instead, uncomment `TS_ACCEPT_DNS=true` in `compose.yaml`, as described in the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).
3. To run ImageMaid right away, in the mode set in `.env`:

   ```bash
   docker exec -e SCHEDULE= app-imagemaid /tini -s python3 /imagemaid.py
   ```

   Stop Kometa and TitleCardMaker first, and run ImageMaid after the Plex scheduled tasks, as upstream advises.

## Configuration

`MODE`, `SCHEDULE`, `PLEX_URL`, and `PLEX_TOKEN` are the only options that `compose.yaml` passes on. ImageMaid reads every other option, such as `PHOTO_TRANSCODER`, `EMPTY_TRASH`, `CLEAN_BUNDLES`, `OPTIMIZE_DB`, `OVERLAYS_ONLY`, `DISCORD`, and the Gotify settings, from a file `.env` in `./imagemaid-data/config`. Environment variables take priority over that file. The [options](https://kometa.wiki/en/latest/kometa/scripts/imagemaid/) are described upstream.

## Links

- [ImageMaid documentation](https://kometa.wiki/en/latest/kometa/scripts/imagemaid/)
- [ImageMaid source code](https://github.com/Kometa-Team/ImageMaid)
- [ImageMaid on Docker Hub](https://hub.docker.com/r/kometateam/imagemaid)
