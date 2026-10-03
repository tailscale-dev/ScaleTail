# Immich with Tailscale Sidecar Configuration

This Docker Compose configuration sets up Immich with Tailscale as a sidecar container, enabling secure access to your photo and video library from anywhere on your private Tailscale network. With this setup, your Immich instance remains completely private and protected, accessible only to your authorized devices.

**Please note** Immich changes the [docker-compose](https://immich.app/docs/install/docker-compose) often, we try to match the docker-compose in this repo to theirs, but make sure to check for yourself.

## Immich

Immich is a self-hosted, high-performance solution for backing up and browsing photos and videos from your mobile devices. It offers a sleek interface, automatic uploads, facial recognition, albums, search, and metadata support—all while keeping your media under your control. Immich is a privacy-first alternative to commercial cloud-based photo services, ideal for individuals or families.

## Key Features

* **Automatic Uploads** – Sync photos and videos from mobile devices instantly.
* **Albums & Timeline** – Organize and view media in an intuitive gallery.
* **Face Recognition & Object Detection** – Smart tools to tag and sort images.
* **Multi-User Support** – Share with family while maintaining user boundaries.
* **Self-Hosted** – Run on your own server with full control.
* **Private by Default with Tailscale** – Secured with Tailscale, accessible only to you.

## Configuration Overview

In this deployment, the `tailscale-immich` service runs the Tailscale client to establish a secure private network. The `immich` container uses `network_mode: service:tailscale` to route its traffic through the Tailscale interface. This ensures that the Immich web UI and backend services are only reachable via your Tailscale network, keeping your personal media safe from public exposure.

## Usage Notes

* **Keep `TS_ACCEPT_DNS` disabled.** The `application` service shares the DNS configuration of the `tailscale` service. With `TS_ACCEPT_DNS=true`, Tailscale replaces Docker's DNS with MagicDNS, which cannot resolve the `database`, `redis`, and `immich-machine-learning` services. Immich then fails to start with `getaddrinfo ENOTFOUND database`. You can reach Immich over your Tailnet without this setting.
* **Resolving MagicDNS names from Immich.** If Immich itself must look up other Tailnet devices by name, such as an OAuth provider or SMTP server, uncomment the `dns` block of the `tailscale` service and set `100.100.100.100` as the DNS server. Docker keeps resolving the service names and forwards all other lookups to MagicDNS. Use the full name, such as `device.example.ts.net`.
* **Remote machine learning.** If you run the machine learning container on another Tailnet device, your Tailnet policy must allow the Immich node to reach that device on TCP port `3003`. Otherwise the `tailscale` service logs `rejected due to acl`. A grant from the Immich node to the machine learning host with `"ip": ["tcp:3003"]` is enough. Keep `TS_USERSPACE=false`, because Immich must open connections to the Tailnet. Use the host's Tailscale IP address in the machine learning URL, or its MagicDNS name with the `dns` block described above.
* **Storage locations.** `UPLOAD_LOCATION` and `DB_DATA_LOCATION` in `.env` set where Immich stores your media and its database. The defaults are `./immich-data/upload` and `./immich-data/database`. To move your media to another disk, set `UPLOAD_LOCATION` to an absolute path. Keep the database on a local disk, because Immich does not support network shares for it.
* **Updating an existing installation.** Earlier versions of this stack ignored both variables and always used the default folders. If your `.env` still contains `UPLOAD_LOCATION=./library` or `DB_DATA_LOCATION=./postgres`, replace them with the defaults above before you restart. Otherwise Immich starts with an empty library and a new database. Your existing files stay untouched in `./immich-data`.
* **Renamed services.** Immich connects to the hostnames `database` and `redis` by default. If you rename these services in `compose.yaml`, set `DB_HOSTNAME` and `REDIS_HOSTNAME` in `.env` to the new names.
