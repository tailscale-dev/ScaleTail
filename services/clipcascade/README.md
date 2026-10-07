# ClipCascade

[ClipCascade](https://github.com/Sathvik-Rao/ClipCascade) synchronises the clipboard between your devices. What you copy on one device is available on the others.

This stack runs ClipCascade with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://clipcascade.<tailnet>.ts.net`        |
| Service port  | `8080`                                        |
| Image         | `sathvikrao/clipcascade`                      |
| Data          | `./clipcascade-data/cc_users` (user database) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with username `admin` and password `admin123`. Change the password right after you log in.

In the ClipCascade apps, use `https://clipcascade.<tailnet>.ts.net` as the server address. The device must be connected to your Tailnet.

## Configuration

`CC_MAX_MESSAGE_SIZE_IN_MiB` in `compose.yaml` limits the size of a clipboard item. The stack sets it to `1`.

## Links

- [ClipCascade documentation and source code](https://github.com/Sathvik-Rao/ClipCascade)
