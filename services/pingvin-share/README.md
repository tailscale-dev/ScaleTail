# Pingvin Share

[Pingvin Share](https://github.com/stonith404/pingvin-share) is a file sharing platform. You upload files and share them with a link that can expire.

Upstream archived the project on June 29, 2025, so it gets no further updates. Its author points to the maintained fork Pingvin Share X.

This stack runs Pingvin Share with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://pingvin-share.<tailnet>.ts.net`                  |
| Service port  | `3000`                                                    |
| Image         | `stonith404/pingvin-share`                                |
| Data          | `./pingvin-share-data/data` (database and uploaded files) |
|               | `./pingvin-share-data/images` (logo and icons)            |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and sign up. The first account becomes the administrator. Registration stays open for everyone who can reach the device on your Tailnet, until you disable it in the administration settings.

## Links

- [Pingvin Share source code](https://github.com/stonith404/pingvin-share)
