# Beszel Agent with Tailscale Sidecar Configuration

This Docker Compose configuration integrates the [Beszel](https://github.com/henrygd/beszel) Agent with Tailscale in a sidecar setup to enhance secure communication over a private Tailscale network. By utilizing Tailscale, this configuration ensures that the Agent's communication with the Hub remains secure and private within your Tailscale network. Thanks to @[henrygd](https://github.com/henrygd) for the tool development.

## Beszel Agent

The Beszel Agent is the client-side component that connects to the Hub to send and receive messages. Multiple agents can connect to a single Hub, enabling secure communication across different devices. The Agent also benefits from the Tailscale sidecar, ensuring that its communication with the Hub is conducted over a secure, private network.

## Configuration Overview

In this setup, the `tailscale` service runs Tailscale, which manages secure networking for the Beszel Agent service. The Agent service connects to the Tailscale network stack using Docker's `network_mode: service:` configuration. This setup guarantees that the Agent's communication channels are only accessible through the Tailscale network, providing an extra layer of security and privacy.
