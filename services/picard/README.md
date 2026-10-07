# MusicBrainz Picard

[MusicBrainz Picard](https://picard.musicbrainz.org/) is the tag editor of MusicBrainz. It identifies your music files, also by their audio fingerprint, and writes the correct tags and cover art. This stack runs the desktop application in a container and shows it in your browser.

This stack runs MusicBrainz Picard with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                           |
| ------------- | --------------------------------------------------------------- |
| Web interface | `https://picard.<tailnet>.ts.net`                               |
| Service port  | `5800`                                                          |
| Image         | `mikenye/picard`                                                |
| Data          | `./picard-data/config` (Picard settings)                        |
|               | `./picard-data/music` (your music, `/storage` in the container) |

## Before you start

Point the `/storage` volume in `compose.yaml` at the folder with your music. Picard changes and renames the files in that folder. User and group `1000` need write access to it.

## Deviations from the standard setup

- **User and group.** The image uses `USER_ID` and `GROUP_ID` for the user that runs Picard, which `compose.yaml` sets to `1000`.

## First run

Open the web interface. It shows the Picard window and has no login. Add files from `/storage` to start tagging.

## Links

- [MusicBrainz Picard documentation](https://picard-docs.musicbrainz.org/)
- [mikenye/picard image](https://github.com/mikenye/docker-picard)
