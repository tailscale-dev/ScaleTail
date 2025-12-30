# Contributing to ScaleTail

Thanks for helping expand these Tailscale sidecar examples. Keeping services aligned with the template makes it easier for users to migrate existing Compose stacks without breaking them.

## Adding a new service

1. Copy `templates/service-template` into `services/<service-name>` and rename the compose and README files accordingly.
2. Update `compose.yaml`:
   - Keep the Tailscale container named `tailscale-<service>` and the app container named `app-<service>`.
   - Set `IMAGE_URL`, `SERVICEPORT`, and any other app variables in `.env`; do not commit secrets or real auth keys.
   - Leave `network_mode: service:tailscale` in place and keep `depends_on` using the Tailscale health check.
   - Keep the `ports` section commented unless LAN exposure is required; explain why in the README if you expose anything.
   - Adjust volumes to match the service, and pre-create bind-mount paths so Docker does not create root-owned folders. (optional)
   - If the service needs devices (GPU, render, fuse, etc.) or extra capabilities, add them explicitly and mention them in the README. (optional)
3. Update `"Proxy":"http://127.0.0.1:80"` in `compose.yaml` with the app's actual internal port; it does not consume `.env` values automatically. Remove `TS_SERVE_CONFIG` if Serve/Funnel is not needed.
4. Fill in the service README using the template:
   - Briefly describe the app and why Tailscale helps.
   - List prerequisites (user in `docker` group, GPU/group membership, devices).
   - Call out gotchas: initial admin setup, default credentials, path expectations, required group IDs, or config directory names that must change.
   - Clarify MagicDNS/HTTPS steps (`TS_ACCEPT_DNS`), optional 0.0.0.0 port exposure, and any health checks.
   - Link to upstream service docs and any official setup videos.
5. Sanity-check the stack with `docker compose config` from the service directory to catch typos and missing variables.

## Updating an existing service

- Keep the sidecar pattern intact (`network_mode: service:tailscale`, health checks, `depends_on`).
- Avoid removing existing volumes or changing container names unless the change is clearly documented in the README.
