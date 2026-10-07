# FossFLOW

[FossFLOW](https://hub.docker.com/r/stnsmith/fossflow) is a tool to draw isometric diagrams, for example of infrastructure and workflows. It only visualises a flow and does not run it.

The original repository of the project is no longer available on GitHub. [Abrar74774/FossFLOW](https://github.com/Abrar74774/FossFLOW) continues it.

This stack runs FossFLOW with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://fossflow.<tailnet>.ts.net` |
| Service port  | `80`                                |
| Image         | `stnsmith/fossflow`                 |
| Data          | None on the host                    |

## Before you start

Set `PUBLIC_URL` in `compose.yaml` to the address of the web interface, `https://fossflow.<tailnet>.ts.net`.

## Deviations from the standard setup

- **Diagrams are not stored on the host.** FossFLOW saves diagrams on the server in `/data/diagrams` in the container, which this stack does not mount. They are lost when the container is recreated, for example after an image update. Export the diagrams that you want to keep.

## First run

Nothing to set up. Open the web interface.

## Links

- [FossFLOW image on Docker Hub](https://hub.docker.com/r/stnsmith/fossflow)
- [FossFLOW continuation, documentation and source code](https://github.com/Abrar74774/FossFLOW)
