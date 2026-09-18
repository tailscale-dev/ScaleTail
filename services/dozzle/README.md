# Dozzle with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Dozzle](https://github.com/amir20/dozzle) with Tailscale as a sidecar container to securely access your real-time Docker log viewer over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Dozzle instance, ensuring that it is only accessible within your Tailscale network.

## Dozzle

[Dozzle](https://github.com/amir20/dozzle) is a lightweight, self-hosted application for viewing Docker container logs in real time. It offers an intuitive web interface that makes it easy to monitor logs from your Docker environment without the need for complex setups or additional dependencies. This configuration leverages Tailscale to securely connect to your Dozzle instance, ensuring that your log viewer is protected from unauthorized access and that your instance is only accessible via your private Tailscale network.

## Configuration Overview

In this setup, the `tailscale-dozzle` service runs Tailscale, which manages secure networking for the Dozzle service. The `dozzle` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that Dozzle’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted log viewer.
