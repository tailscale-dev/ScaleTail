# Contributing to ScaleTail

Thanks for helping improve these Tailscale sidecar examples.

## Add a service

1. Copy the service template from the repository root. Replace `my-service` with your service name:

   ```sh
   cp -R templates/service-template services/my-service
   ```

   This command includes the hidden `.env` file. Use a lowercase directory name.

2. Update `.env` with safe example values.

   Set `SERVICE`, `IMAGE_URL`, `SERVICEPORT`, and the application variables.
   Never commit a working auth key, password, token, or other credential.

3. Adapt `compose.yaml`.

   - Keep the Compose service keys `tailscale` and `application`.
   - Name the containers `tailscale-${SERVICE}` and `app-${SERVICE}`.
   - Keep `network_mode: service:tailscale` on the application.
   - Keep the application's health-based dependency on `tailscale`.
   - Add all required persistent volumes.
   - Add required devices and capabilities explicitly.

4. Set the Serve proxy to the application's internal port.

   The Serve JSON does not read `SERVICEPORT` from `.env`. Keep runtime variables
   escaped, such as `$${TS_CERT_DOMAIN}`.

   Keep the `ports` block commented for Tailnet-only access. Document any LAN
   port you expose. Remove the Serve configuration when the service does not use
   Tailscale Serve.

5. Add a health check that the application image can run.

   Prefer an application endpoint or an upstream health command. Remove the
   application health check when no reliable check exists. Keep the Tailscale
   health check.

6. Complete the service README.

   Document prerequisites, persistent paths, setup steps, ports, Tailnet access,
   and service-specific exceptions. Link to the upstream documentation.

7. Add the service to the correct category in the root `README.md`.

   Keep the entries in that category alphabetized.

## Update a service

- Read the service README and Compose file before you make changes.
- Preserve the shared network namespace and Tailscale dependency.
- Preserve persistent volumes unless you document a safe migration.
- Use `${VARIABLE}` for Compose interpolation, not `$(VARIABLE)`.
- Update the service README when ports, paths, setup, or behavior change.
- Update the root service list when you add, remove, or rename a service.

Preserve valid service-specific exceptions.

## Verify your change

Run Compose validation from each changed service directory:

```sh
docker compose config --quiet
```

This command does not prove that the application works.

The repository validator is the deterministic contract check for new and
changed services:

```sh
python -m pip install -r tools/requirements.txt
python tools/validate_services.py services/<service-name> --new-service <service-name>
```

Run it from the repository root, and run Compose validation from the service
directory. The `service-contract` GitHub check performs these checks without
pulling images or starting third-party containers. Multi-container layouts
must be listed in `tools/service-profiles.yml` with an ingress service and a
maintainer-owned reason; Tailscale-node profiles are restricted to approved
routing services. Preserve template comments and verify ports, healthchecks,
volume paths, permissions, devices, capabilities, and architecture support
against authoritative upstream documentation.

When possible, start the stack and confirm:

- Tailscale becomes healthy and joins the Tailnet.
- The application starts and is reachable through the Tailnet.
- The application's main function works.
- Persistent storage and documented LAN access work, when applicable.

## Submit a pull request

Follow the pull request template. Report the checks you ran and any checks you
could not run.

For research-heavy PR reviews and issue triage, use the personal
`scaletail-maintainer` skill. It reports findings by default and only edits the
local checkout after an explicit request; it does not push branches, post
GitHub comments, resolve review threads, apply labels, or close issues unless
separately requested. Runtime reports need evidence from the service image,
Docker/Compose, Tailscale, and environment layers rather than formatting-only
changes.
