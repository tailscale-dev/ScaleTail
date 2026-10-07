# Node-RED

[Node-RED](https://nodered.org/) is a low-code tool for event-driven applications. You connect devices, APIs, and online services by wiring nodes together in a flow editor in your browser.

This stack runs Node-RED with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                              |
| ------------- | ------------------------------------------------------------------ |
| Web interface | `https://nodered.<tailnet>.ts.net`                                 |
| Service port  | `1880`                                                             |
| Image         | `nodered/node-red`                                                 |
| Data          | `./nodered-data/app/config` (flows, settings, and installed nodes) |

## Before you start

Create the data folder yourself and make user `1000` its owner. Docker creates missing folders as user `root`. The Node-RED image runs as user and group `1000`, and it then exits with `EACCES` when it copies `settings.js` into `/data`.

```bash
mkdir -p nodered-data/app/config
sudo chown -R 1000:1000 nodered-data
```

## Deviations from the standard setup

None.

## First run

Open the web interface. The flow editor has no login by default, so everyone who can reach the device on your Tailnet can change your flows. See [Securing Node-RED](https://nodered.org/docs/user-guide/runtime/securing-node-red) to add one.

## Links

- [Node-RED documentation](https://nodered.org/docs/)
- [Node-RED in Docker](https://nodered.org/docs/getting-started/docker)
- [Node-RED source code](https://github.com/node-red/node-red)
