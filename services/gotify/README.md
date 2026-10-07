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

Change `GOTIFY_DEFAULTUSER_PASS` in `compose.yaml`. It sets the password of the user `admin` that Gotify creates at the first start, and the sample value is `admin`.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with username `admin` and the password from `GOTIFY_DEFAULTUSER_PASS`. Gotify uses this value only at the first start, so change the password in the web interface afterwards.

In the Gotify app, use `https://gotify.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Links

- [Gotify documentation](https://gotify.net/docs/)
- [Gotify source code](https://github.com/gotify/server)
