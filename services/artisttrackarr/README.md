# ArtistTrackarr

[ArtistTrackarr](https://github.com/crypt0rr/ArtistTrackarr) watches MusicBrainz and, optionally, Spotify for new albums and EPs of the artists that your household follows. It sends notifications for announcements and release days.

This stack runs ArtistTrackarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                             |
| ------------- | ------------------------------------------------- |
| Web interface | `https://artist-trackarr.<tailnet>.ts.net`        |
| Service port  | `8080`                                            |
| Image         | `ghcr.io/crypt0rr/artist-trackarr`                |
| Data          | `./artist-trackarr-data` (database and cover art) |

## Before you start

1. Create the data folder yourself and make user `10001` its owner. Docker creates missing folders as user `root`, and the image runs as user and group `10001`. With the wrong owner, ArtistTrackarr cannot create its database.

   ```bash
   mkdir -p ./artist-trackarr-data
   sudo chown -R 10001:10001 ./artist-trackarr-data
   ```

2. Set these values in `.env`:

   - **`SETUP_TOKEN`, `APP_ENCRYPTION_KEY`, and `SESSION_SECRET`.** Three different random values of at least 32 characters each. Generate each with `openssl rand -hex 32`.
   - **`MUSICBRAINZ_CONTACT`.** A real email address or project address. ArtistTrackarr sends it to MusicBrainz with each request.
   - **`PUBLIC_URL`.** The address of the web interface, `https://artist-trackarr.<tailnet>.ts.net`.

## Deviations from the standard setup

- **Device name.** `SERVICE` in `.env` is `artist-trackarr`, which differs from the name of this directory.
- **Secrets as files.** The stack passes `SETUP_TOKEN`, `APP_ENCRYPTION_KEY`, and `SESSION_SECRET` to the container as Docker secrets, not as environment variables.
- **Reduced privileges.** The `application` container drops all capabilities and sets `no-new-privileges`.

## First run

Open `https://artist-trackarr.<tailnet>.ts.net/setup`, enter the value of `SETUP_TOKEN`, and create the first administrator. After that, the web interface shows the sign-in page.

## Configuration

- **Polling interval.** `POLL_INTERVAL` in `.env` sets how often ArtistTrackarr checks for releases. The default is `6h`, and the application rejects values below one hour.
- **Spotify.** To use Spotify as an additional source, set `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, and a two-letter `SPOTIFY_MARKET`, such as `NL`, in `.env`. You create the client in the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).
- **Client addresses.** Tailscale Serve is the reverse proxy of this stack. Set `TRUST_PROXY=true` in `.env` only if ArtistTrackarr should trust the client addresses that the proxy forwards.
- **Backups.** Stop the stack before you back up `./artist-trackarr-data`, so that the copy of the database is consistent.

## Upgrading

Earlier versions of this stack had sample values for `SETUP_TOKEN`, `APP_ENCRYPTION_KEY`, and `SESSION_SECRET` in `.env`. They are now empty, and ArtistTrackarr stops with `SETUP_TOKEN must be at least 32 characters` until you set them. If you already run the stack, keep the values that you use now.

## Links

- [ArtistTrackarr documentation and source code](https://github.com/crypt0rr/ArtistTrackarr)
- [Shoutrrr documentation](https://containrrr.dev/shoutrrr/), for the notification services
- [MusicBrainz](https://musicbrainz.org/)
