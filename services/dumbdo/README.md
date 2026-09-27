# DumbDo with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [DumbDo](https://github.com/DumbWareio/DumbDo) with Tailscale as a sidecar container to securely manage and access your lightweight task manager over a private Tailscale network. By integrating Tailscale, you can ensure that your DumbDo instance remains private and accessible only to authorized devices within your Tailscale network.

## DumbDo

[DumbDo](https://github.com/DumbWareio/DumbDo) is a self-hosted, minimalistic task management tool designed to provide a distraction-free experience for managing to-do lists and tasks. With its simple interface and lightweight nature, DumbDo allows users to focus on productivity without unnecessary complexity. By integrating Tailscale, you can keep your task manager secure and accessible only within your private network.

## Key Features

- **Minimalist Task Management** – A straightforward approach to to-do lists without unnecessary complexity.
- **Self-Hosted** – Maintain full control over your data with a locally hosted instance.
- **Lightweight & Fast** – Designed for speed and efficiency without bloated features.
- **Secure Integration** – Pair with Tailscale to restrict access to authorized devices only.

## Configuration Overview

In this setup, the `tailscale-dumbdo` service runs Tailscale, which manages secure networking for the DumbDo service. The `dumbdo` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that DumbDo’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing enhanced privacy and security for your task management system.
