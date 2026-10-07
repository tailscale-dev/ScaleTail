# Tautulli

[Tautulli](https://tautulli.com/) monitors your Plex Media Server. It shows who watches what, keeps a history and statistics, and sends notifications.

This stack runs Tautulli with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://tautulli.<tailnet>.ts.net` |
| Service port  | `8181`                              |
| Image         | `lscr.io/linuxserver/tautulli`      |
| Data          | `./tautulli-data/app/config`        |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface. The setup wizard asks you to:

1. Create a username and password for Tautulli.
2. Sign in with your Plex account.
3. Enter the address of your Plex Media Server. To reach Plex in another stack, see the [DNS section of the standard setup](../../documentation/standard-setup.md#dns). Plex listens on port `32400`.
4. Choose the settings for activity logging and notifications.

## Links

- [Tautulli wiki](https://github.com/Tautulli/Tautulli/wiki)
- [Tautulli source code](https://github.com/Tautulli/Tautulli)
- [LinuxServer.io image documentation](https://docs.linuxserver.io/images/docker-tautulli/)
