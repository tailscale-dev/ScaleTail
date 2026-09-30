# Uptime Kuma with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Uptime Kuma](https://github.com/louislam/uptime-kuma) with Tailscale as a sidecar container to securely monitor your services and websites over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your monitoring dashboard, ensuring that it is only accessible within your Tailscale network.

## Uptime Kuma

[Uptime Kuma](https://github.com/louislam/uptime-kuma) is a self-hosted monitoring tool that allows you to keep track of the uptime and performance of your websites, APIs, and services. With a sleek and user-friendly interface, Uptime Kuma provides real-time monitoring, notifications, and detailed reports to help you maintain the reliability of your infrastructure. This configuration leverages Tailscale to securely connect to your Uptime Kuma dashboard, protecting your monitoring data from unauthorized access.

## Configuration Overview

In this setup, the `tailscale-uptimekuma` service runs Tailscale, which manages secure networking for the Uptime Kuma service. The `uptimekuma` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that Uptime Kuma's monitoring dashboard is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your monitoring solution.
