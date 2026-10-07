# FossFLOW

[FossFLOW](https://hub.docker.com/r/stnsmith/fossflow) is a tool to draw isometric diagrams, for example of infrastructure and workflows. It only visualises a flow and does not run it.

The original repository of the project is no longer available on GitHub. [Abrar74774/FossFLOW](https://github.com/Abrar74774/FossFLOW) continues it.

This stack runs FossFLOW with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://fossflow.<tailnet>.ts.net`                       |
| Service port  | `80`                                                      |
| Image         | `stnsmith/fossflow`                                       |
| Data          | `./fossflow-data/diagrams` (diagrams saved on the server) |

## Before you start

Set `PUBLIC_URL` in `compose.yaml` to the address of the web interface, `https://fossflow.<tailnet>.ts.net`.

## Deviations from the standard setup

None.

## First run

Nothing to set up. Open the web interface.

## Upgrading

Earlier versions of this stack had no volume for the diagrams. FossFLOW kept them inside the container, and they were lost when the container was recreated. The stack now stores them in `./fossflow-data/diagrams`.

If you run an earlier version and saved diagrams on the server, copy them to the host before you start the new version:

```bash
mkdir -p fossflow-data/diagrams
docker cp app-fossflow:/data/diagrams/. ./fossflow-data/diagrams/
docker compose up -d
```

## Links

- [FossFLOW image on Docker Hub](https://hub.docker.com/r/stnsmith/fossflow)
- [FossFLOW continuation, documentation and source code](https://github.com/Abrar74774/FossFLOW)
