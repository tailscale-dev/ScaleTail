# Kavita

[Kavita](https://www.kavitareader.com/) is a digital library for comics, manga, and books. You read in the browser, and Kavita keeps your reading progress in sync between your devices.

This stack runs Kavita with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                                     |
| ------------- | ----------------------------------------------------------------------------------------- |
| Web interface | `https://kavita.<tailnet>.ts.net`                                                         |
| Service port  | `5000`                                                                                    |
| Image         | `jvmilazz0/kavita`                                                                        |
| Data          | `./kavita-data/config` (configuration and database)                                       |
|               | `./kavita-data/manga`, `./kavita-data/comics`, and `./kavita-data/books` (your libraries) |

## Before you start

To use an existing collection, point the `/manga`, `/comics`, and `/books` volumes in `compose.yaml` at your own folders. Otherwise the stack starts with empty folders in `./kavita-data`.

## Deviations from the standard setup

None.

## First run

Open the web interface and create the administrator account. Then add a library for each of the folders `/manga`, `/comics`, and `/books`.

## Links

- [Kavita documentation](https://wiki.kavitareader.com/)
- [Kavita source code](https://github.com/Kareadita/Kavita)
