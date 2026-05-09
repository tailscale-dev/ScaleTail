# SERVICE with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [N8N](https://n8n.io/) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## SERVICE

[N8N](https://n8n.io/) a workflow automation platform that uniquely combines AI capabilities with business process automation, giving technical teams the flexibility of code with the speed of no code.

## Configuration Overview

In this setup, the `tailscale-N8N` service runs Tailscale, which manages secure networking for SERVICE. The `SERVICE` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

For the folder structure you will need to pre-create the n8n-storage directory, and correct the ownership before the first run, by doing the following:

```bash
mkdir -p n8n-storage
sudo chown -R 1000:1000 n8n-storage
```

## What to document for users

In this setup, the tailscale-n8n service runs Tailscale, which manages secure networking for the N8N service. The N8N service uses the Tailscale network stack via Docker’s network_mode: service: configuration. This setup ensures that N8N management interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for managing your automations.

If you need the runners for N8N uncomment the following within the docker-compose.yaml file - `N8N_RUNNERS_MODE=external`, `N8N_RUNNERS_AUTH_TOKEN=${RUNNERS_AUTH_TOKEN}`, `N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0` as well as uncommenting `RUNNERS_AUTH_TOKEN` within the .env file.

The configs section also needs to be updated to match the below. Specifically the Proxy port needs changing from 8080 to 5678

```plain
configs:
  ts-serve:
    content: |
      {"TCP":{"443":{"HTTPS":true}},
      "Web":{"$${TS_CERT_DOMAIN}:443":
          {"Handlers":{"/":
          {"Proxy":"http://127.0.0.1:5678"}}}},
      "AllowFunnel":{"$${TS_CERT_DOMAIN}:443":false}}
```
