# IT-Tools with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [IT-Tools](https://github.com/CorentinTh/it-tools) with Tailscale as a sidecar container to securely access your all-in-one developer utility over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your IT-Tools instance, ensuring that it is only accessible within your Tailscale network.

## IT-Tools

[IT-Tools](https://github.com/CorentinTh/it-tools) is an open-source collection of online utilities designed for developers and IT professionals. It includes a variety of tools such as encoders, converters, formatters, and more—all in one sleek, web-based application. This configuration leverages Tailscale to securely connect to your IT-Tools instance, ensuring that your suite of developer utilities is protected from unauthorized access and accessible only via your private Tailscale network.

## Configuration Overview

In this setup, the `tailscale-it-tools` service runs Tailscale, which manages secure networking for the IT-Tools service. The `it-tools` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that IT-Tools’ web interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted developer utilities.
