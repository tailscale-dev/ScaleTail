# Excalidraw with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Excalidraw](https://github.com/excalidraw/excalidraw) with Tailscale as a sidecar container to securely collaborate on whiteboard diagrams over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you can enhance the security and accessibility of your Excalidraw server, ensuring that it is only available within your Tailscale network.

## Excalidraw

[Excalidraw](https://github.com/excalidraw/excalidraw) is an open-source virtual whiteboard tool designed for real-time collaboration. It allows users to create diagrams, sketches, and wireframes in a minimalist, hand-drawn style. Excalidraw is easy to set up and supports self-hosting for private, secure collaboration. This configuration incorporates Tailscale to provide a secure connection to your Excalidraw server, protecting your sessions from unauthorized access and enabling private collaboration.

## Configuration Overview

In this setup, the `tailscale-excalidraw` service runs Tailscale, which manages secure networking for the Excalidraw service. The `excalidraw` service utilizes the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This design ensures that Excalidraw's collaboration and editing features are only accessible through the Tailscale network (or locally, if preferred), providing enhanced security and privacy for your self-hosted Excalidraw instance.
