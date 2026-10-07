# Audiobookshelf

[Audiobookshelf](https://www.audiobookshelf.org/) is a server for your audiobooks and podcasts. It streams them to the web player and the mobile apps and keeps your listening progress in sync.

This stack runs Audiobookshelf with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                             |
| ------------- | ----------------------------------------------------------------- |
| Web interface | `https://audiobookshelf.<tailnet>.ts.net`                         |
| Service port  | `80`                                                              |
| Image         | `ghcr.io/advplyr/audiobookshelf`                                  |
| Data          | `./audiobookshelf-data/app/config` (configuration and database)   |
|               | `./audiobookshelf-data/app/metadata` (covers, cache, and backups) |
|               | `./audiobookshelf-data/app/audiobooks` (audiobook library)        |
|               | `./audiobookshelf-data/app/podcasts` (podcast library)            |

## Before you start

To use an existing collection, point the `/audiobooks` and `/podcasts` volumes in `compose.yaml` at your own folders. Otherwise the stack starts with empty folders in `./audiobookshelf-data`.

## Deviations from the standard setup

None.

## First run

Open the web interface and create the root user. Then add a library that points to `/audiobooks` or `/podcasts`.

In the mobile apps, use `https://audiobookshelf.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Links

- [Audiobookshelf documentation](https://www.audiobookshelf.org/docs)
- [Audiobookshelf source code](https://github.com/advplyr/audiobookshelf)
