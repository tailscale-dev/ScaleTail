# Tailscale Subnet Router Node Configuration

This Docker Compose configuration sets up a Tailscale Subnet Router Node, allowing devices in your Tailscale network to route their traffic securely through this node to a local subnet. By configuring a Tailscale Router Node, you can extend your local network of device to tailscale connected clients, such as your home or office.

## Tailscale Subnet Router Node

Subnet routers let you extend your Tailscale network (known as a tailnet) to include devices that don't or can't run the Tailscale client. They act as gateways between your tailnet and physical subnets, enabling secure access to legacy devices, entire networks, or services without installing Tailscale everywhere. This capability maintains Tailscale's security model while providing flexibility for complex network environments.

## Configuration Overview

In this setup, the `tailscale` service runs a Tailscale container configures it as a Subnet Router Node.

- **TS_AUTHKEY**: This environment variable in the .env file is where you insert your Tailscale authentication key.
- **SUBNET_ROUTES**: This setting defined in .env file allows the user to set the desired route. More information can be found on the [Tailscale subnet router documents page.](https://tailscale.com/docs/features/subnet-routers)
- **TS_EXTRA_ARGS**: The `--advertise-routes` flag is used to designate this container as a Subnet Router Node within your Tailscale network.
- **Sysctls**: The system controls `net.ipv4.ip_forward` and `net.ipv6.conf.all.forwarding` are enabled to allow IP forwarding, which is necessary for routing traffic through the Exit Node.
- **Network Mode**: The `bridge` network mode is used to create a virtual network interface for the container, enabling it to handle traffic routing.
