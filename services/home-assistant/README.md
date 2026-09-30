# Home Assistant with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **[Home Assistant](https://github.com/home-assistant/)** with Tailscale as a sidecar container to securely manage and access your smart home automation platform over a private Tailscale network. By integrating Tailscale, you can ensure that your Home Assistant instance remains private and accessible only to authorized devices within your Tailscale network.

## Home Assistant

[Home Assistant](https://github.com/home-assistant/) is an open-source home automation platform that allows you to control and automate smart devices from a unified interface. With support for thousands of integrations, it provides powerful automation capabilities and privacy-focused self-hosted control over your smart home. Pairing Home Assistant with Tailscale ensures a secure, remote-accessible smart home without exposing it to the public internet.

## Key Features

- **Local Control & Privacy** – Self-hosted and privacy-focused, keeping your data in your home.
- **Extensive Integrations** – Supports thousands of smart home devices and services.
- **Automation & Customization** – Create complex automations with YAML or visual editors.
- **Secure Remote Access** – Pair with Tailscale to safely access your Home Assistant instance from anywhere.

## Configuration Overview

In this setup, the `tailscale-homeassistant` service runs Tailscale, which manages secure networking for the Home Assistant service. The `homeassistant` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Home Assistant’s web interface and smart home control features are only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy for your home automation system.

## Troubleshooting

If you encounter a `400: Bad Request` after deployment, please alter the file `ha-data/config/configurations.yaml` to trust the reverse proxy configuration used by Tailscale. The `configurations.yaml` should look like this.

```plain
$ cat ha-data/config/configuration.yaml

# Loads default set of integrations. Do not remove.
default_config:

# Load frontend themes from the themes folder
frontend:
  themes: !include_dir_merge_named themes

automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml

http:
 use_x_forwarded_for: true
 trusted_proxies:
   - 127.0.0.1
```
