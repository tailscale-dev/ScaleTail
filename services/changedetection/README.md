# changedetection.io

[changedetection.io](https://github.com/dgtlmoon/changedetection.io) watches web pages and notifies you when their content changes, for example for price drops, restocks, or updated documents.

This stack runs changedetection.io with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                      |
| ------------- | ------------------------------------------ |
| Web interface | `https://changedetection.<tailnet>.ts.net` |
| Service port  | `5000`                                     |
| Image         | `ghcr.io/dgtlmoon/changedetection.io`      |
| Data          | `./changedetection-data/datastore`         |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

changedetection.io has no password by default. Open the web interface and add the first page to watch. To require a password, set one under **Settings**.

## Links

- [changedetection.io documentation](https://github.com/dgtlmoon/changedetection.io/wiki)
- [changedetection.io source code](https://github.com/dgtlmoon/changedetection.io)
