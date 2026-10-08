# Recyclarr

[Recyclarr](https://recyclarr.dev/) synchronises the quality profiles and custom formats of the TRaSH Guides to Radarr and Sonarr. You describe the result in a YAML file, and Recyclarr keeps your applications in line with it.

This stack runs Recyclarr with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                          |
| ------------- | -------------------------------------------------------------- |
| Web interface | None                                                           |
| Image         | `ghcr.io/recyclarr/recyclarr:8`                                |
| Data          | `./recyclarr-data/config` (your `recyclarr.yml` and the state) |

## Before you start

Create the configuration folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. The stack runs Recyclarr as user and group `1000`, and it then exits with `Access to the path '/config/state' is denied`.

```bash
mkdir -p recyclarr-data/config
sudo chown -R 1000:1000 recyclarr-data
```

## Deviations from the standard setup

- **No web interface.** The stack has no Tailscale Serve configuration and no `./config` folder. Recyclarr only makes outgoing connections to your applications.
- **Fixed user.** The `application` container runs as user and group `1000` through the `user` setting.
- **Starter configuration.** `RECYCLARR_CREATE_CONFIG=true` makes Recyclarr create a sample `recyclarr.yml` at the first start.

## First run

1. Start the stack once. Recyclarr creates `recyclarr.yml` in `./recyclarr-data/config`.
2. Add the address and API key of Radarr and Sonarr to that file, and choose the profiles to synchronise. To reach an application in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns).
3. Restart the stack. The container then synchronises once a day. To run a sync right away:

   ```bash
   docker compose exec application recyclarr sync
   ```

## Links

- [Recyclarr documentation](https://recyclarr.dev/wiki/)
- [Recyclarr source code](https://github.com/recyclarr/recyclarr)
