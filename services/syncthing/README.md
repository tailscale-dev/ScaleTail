# SERVICE with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Syncthing](https://github.com/syncthing/syncthing) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## SERVICE

[Syncthing](https://github.com/syncthing/syncthing) Syncthing is a continuous file synchronization program that safely and privately synchronizes files between two or more computers. All communication is secured using TLS. The encryption used includes perfect forward secrecy, and every devices is identified by a strong cryptographic key.  Networking between machines is handled via automatic discovery, and can be configured to use public relay servers to connect to registered nodes.

This application is highly configurable on what you want to sync, which devices you want to sync with, and how you want to sync that data.  It is highly recommended that you review the [Documentation](https://docs.syncthing.net/v2.0.0/users/index.html).

In this setup, the `tailscale-Syncthing` service runs Tailscale, which manages secure networking for SERVICE. The `Syncthing` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the configuration web pp Tailnet-only.

## Configuration Overview

### Initial setup

By default there is no login credentials to access the Syncthing web application. You will be prompted to set this up when launching the Web App for the first time. You can optionally enable TLS with the web app at your own discretion, which will use a generated self-signed certificate.

Syncthing uses global relaying / discovery servers to attempt to do something similar to how tailscale works. While this is secure due to strong encryption, you can disable this behavior and rely on tailscale.  Under Actions > Settings > Connections, disable 'Enable Relaying' / 'Global Discovery' / 'Enable NAT traversal'.

### Device setup
Once the container is deployed, you use the web app to connect devices to each other in a mesh network.  This is usually handled by mDNS on the local subnet. Each device has a "Sync Protocol Listen Address" which by default is set to 'dynamic'.  This will probe for the the device and sync over all of the available local lan segments.  Opening the local ports 22000 / 21027 allows this behavior to happen.

To allow sync over the tailnet you need to edit the settings for each device.  Go to Actions > Settings > Connections.  Sync Protocol Listen addresses is a comma separated address.  Add an additional addresss of `tcp://tailnetIp:22000` where tailnetIp is the tailnet ip of the device you are configuring.

If you are not initially using LAN discovery to create your mesh network, you will need to manually add devices to your Syncthing network.  Each device has a unique identifier that you will need in order to connect, this can be found under Actions > Show Id.  On the local device click 'Add Remote Device', enter the remote device Id and a friendly name for the device.  Under the advanced tab there add another address of `tcp://tailnetIp:22000` where tailnetIp is the tailnet Ip of the remote device.

### Shared folders
There is a singe volume mounted that will be mapped to /var/syncthing, which is also the home directory that folders shared from other devices will be stored in by default. This directory also contains a hidden directory (.syncthinghome) which contains all of the configuration for this node, including remote devices.