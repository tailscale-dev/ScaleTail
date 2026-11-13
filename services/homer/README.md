# Homer

[Homer](https://github.com/bastienwirtz/homer) is a static start page for your services, set up in one YAML file. It has groups, links, search, and optional widgets that show the status of some apps.

This stack runs Homer with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                  |
| ------------- | ------------------------------------------------------ |
| Web interface | `https://homer.<tailnet>.ts.net`                       |
| Service port  | `8080`                                                 |
| Image         | `b4bz/homer:latest`                                    |
| Data          | `./homer-data/assets/` (`config.yml` and your icons)   |

## Before you start

Create the assets folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. Homer runs as user `1000` and cannot write to a folder that `root` owns. It then logs `Assets directory not writable, skipping default config install` and has no configuration to show.

```bash
mkdir -p homer-data/assets
sudo chown 1000:1000 homer-data/assets
```

## Deviations from the standard setup

None.

## First run

1. Open the web interface. At the first start, Homer copies an example `config.yml` and its icons to `./homer-data/assets`, and shows the demo dashboard.
2. Edit `./homer-data/assets/config.yml` to add your services. Homer reads the file in the browser, so reload the page to see your changes. No restart is needed.

## Configuration

- **Your services.** See [Configuration](https://github.com/bastienwirtz/homer/blob/main/docs/configuration.md) for the options, and [Custom services](https://github.com/bastienwirtz/homer/blob/main/docs/customservices.md) for widgets that show the status of apps.
- **Tailnet links.** Links open in the browser of the visitor, so the MagicDNS names of your other services work, such as `https://jellyfin.<tailnet>.ts.net`.

## Links

- [Homer documentation](https://github.com/bastienwirtz/homer/tree/main/docs)
- [Homer source code](https://github.com/bastienwirtz/homer)
- [Homer on Docker Hub](https://hub.docker.com/r/b4bz/homer)
