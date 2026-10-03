# Umami with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Umami](https://github.com/umami-software/umami) with Tailscale as a sidecar
container to keep the app reachable over your Tailnet.

## Umami

[Umami](https://github.com/umami-software/umami) is an open-source web analytics platform that respects user privacy. No
cookies, no tracking across sites, no personal data collection. GDPR compliant out of the box. This configuration
leverages Tailscale to securely connect to your Umami dashboards, protecting your analytics data from unauthorized
access.

## Configuration Overview

In this setup, the `tailscale-umami` service runs Tailscale, which manages secure networking for Umami. The
`Umami` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration.

By default, `SERVE_CONFIG` is `private`. This keeps the app Tailnet-only, and available on port 443. When `SERVE_CONFIG`
is set to `public`, the `/script.js` and `/api/send` paths are exposed by funnel on port 443, while the rest of the
app is accessible only over the Tailnet on port 8443. Public mode is useful for tracking analytics from websites 
whose clients are not on the Tailnet. 

Default credentials for Umami are `admin` / `umami`.
