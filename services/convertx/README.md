# ConvertX

[ConvertX](https://github.com/C4illin/ConvertX) is a file converter that runs in your browser. It converts documents, images, audio, video, and many other formats on your own server.

This stack runs ConvertX with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://convertx.<tailnet>.ts.net` |
| Service port  | `3000`                              |
| Image         | `ghcr.io/c4illin/convertx`          |
| Data          | `./convertx-data`                   |

## Before you start

Set `JWT_SECRET` in `.env` to a long random value. Generate one with `openssl rand -hex 32`. ConvertX uses it to sign the login tokens, and Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface. ConvertX sends you to the setup page, where you create your account. Do this right after the first start, because anyone who can reach the service can register the first account. After that, registration is closed.

## Upgrading

Earlier versions of this stack had a sample value for `JWT_SECRET` in `compose.yaml`. It is now empty in `.env`, and you must set it. With a new value, everyone has to log in again.

## Links

- [ConvertX documentation and source code](https://github.com/C4illin/ConvertX)
