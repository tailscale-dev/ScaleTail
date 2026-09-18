# CyberChef with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [CyberChef](https://github.com/gchq/CyberChef) with Tailscale as a sidecar container to securely access your data analysis and manipulation tool over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your CyberChef instance, ensuring that it is only accessible within your Tailscale network.

## CyberChef

[CyberChef](https://github.com/gchq/CyberChef) is an open-source web application designed to simplify the process of carrying out complex data analysis and encoding/decoding operations. It features a user-friendly drag-and-drop interface that enables users to create "recipes" for analyzing and manipulating data. This configuration leverages Tailscale to securely connect to your CyberChef instance, ensuring that your powerful data tool is protected from unauthorized access and that it is only accessible via your private Tailscale network.

## Configuration Overview

In this setup, the `tailscale-cyberchef` service runs Tailscale, which manages secure networking for the CyberChef service. The `cyberchef` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that CyberChef’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted data analysis tool.
