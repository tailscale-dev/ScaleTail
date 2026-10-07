# LubeLogger

[LubeLogger](https://lubelogger.com/) tracks the maintenance and fuel use of your vehicles. You log services, repairs, and fill-ups and get reminders for the next ones.

This stack runs LubeLogger with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                          |
| ------------- | -------------------------------------------------------------- |
| Web interface | `https://lubelogger.<tailnet>.ts.net`                          |
| Service port  | `8080`                                                         |
| Image         | `ghcr.io/hargata/lubelogger`                                   |
| Data          | `./lubelogger-data/data` (database and documents)              |
|               | `./lubelogger-data/keys` (keys that protect the login cookies) |

## Before you start

Set `LUBELOGGER_DOMAIN` in `.env` to the name of the device on your Tailnet, `lubelogger.<tailnet>.ts.net`.

## Deviations from the standard setup

- **Device name.** `SERVICE` in `.env` is `lubelogger`, which differs from the name of this directory.
- **The container reads the whole `.env` file.** The `application` container loads `.env` through `env_file`. Every variable in that file, including `TS_AUTHKEY`, is therefore present in its environment.
- **Language settings.** `LC_ALL` and `LANG` in `.env` set the locale, which LubeLogger uses for dates and numbers.

## First run

Open the web interface. LubeLogger has no login by default, so everyone who can reach the device on your Tailnet can see and change your data. To require a login, enable authentication in the settings of LubeLogger.

## Links

- [LubeLogger documentation](https://docs.lubelogger.com/)
- [LubeLogger source code](https://github.com/hargata/lubelog)
