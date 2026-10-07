# Frigate

[Frigate](https://frigate.video/) is a network video recorder for IP cameras. It detects objects such as people, cars, and animals in real time and can use a GPU or an accelerator for the detection.

This stack runs Frigate with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item           | Value                                                                   |
| -------------- | ----------------------------------------------------------------------- |
| Web interface  | `https://frigate.<tailnet>.ts.net`                                      |
| Service port   | `8971` (HTTPS with a self-signed certificate)                           |
| Camera streams | Ports `8554` (RTSP) and `8555` (WebRTC, TCP and UDP) on the Docker host |
| Image          | `ghcr.io/blakeblackshear/frigate:stable`                                |
| Data           | `./frigate-data/config` (configuration and database)                    |
|                | `./frigate-data/storage` (recordings, clips, and exports)               |

## Before you start

Change `FRIGATE_RTSP_PASSWORD` in `compose.yaml`. The sample value is `password`.

## Deviations from the standard setup

- **Serve forwards to HTTPS.** Frigate serves its authenticated web interface on port `8971` with a self-signed certificate. Tailscale Serve forwards to it with `https+insecure`.
- **Published host ports.** The `ports` block is active. It publishes the restream ports `8554` and `8555` on the Docker host, so that devices in your local network can reach the camera streams without Tailscale.
- **Privileged container.** The `application` container runs with `privileged: true`, so that Frigate can use the hardware of the Docker host for decoding and detection.
- **Shared memory and cache.** The stack gives Frigate 512 MB of shared memory and a 1 GB temporary file system for its cache. Increase the shared memory when you add many cameras.
- **Time zone.** The stack mounts `/etc/localtime` of the Docker host read-only, in addition to `TZ`.

## First run

1. Frigate creates the user `admin` with a random password at the first start. Find it in the log:

   ```bash
   docker logs app-frigate 2>&1 | grep -B1 "Password:"
   ```

2. Open the web interface and log in.
3. Add your cameras in the configuration editor of the web interface. Frigate stores the configuration in `./frigate-data/config/config.yml`.

## Links

- [Frigate documentation](https://docs.frigate.video/)
- [Frigate hardware guide](https://docs.frigate.video/frigate/hardware)
- [Frigate source code](https://github.com/blakeblackshear/frigate)
