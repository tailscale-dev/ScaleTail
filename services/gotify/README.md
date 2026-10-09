# Gotify

[Gotify](https://gotify.net/) is a server to send and receive notifications. Your scripts and applications post a message over HTTP, and the web interface and the Android app show it in real time.

This stack runs Gotify with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                             |
| ------------- | --------------------------------- |
| Web interface | `https://gotify.<tailnet>.ts.net` |
| Service port  | `80`                              |
| Image         | `gotify/server`                   |
| Data          | `./gotify-data/app/data`          |

## Before you start

Set `GOTIFY_DEFAULTUSER_PASS` in `.env`. It is the password of the user `admin` that Gotify creates at the first start. Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with username `admin` and the password from `GOTIFY_DEFAULTUSER_PASS`. Gotify uses this value only at the first start, so change the password in the web interface afterwards.

In the Gotify app, use `https://gotify.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Upgrading

Earlier versions of this stack set `GOTIFY_DEFAULTUSER_PASS=admin` in `compose.yaml`. The value is now empty in `.env`, and Compose stops with an error until you set it. Gotify reads it only at the first start, so a new value does not change the password of an existing installation. If you still log in as `admin` with the password `admin`, change the password in the web interface.

## Links

- [Gotify documentation](https://gotify.net/docs/)
- [Gotify source code](https://github.com/gotify/server)
