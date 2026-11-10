# Gotify

[Gotify](https://gotify.net/) is a push notification server. Scripts post over HTTP, and the web interface and Android app show the messages.

This stack runs Gotify with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                         |
| ------------- | ------------------------------------------------------------- |
| Web interface | `https://gotify.<tailnet>.ts.net`                             |
| Service port  | `80`                                                          |
| Image         | `gotify/server`                                               |
| Data          | `./gotify-data/app/data`                                      |
| iGotify image | `ghcr.io/androidseb25/igotify-notification-assist` (optional) |
| iGotify data  | `./gotify-data/igotify` (optional)                            |

## Before you start

Set `GOTIFY_DEFAULTUSER_PASS` in `.env`. It is the password of the user `admin` that Gotify creates at the first start. Compose stops with an error if it is empty.

## Deviations from the standard setup

- **Optional iGotify container.** The Compose service `igotify` (container `app-gotify-igotify`) only runs when the `igotify` profile is active. It shares the network of the Tailscale sidecar, like the application, and stores its data in `./gotify-data/igotify`. See [iGotify for iPhone and iPad](#igotify-for-iphone-and-ipad).
- **iGotify port.** iGotify listens on port `8080` for its API and device pages. Tailscale Serve does not publish it, but it is reachable at the Tailscale IP address of the device when your Tailnet policy allows it.

## First run

Open the web interface and log in with username `admin` and the password from `GOTIFY_DEFAULTUSER_PASS`. Gotify uses this value only at the first start, so change the password in the web interface afterwards.

In the Gotify app, use `https://gotify.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Configuration

### iGotify for iPhone and iPad

Gotify has no iOS app. [iGotify](https://github.com/androidseb25/iGotify-Notification-Assistent) fills that gap: the optional `igotify` container listens to Gotify and forwards each message to the iGotify app on your iPhone or iPad.

Notifications leave your Tailnet on this route. iGotify encrypts each message and sends it over HTTPS to the SecNtfy relay of its author, which hands it to Apple's push service. Skip this section when you do not want that.

The stack uses the "local instance" mode of iGotify, so Gotify stays reachable only through your Tailnet. In this mode the app talks to Gotify directly, and the images of apps and contacts do not show in the iGotify app.

1. Start the stack as usual and install the [iGotify app](https://apps.apple.com/app/igotify/id6473452512) on a device that is connected to your Tailnet.
2. In the app, enter `https://gotify.<tailnet>.ts.net`, turn on the Local Instance toggle, and log in with your Gotify account. The app then shows three values: the Gotify URL, the Gotify client token, and the SecNtfy token.
3. In `.env`, set `COMPOSE_PROFILES=igotify`, and fill in `GOTIFY_CLIENT_TOKENS` and `SECNTFY_TOKENS` with the values from the app. Keep `GOTIFY_URLS=http://127.0.0.1:80` instead of the URL that the app shows: the iGotify container shares the network of the Tailscale sidecar and cannot resolve the MagicDNS name, but it reaches Gotify on the loopback address. The three values go together: if one is missing, the connection fails.
4. Apply the change with `docker compose up -d`.

The two tokens are secrets, so keep them out of anything you publish. Keep `COMPOSE_PROFILES=igotify` in `.env` as long as you use iGotify: without it, `docker compose down` and `docker compose pull` skip the `igotify` container.

To stop using iGotify, run `docker compose --profile igotify down`, empty `COMPOSE_PROFILES` in `.env`, and run `docker compose up -d`. A plain `docker compose down` leaves the `igotify` container behind once the profile is no longer active.

## Upgrading

Earlier versions of this stack set `GOTIFY_DEFAULTUSER_PASS=admin` in `compose.yaml`. The value is now empty in `.env`, and Compose stops with an error until you set it. Gotify reads it only at the first start, so a new value does not change the password of an existing installation. If you still log in as `admin` with the password `admin`, change the password in the web interface.

## Links

- [Gotify documentation](https://gotify.net/docs/)
- [Gotify source code](https://github.com/gotify/server)
- [iGotify documentation](https://github.com/androidseb25/iGotify-Notification-Assistent/wiki)
- [iGotify source code](https://github.com/androidseb25/iGotify-Notification-Assistent)
