# Anchor

[Anchor](https://github.com/ZhFahim/anchor) is an offline-first note-taking app that synchronises when a device is back online.

This stack runs Anchor with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://anchor.<tailnet>.ts.net`             |
| Service port  | `3000`                                        |
| Image         | `ghcr.io/zhfahim/anchor`                      |
| Data          | `./anchor-data` (database and uploaded files) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and register the first account.

## Links

- [Anchor documentation and source code](https://github.com/ZhFahim/anchor)
- [Anchor OIDC configuration](https://github.com/ZhFahim/anchor#oidc-authentication)
