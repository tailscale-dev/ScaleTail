# Gokapi with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Gokapi](https://github.com/Forceu/Gokapi) with Tailscale as a sidecar container to securely manage and access your lightweight file-sharing service over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Gokapi instance, ensuring that it is only accessible within your Tailscale network.

## Gokapi

[Gokapi](https://github.com/Forceu/Gokapi) is a lightweight, self-hosted file-sharing platform designed to provide a simple and secure way to share files with others. It features an intuitive web interface, token-based sharing, and the ability to control file expiry and download limits. This configuration leverages Tailscale to securely connect to your Gokapi instance, ensuring that your file-sharing activities remain private and protected from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-gokapi` service runs Tailscale, which manages secure networking for the Gokapi service. The `gokapi` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that Gokapi's web interface and file-sharing services are only accessible through the Tailscale network (or locally, if preferred), providing an additional layer of security and privacy for your file-sharing solution.
