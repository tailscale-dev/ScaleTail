# searXNG with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [searXNG](https://github.com/searxng/searxng) with Tailscale as a sidecar container, enabling secure access to your private metasearch engine over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you can ensure that your searXNG instance is accessible only within your Tailscale network, providing an additional layer of security and privacy for your searches.

## searXNG

[searXNG](https://github.com/searxng/searxng) is a free, open-source metasearch engine that aggregates results from multiple search engines while protecting your privacy. With no user tracking and the ability to self-host, searXNG empowers you to take control of your search experience. By leveraging Tailscale, you can securely access your self-hosted searXNG instance from any of your devices, ensuring that your searches remain private and inaccessible to unauthorized users.

## Configuration Overview

In this setup, the `tailscale-searxng` service runs Tailscale, which manages secure networking for the searXNG service. The `searxng` service utilizes the Tailscale network stack via Docker’s `network_mode: service:` configuration. This setup ensures that searXNG is only accessible through your Tailscale network (or locally, if preferred). With this configuration, you can enjoy a private, secure, and customizable search engine experience, free from user tracking or external access.

We use `/searxng/settings.yml` copied from <https://github.com/searxng/searxng/blob/master/searx/settings.yml> as the default settings file. This dir is mounted as a volume, on docker and required for the first run.

## References

[![Replace Google with SearXNG - a privacy respecting, self-hosted search engine](https://img.youtube.com/vi/cg9d87PuanE/0.jpg)](https://www.youtube.com/watch?v=cg9d87PuanE)
