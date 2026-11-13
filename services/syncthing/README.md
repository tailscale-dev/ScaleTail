# Syncthing

[Syncthing](https://syncthing.net/) syncs folders between your devices, peer to peer, without a central server. Each device keeps a full copy of the folders it shares.

This stack runs Syncthing with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                  |
| ------------- | ---------------------------------------------------------------------- |
| Web interface | `https://syncthing.<tailnet>.ts.net`                                   |
| Service port  | `8384`                                                                 |
| Sync port     | `22000` TCP and UDP, at the Tailscale IP address of the device         |
| Image         | `syncthing/syncthing:latest`                                           |
| Data          | `./syncthing-data/` (configuration in `config`, and your synced folders) |

## Before you start

- **Owner of the files.** Syncthing runs as user and group `1000`, set by `PUID` and `PGID` in `.env`. Change them to the user that should own the synced files. The image makes that user the owner of `./syncthing-data` at each start, but not of the files inside it or of other folders you mount.

## Deviations from the standard setup

- **No host network.** Upstream recommends `network_mode: host`, so that Syncthing finds other devices on the local network. This stack uses the network of the Tailscale container instead, as every stack in this repository does. Other devices reach this one over your Tailnet. See [Configuration](#configuration).
- **Optional LAN ports.** The commented `ports` block also lists the sync port `22000` and the local discovery port `21027`, for devices on your local network that do not use Tailscale.

## First run

1. Open the web interface.
2. Set a user name and password for the web interface right away, under **Actions** > **Settings** > **GUI**. Until you do, anyone on your Tailnet who can reach the device can use it, also at `http://<tailscale-ip>:8384`. Keep **Use HTTPS for GUI** off: Tailscale Serve already provides HTTPS and forwards to plain HTTP.
3. Note the device ID under **Actions** > **Show ID**. You need it to connect other devices.

## Configuration

**Connect other devices.** Tailscale does not carry the broadcasts that Syncthing uses for local discovery, so Syncthing does not find this device on your Tailnet by itself. It then relies on global discovery, which often ends in a connection through a public relay, and relayed connections are slow.

To sync directly over your Tailnet, add this device on the other device, and under **Advanced** > **Addresses** enter:

```text
tcp://<tailscale-ip>:22000, dynamic
```

Use the Tailscale IP address of this device, which `docker exec tailscale-syncthing tailscale ip -4` shows. The MagicDNS name, such as `tcp://syncthing.<tailnet>.ts.net:22000`, works too on devices that use MagicDNS. Your Tailnet policy must allow port `22000` from the other device.

**Add more folders.** To sync a folder that lives outside `./syncthing-data`, mount it on the `application` service in `compose.yaml`, for example:

```yaml
    volumes:
      - ./${SERVICE}-data:/var/syncthing
      - /path/on/host/photos:/var/syncthing/photos
```

Make the user from `PUID` and `PGID` the owner of that folder, or Syncthing cannot write its `.stfolder` marker and shows the error `folder marker missing`. Then add the folder in the web interface with the path inside the container, such as `/var/syncthing/photos`.

## Links

- [Syncthing documentation](https://docs.syncthing.net/)
- [Syncthing Docker instructions](https://github.com/syncthing/syncthing/blob/main/README-Docker.md)
- [Syncthing source code](https://github.com/syncthing/syncthing)
