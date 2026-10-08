# Plex

[Plex Media Server](https://www.plex.tv/) organises your movies, series, and music and streams them to the Plex apps on your devices.

This stack runs Plex with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                |
| ------------- | ---------------------------------------------------- |
| Web interface | `https://plex.<tailnet>.ts.net/web`                  |
| Service port  | `32400`                                              |
| Image         | `lscr.io/linuxserver/plex`                           |
| Data          | `./plex-data/config` (library database and settings) |
|               | `./plex-data/media/movies` (movie library)           |
|               | `./plex-data/media/tvseries` (series library)        |

## Before you start

- **Claim token.** Get a token at <https://plex.tv/claim> and add it to `PLEX_CLAIM=` in `compose.yaml`. The token expires after four minutes, so start the stack right away. Without it, the server starts unclaimed and is not linked to your Plex account.
- **Media folders.** Point the `/movies` and `/tv` volumes in `compose.yaml` at your own media folders. Otherwise the stack starts with empty folders in `./plex-data/media`.

## Deviations from the standard setup

- **Web interface path.** The web interface is at `/web`. The root path `/` answers with server information in XML.
- **No host networking.** The image documentation recommends host networking. This stack uses the network of the `tailscale` container and publishes no ports, so devices that are not on your Tailnet cannot reach Plex.

## First run

Open the web interface and sign in with your Plex account. Then add your libraries with `/movies` and `/tv` as folders.

## Links

- [Plex support](https://support.plex.tv/)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-plex/)
