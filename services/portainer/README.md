# Portainer with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Portainer](https://github.com/portainer/portainer) with Tailscale as a sidecar container to securely manage and monitor your Docker environments over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Portainer instance, ensuring that it is only accessible within your Tailscale network.

## Portainer

[Portainer](https://github.com/portainer/portainer) is an open-source management tool that provides a simple and easy-to-use interface for managing Docker environments. Whether you are deploying containers, managing networks, or monitoring your Docker services, Portainer offers a comprehensive solution for managing your containerized applications. This configuration leverages Tailscale to securely connect to your Portainer instance, protecting your Docker management interface from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-portainer` service runs Tailscale, which manages secure networking for the Portainer service. The `portainer` service uses the Tailscale network stack via Docker’s `network_mode: service:tailscale` configuration. This setup ensures that Portainer’s management interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for managing your Docker environments.
