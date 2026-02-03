# Beszel Hub with Tailscale Sidecar Configuration

This Docker Compose configuration integrates the [Beszel](https://github.com/henrygd/beszel) Hub with Tailscale in a sidecar setup to enhance secure communication over a private Tailscale network. By utilizing Tailscale, this configuration ensures that all communication handled by the Hub remains secure and private within your Tailscale network. Thanks to @[henrygd](https://github.com/henrygd) for the tool development.

## Beszel Hub

The Beszel Hub is the core component responsible for routing messages between agents and managing the overall communication flow. In this configuration, the Hub runs in its own Docker service and is secured by the Tailscale sidecar, ensuring that all traffic to and from the Hub is encrypted and restricted to your Tailscale network.

## Configuration Overview

In this setup, the `tailscale` service runs Tailscale, which manages secure networking for the Beszel Hub service. The Hub service connects to the Tailscale network stack using Docker's `network_mode: service:` configuration. This setup guarantees that the Hub's communication channels are only accessible through the Tailscale network, providing an extra layer of security and privacy.
