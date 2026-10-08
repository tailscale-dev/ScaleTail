# Transmute

[Transmute](https://github.com/transmute-app/transmute) converts and compresses files, such as images, video, audio, and documents. It has a web interface and an API.

This stack runs Transmute with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                |
| ------------- | ------------------------------------ |
| Web interface | `https://transmute.<tailnet>.ts.net` |
| Service port  | `3313`                               |
| Image         | `ghcr.io/transmute-app/transmute`    |
| Data          | `./transmute-data`                   |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and create the first account.

## Configuration

Large conversions need a lot of CPU and memory. Give the Docker host enough of both when you convert video.

## Links

- [Transmute documentation and source code](https://github.com/transmute-app/transmute)
