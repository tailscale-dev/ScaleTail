# DDNS Updater with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [DDNS Updater](https://github.com/qdm12/ddns-updater) with Tailscale as a sidecar container, enabling secure and private management of your dynamic DNS records over a Tailscale network. Integrating Tailscale ensures that your DDNS Updater instance is accessible only to authorized devices within your Tailnet, enhancing the security of your DNS management.

## DDNS Updater

[DDNS Updater](https://github.com/qdm12/ddns-updater) is a lightweight, universal program designed to keep your DNS A and/or AAAA records updated across multiple DNS providers. It supports a wide range of DNS services, including Cloudflare, DuckDNS, and many others. Key features include:

- **Periodic Updates**: Automatically updates DNS records at specified intervals to ensure they always point to your current IP address.
- **Web User Interface**: Provides a user-friendly web UI for monitoring and managing your DNS records.
- **Multi-Provider Support**: Compatible with numerous DNS providers, offering flexibility in your DNS management.
- **Docker Compatibility**: Available as a lightweight Docker image, facilitating easy deployment and integration into existing setups.

By combining DDNS Updater with Tailscale, you can securely manage your dynamic DNS records without exposing the service to the public internet.

## Configuration Overview

In this setup, the `tailscale-ddns-updater` service runs Tailscale, providing a secure networking layer for the DDNS Updater service. The `ddns-updater` service utilizes Docker's `network_mode: service:tailscale` configuration to route all traffic through the Tailscale network. This setup ensures that the DDNS Updater's web interface and API are only accessible within your private Tailnet, adding an extra layer of security to your DNS management.

## Volume Permissions

The DDNS Updater image runs as UID `1000`. Docker creates missing bind-mount directories as `root:root`, and DDNS Updater then exits with `permission denied` when it writes `config.json`. Create the data directory before the first start:

```sh
mkdir -p ddns-updater-data/data
sudo chown -R 1000:1000 ddns-updater-data
```
