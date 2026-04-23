



# XWiki with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [XWiki](https://www.xwiki.org) with Tailscale as a sidecar container to securely deliver push notifications over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you enhance the privacy and security of your ntfy instance, ensuring it is only accessible within your Tailscale network.

## XWiki

[XWiki](https://www.xwiki.org) offers a generic platform for developing projects and collaborative applications using the wiki paradigm.

## Configuration Overview

In this setup, the `tailscale-xwiki` service runs the Tailscale daemon to provide secure, private networking. The `xwiki` service is configured to use Tailscale’s network stack via Docker’s `network_mode: service:` syntax. This binds Paperless network interface to the Tailscale container, making the service available only through your Tailscale network (or locally, if needed).
