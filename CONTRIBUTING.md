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

5. Configure the application's health check.

   Use the first option that the image supports. The template lists the same
   options in the same order.

   1. When the image defines its own `HEALTHCHECK`, omit the block and add a
      `# Healthcheck: defined by the image (...)` comment that names the
      command or what it checks. Override the image's check only when it does
      not work with the stack, and say why in a comment.
   2. Call an application endpoint with a client that ships with the image.
   3. Run a health command that ships with the image.
   4. Check a fixed process name with `pidof` or `pgrep -x`, when the
      container has no endpoint or the image has no HTTP client. `pgrep -x`
      matches at most 15 characters of the process name. When the process
      name is generic, such as `python`, use `pgrep -f` with a fixed pattern.
   5. When the image has no shell, HTTP client, or health command, no check
      is possible. Omit the block and add a `# Healthcheck: none possible ...`
      comment that names the reason.

   Run the command inside the running container before you commit it. Avoid
   `pgrep -f ${SERVICE}`, which breaks when `SERVICE` is renamed.

   A container that runs once and exits needs no check. Omit the block and
   add a `# Healthcheck: none needed ...` comment that names the reason.

   For a database, connect over TCP, for example with
   `pg_isready -h 127.0.0.1` or `mariadb-admin ping -h 127.0.0.1`. During the
   first start, the image runs a temporary server that accepts only socket
   connections, so a socket check reports ready too early. When another
   service depends on the database, wait with `condition: service_healthy`.
   A database image's own `HEALTHCHECK` still comes first. When that check
   connects over the socket, say so in the comment.

   Keep the Tailscale health check.

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

When possible, start the stack and confirm:

- Tailscale becomes healthy and joins the Tailnet.
- The application starts and is reachable through the Tailnet.
- The application's main function works.
- Persistent storage and documented LAN access work, when applicable.

## Submit a pull request

Follow the pull request template. Report the checks you ran and any checks you
could not run.
