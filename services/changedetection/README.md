# ChangeDetection.io with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [ChangeDetection.io](https://github.com/dgtlmoon/changedetection.io) with Tailscale as a sidecar container to securely monitor and access website changes over a private Tailscale network. By using Tailscale in a sidecar configuration, you can ensure that your ChangeDetection.io instance is only accessible within your Tailscale network, providing enhanced security and privacy.

## ChangeDetection.io

[ChangeDetection.io](https://github.com/dgtlmoon/changedetection.io) is an open-source tool for tracking changes on websites. Whether monitoring prices, content updates, or new product launches, it provides an easy-to-use interface for tracking and alerting you to changes. By integrating Tailscale, you can securely connect to your ChangeDetection.io instance, ensuring that your sensitive tracking information and alerts are protected from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-changedetection` service runs Tailscale, which manages secure networking for the ChangeDetection.io service. The `changedetection` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that ChangeDetection.io’s web interface is only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy to your website monitoring setup.
