# Nessus

[Nessus](https://www.tenable.com/products/nessus) is a vulnerability scanner. It scans the systems in your network and reports vulnerabilities, configuration errors, and compliance issues.

[Nessus Essentials](https://www.tenable.com/products/nessus/nessus-essentials) is free for personal use and scans up to 16 IP addresses.

This stack runs Nessus with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                         |
| ------------- | --------------------------------------------- |
| Web interface | `https://nessus.<tailnet>.ts.net`             |
| Service port  | `8834` (HTTPS with a self-signed certificate) |
| Image         | `tenable/nessus:latest-ubuntu`                |
| Data          | None on the host                              |

## Before you start

Request an activation code, for example for [Nessus Essentials](https://www.tenable.com/products/nessus/nessus-essentials). You need it in the setup.

## Deviations from the standard setup

- **No data folder.** Tenable does not support storage volumes for the Nessus image, so the stack has none. Your settings, scans, and license activation are lost when the container is recreated, for example after an image update. The Tenable documentation lists environment variables, such as `USERNAME`, `PASSWORD`, and `ACTIVATION_CODE`, that set up Nessus again at each start.
- **Serve forwards to HTTPS.** Nessus serves its web interface on port `8834` with a self-signed certificate. Tailscale Serve forwards to it with `https+insecure`.

## First run

Open the web interface and follow the setup. You choose the product, enter your activation code, and create the administrator account. Nessus then downloads and compiles its plugins, which takes a while.

## Links

- [Deploy Nessus as a Docker image](https://docs.tenable.com/nessus/Content/DeployNessusDocker.htm)
- [Nessus documentation](https://docs.tenable.com/nessus/)
