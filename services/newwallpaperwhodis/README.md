# NewWallpaperWhoDis

[NewWallpaperWhoDis](https://newwallpaperwhodis.web.app/) is a wallpaper server. It turns browsers, tablets, smart TVs, and dashboards into displays that rotate through your wallpaper collection, and you manage the collection as plain files.

This stack runs NewWallpaperWhoDis with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://newwallpaperwhodis.<tailnet>.ts.net` |
| Service port  | `3000`                                        |
| Image         | `ghcr.io/upioneer/newwallpaperwhodis`         |
| Data          | `./wallpapers` (your wallpaper files)         |
|               | `./data` (settings and metadata)              |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Image is set in `compose.yaml`.** The stack does not use `IMAGE_URL`.
- **Data folders.** The data is in `./data` and `./wallpapers`, not in a `./newwallpaperwhodis-data` folder.
- **Service port.** The application listens on port `3000`. `SERVICEPORT` in `.env` is only the host port of the optional `ports` block.

## First run

1. Put your wallpapers in `./wallpapers`.
2. Open the web interface to manage the collection and the rotation profiles.
3. On each display device, open the player address from the web interface in a browser. You then control what the device shows from the web interface.

## Links

- [NewWallpaperWhoDis website](https://newwallpaperwhodis.web.app/)
- [NewWallpaperWhoDis source code](https://github.com/upioneer/NewWallpaperWhoDis)
