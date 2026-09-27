# Speedtest Tracker with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) with Tailscale as a sidecar container to securely monitor and access your internet speed tracking tool over a private Tailscale network. By integrating Tailscale, you can ensure that your Speedtest Tracker instance remains private and accessible only to authorized devices on your Tailscale network.

## Speedtest Tracker

[Speedtest Tracker](https://github.com/alexjustesen/speedtest-tracker) is an open-source, self-hosted tool designed to regularly test and monitor your internet connection speed. It logs historical speed test data and provides detailed visualizations, making it ideal for diagnosing network issues or keeping your ISP accountable. Adding Tailscale enhances the security of your Speedtest Tracker instance by ensuring access is limited to authorized devices within your private network.

## Key Features

- **Automated Speed Tests**: Schedule regular speed tests for consistent monitoring.
- **Data Logging**: Keep historical records of your upload, download, and ping stats.
- **Detailed Visualizations**: View trends and performance over time with an intuitive web interface.
- **Self-Hosted**: Maintain full control over your data with a locally hosted solution.

## Configuration Overview

In this setup, the `tailscale-speedtest` service runs Tailscale, which manages secure networking for the Speedtest Tracker service. The `speedtest-tracker` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Speedtest Tracker’s web interface is only accessible through the Tailscale network (or locally, if preferred), providing enhanced privacy and security for your internet speed monitoring.
