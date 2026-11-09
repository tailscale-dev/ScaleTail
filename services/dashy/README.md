# Dashy

[Dashy](https://dashy.to/) is a start page for your services, with status checks, widgets, themes, and an editor in the web interface. It stores its settings in one YAML file.

This stack runs Dashy with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                    |
| ------------- | ------------------------------------------------------------------------ |
| Web interface | `https://dashy.<tailnet>.ts.net`                                         |
| Service port  | `8080`                                                                   |
| Image         | `lissy93/dashy:latest`                                                   |
| Data          | `./dashy-data/user-data/` (`conf.yml`, backups, and your own assets)     |

## Before you start

- **Owner of the folder.** Dashy runs as user `1000`. To save changes from the web interface, that user must own `./dashy-data/user-data`. Otherwise Dashy still shows the dashboard, but saving fails with `EACCES: permission denied`. If your user is not `1000`, run:

  ```bash
  sudo chown -R 1000:1000 dashy-data/user-data
  ```

- **Second copy.** The configuration file lives in `./dashy-data`. When you change `SERVICE`, rename that folder to `<SERVICE>-data` as well, or Dashy starts without a configuration file.

## Deviations from the standard setup

- **Tracked configuration file.** The repository includes `./dashy-data/user-data/conf.yml`, with an exception in `.gitignore`, because Dashy needs `conf.yml` and does not create one.

## First run

Nothing to set up. Open the web interface. To add your services, edit `./dashy-data/user-data/conf.yml`, or use the configuration editor in the web interface. Each save from the web interface keeps a copy of the previous file in `./dashy-data/user-data/config-backups`.

## Configuration

- **Your services.** See [Configuring](https://dashy.to/docs/configuring) for the options, and [Widgets](https://dashy.to/docs/widgets) and [Status indicators](https://dashy.to/docs/status-indicators) for live data.
- **Who can edit.** Without [authentication](https://dashy.to/docs/authentication), everyone who can open the dashboard can also change and save its configuration. Set up authentication, or restrict access to the device in your Tailnet policy.

## Links

- [Dashy documentation](https://dashy.to/docs)
- [Dashy source code](https://github.com/lissy93/dashy)
- [Dashy on Docker Hub](https://hub.docker.com/r/lissy93/dashy)
