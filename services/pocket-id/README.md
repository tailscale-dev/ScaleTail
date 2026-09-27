# Pocket ID with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Pocket ID](https://github.com/stonith404/pocket-id) with Tailscale as a sidecar container to securely manage and access your decentralized identity service over a private Tailscale network. By integrating Tailscale, you can ensure that your Pocket ID instance remains private and accessible only to authorized devices within your Tailscale network.

## Pocket ID

[Pocket ID](https://github.com/stonith404/pocket-id) is an open-source, self-hosted decentralized identity (DID) solution that simplifies user authentication and identity management. It leverages the power of blockchain principles and modern cryptographic techniques to provide a secure, privacy-first approach to identity verification. With Pocket ID, you can authenticate users, manage permissions, and securely issue verifiable credentials, all while maintaining complete control over your identity system.

## Key Features

- **Decentralized Identity**: Built on W3C’s DID standards, enabling privacy-first, self-sovereign identity management.
- **Verifiable Credentials**: Issue, share, and verify credentials without relying on centralized authorities.
- **Interoperability**: Compatible with a wide range of DID methods and cryptographic algorithms.
- **Self-Hosted**: Maintain full control over your identity solution by hosting it locally.
- **Secure Integration**: Pair with Tailscale for enhanced security, limiting access to your identity services to authorized devices.

## Configuration Overview

In this setup, the `tailscale-pocket-id` service runs Tailscale, which manages secure networking for the Pocket ID service. The `pocket-id` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Pocket ID’s web interface and APIs are only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your identity management system.
