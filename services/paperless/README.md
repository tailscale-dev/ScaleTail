# Paperless-ngx  with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Paperless-ngx](https://docs.paperless-ngx.com/) with Tailscale as a sidecar container to securely deliver push notifications over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you enhance the privacy and security of your ntfy instance, ensuring it is only accessible within your Tailscale network.

## Paperless-ngx

[Paperless-ngx](https://docs.paperless-ngx.com) is a community-supported open-source document management system that transforms your physical documents into a searchable online archive so you can keep, well, less paper.

## Configuration Overview

In this setup, the `tailscale-paperless` service runs the Tailscale daemon to provide secure, private networking. The `paperless` service is configured to use Tailscale’s network stack via Docker’s `network_mode: service:` syntax. This binds Paperless network interface to the Tailscale container, making the service available only through your Tailscale network (or locally, if needed).

This architecture is ideal for self-hosters who want to send and receive notifications from anywhere without exposing Paperless-ngx to the internet, maintaining both ease of access and strict privacy controls.
