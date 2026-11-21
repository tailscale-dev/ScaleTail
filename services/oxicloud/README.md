# OxiCloud

[OxiCloud](https://atalayalabs.github.io/OxiCloud/) A fast self-hosted cloud for files, calendars, contacts, with WebDAV, CalDAV and CardDAV access. 

This stack runs Oxicloud with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                              |
| ------------- | ---------------------------------- |
| Web interface | `https://oxicloud.<tailnet>.ts.net` |
| Service port  | `8086`                             |
| Image         | `diocrafts/oxicloud:latest`        |
| Data          | `./oxicloud-data/`                 |

## Before you start

Add values for the mandatory variables : TAILNET_NAME and POSTRGES_PASSWORD in .env file. Otherwise Compose will stop.
Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

* Additional postgres container for OxiCloud database
* The public adress is built with TAILNET_NAME
* Set OXICLOUD_TRUST_PROXY_CIDR to 127.0.0.1/32 in compose.yaml
* Heath check overriden 
* no WOPI office addon

## First run

OxiCloud shows a setup page to create the first admin account, which stays available until an admin exists.

## Links

- [OxiCloud documentation](https://github.com/AtalayaLabs/OxiCloud)
- [OxiCloud source code](https://github.com/AtalayaLabs/OxiCloud)
