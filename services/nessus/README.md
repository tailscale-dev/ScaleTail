# Nessus with Tailscale Sidecar Configuration

> ⚠️ **Important:** This container has no ability for persistent storage - your configuration will be lost when restarting the instance.

This Docker Compose configuration sets up **[Nessus](https://www.tenable.com/products/nessus)** with Tailscale as a sidecar container to securely manage and access your vulnerability assessment tool over a private Tailscale network. By integrating Tailscale, you can ensure that your Nessus instance remains private and accessible only to authorized devices on your Tailscale network.

## Nessus

[Nessus](https://www.tenable.com/products/nessus) is one of the most widely used vulnerability assessment tools, designed to help identify and remediate security issues in IT environments. With powerful scanning capabilities, Nessus provides detailed reports on system vulnerabilities, configuration errors, and compliance issues. By pairing Nessus with Tailscale, you can further secure your vulnerability management setup by restricting access to authorized devices within your private network.

### Nessus Essentials: Free for Personal Use

Nessus Essentials offers a free version of the tool for personal and home use, [request your license here](https://www.tenable.com/products/nessus/nessus-essentials). It allows scanning up to **16 IP addresses**, making it an excellent choice for individuals looking to improve the security of their home networks. Despite being a free version, Nessus Essentials provides access to many of the powerful scanning capabilities that Nessus is known for, making it ideal for learning or small-scale vulnerability assessments.

## Key Features

- **Comprehensive Scanning**: Identify vulnerabilities, misconfigurations, and compliance violations across networks.
- **Detailed Reporting**: Generate in-depth reports to prioritize and remediate security issues effectively.
- **Self-Hosted**: Maintain full control over your scanning environment with a locally hosted instance.
- **Customizable Policies**: Tailor scans to meet your organization’s unique security needs.
- **Free Essentials Model**: Start for free with up to 16 IPs using Nessus Essentials.

## Configuration Overview

In this setup, the `tailscale-nessus` service runs Tailscale, which manages secure networking for the Nessus service. The `nessus` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Nessus’ web interface and scanning functionalities are only accessible through the Tailscale network (or locally, if preferred), adding an additional layer of security to your vulnerability management infrastructure.

For additional configuration (environment variables) - please refer to the [Tenable documentation](https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm).
