# Netbox with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Netbox](https://github.com/netbox-community/netbox) with Tailscale as a sidecar container to securely access your Network layout over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy, ensuring that they are only accessible within your Tailscale network.

## Netbox

[Netbox](https://github.com/netbox-community/netbox) exists to empower network engineers. Since its release in 2016, it has become the go-to solution for modeling and documenting network infrastructure for thousands of organizations worldwide. As a successor to legacy IPAM and DCIM applications, NetBox provides a cohesive, extensive, and accessible data model for all things networked.

## Configuration Overview

In this setup, the `tailscale-netbox` service runs Tailscale, which manages secure networking for the Netbox application. The `netbox` application uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This setup ensures that your Netbox application is only accessible through the Tailscale network (or local as well, if preferred).

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env`
  - Required: `TS_AUTHKEY`
  - Required: `SUPER_SECRET`, the base value for the PostgreSQL and Redis passwords. Use letters and digits only. Generate it with `openssl rand -hex 16`.
  - Required: `SECRET_KEY`, at least 50 characters. Generate it with `openssl rand -base64 48`.

Compose stops with an error if `SUPER_SECRET` or `SECRET_KEY` is empty. PostgreSQL applies the database password only when it first creates the database. If you are upgrading, set `SUPER_SECRET` to the value from your previous `.env`, including the old default if you never changed it. Otherwise NetBox cannot authenticate to the existing database.
