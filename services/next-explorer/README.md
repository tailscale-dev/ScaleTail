# NextExplorer with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [NextExplorer](https://github.com/nxzai/NextExplorer) with Tailscale as a sidecar container to securely manage file system over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Next Explorer instance, ensuring that it is only accessible within your Tailscale network.

## NextExplorer

[NextExplorer](https://github.com/nxzai/NextExplorer) is a modern, self-hosted file explorer designed for teams, creative agencies, and homelabs that need both a polished user interface and fine-grained access control. It ships as a single Docker container, mounts any number of volumes, and pairs seamlessly with reverse proxies or zero-trust networks. Whether you're organizing project assets for a small studio or providing secure file access across a household, NextExplorer delivers a responsive, feature-rich experience out of the box. This configuration leverages Tailscale to securely connect to your NextExplorer instance, protecting your file management interface from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-files` service runs Tailscale, which manages secure networking for the NextExplorer service. The `files` service uses the Tailscale network stack via Docker’s `network_mode: service:` configuration. This setup ensures that NextExplorer management interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for managing your file systems.
