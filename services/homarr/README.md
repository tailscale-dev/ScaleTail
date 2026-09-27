# Homarr with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Homarr](https://github.com/ajnart/homarr) with Tailscale as a sidecar container to securely manage and access your dashboard over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Homarr instance, ensuring that it is only accessible within your Tailscale network.

## Homarr

[Homarr](https://github.com/ajnart/homarr) is an open-source, self-hosted dashboard that integrates with all your self-hosted services, providing a centralized location to manage and access your apps, notifications, and more. It supports customization and can be extended with various plugins and integrations. This configuration leverages Tailscale to securely connect to your Homarr instance, ensuring that your dashboard interface is protected from unauthorized access and that your instance is accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the tailscale-homarr service runs Tailscale, which manages secure networking for the Homarr service. The homarr service uses the Tailscale network stack via Docker's network_mode: service:tailscale configuration. This setup ensures that Homarr’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted dashboard.
