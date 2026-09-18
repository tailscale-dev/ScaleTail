# searXNG with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [searXNG](https://github.com/searxng/searxng) with Tailscale as a sidecar container, enabling secure access to your private metasearch engine over a private Tailscale network. By integrating Tailscale in a sidecar configuration, you can ensure that your searXNG instance is accessible only within your Tailscale network, providing an additional layer of security and privacy for your searches.

## searXNG

[searXNG](https://github.com/searxng/searxng) is a free, open-source metasearch engine that aggregates results from multiple search engines while protecting your privacy. With no user tracking and the ability to self-host, searXNG empowers you to take control of your search experience. By leveraging Tailscale, you can securely access your self-hosted searXNG instance from any of your devices, ensuring that your searches remain private and inaccessible to unauthorized users.

## Configuration Overview

In this setup, the `tailscale-searxng` service runs Tailscale, which manages secure networking for the searXNG service. The `searxng` service utilizes the Tailscale network stack via Docker’s `network_mode: service:tailscale` configuration. This setup ensures that searXNG is only accessible through your Tailscale network (or locally, if preferred). With this configuration, you can enjoy a private, secure, and customizable search engine experience, free from user tracking or external access.

We use `/searxng/settings.yml` copied from <https://github.com/searxng/searxng/blob/master/searx/settings.yml> as the default settings file. This dir is mounted as a volume, on docker and required for the first run.
The default `settings.yml` does not use valkey ([valkey](https://github.com/searxng/searxng/blob/master/searx/settings.yml#L121) URL is set to `false`). We enable this by setting the `SEARXNG_VALKEY_URL` in `.env` file and using that in the `compose.yaml` file.
Set `SEARXNG_SECRET` in `.env` to a random value, for example with `openssl rand -hex 32`. The Compose file passes it to the mounted settings file as the instance secret, and Compose stops with an error if it is empty.
Set `TAILNET_NAME` in `.env` to your Tailnet name, the part between the service name and `.ts.net`. The Compose file builds the base URL `https://<SERVICE>.<TAILNET_NAME>.ts.net/` from it. SearXNG uses it to build its inbound links, and an empty value would produce an invalid address, so Compose stops with an error if `TAILNET_NAME` is empty.

## References

[![Replace Google with SearXNG - a privacy respecting, self-hosted search engine](https://img.youtube.com/vi/cg9d87PuanE/0.jpg)](https://www.youtube.com/watch?v=cg9d87PuanE)
