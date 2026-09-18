# Vaultwarden with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Vaultwarden](https://github.com/dani-garcia/vaultwarden) with Tailscale as a sidecar container to securely manage and access your password manager over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Vaultwarden instance, ensuring that it is only accessible within your Tailscale network.

## Vaultwarden

[Vaultwarden](https://github.com/dani-garcia/vaultwarden) is an open-source, self-hosted alternative to Bitwarden, a popular password manager. Vaultwarden allows you to securely store and manage your passwords, notes, and other sensitive data. This configuration leverages Tailscale to securely connect to your Vaultwarden instance, ensuring that your passwords and sensitive information are protected from unauthorized access and that your instance is accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the `tailscale-vaultwarden` service runs Tailscale, which manages secure networking for the Vaultwarden service. The `vaultwarden` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that Vaultwarden’s web interface and API are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted password manager.
