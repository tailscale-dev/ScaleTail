# Tailscale App Connector Node Configuration

This Docker Compose configuration sets up a Tailscale an App Connector Node, allowing devices in your Tailscale network to route their traffic securely through this node to internet services.

## Tailscale App Connector Node

App connectors let you route Tailscale network (known as a tailnet) traffic to your software as a service (SaaS), cloud, and self-hosted applications, letting users and devices on the tailnet access applications by domain names instead of IP addresses. You can also incorporate monitoring, optimization, security, and reliability into your app connector setup. [See the App Connector documents for more information:](https://tailscale.com/docs/features/app-connectors/how-to/setup)

## Configuration Overview

In this setup, the `tailscale` service runs a Tailscale container configures it as an App Connector Node.

- **TS_AUTHKEY**: This environment variable in the .env file is where you insert your Tailscale authentication key.
- **TS_EXTRA_ARGS**: The `--advertise-connector` flag is used to designate this container as a App Connector Node within your Tailscale network.
- **Sysctls**: The system controls `net.ipv4.ip_forward` and `net.ipv6.conf.all.forwarding` are enabled to allow IP forwarding, which is necessary for routing traffic through the Exit Node.
- **Network Mode**: The `bridge` network mode is used to create a virtual network interface for the container, enabling it to handle traffic routing.
