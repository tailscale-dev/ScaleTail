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

   Every service README uses the headings of the template, in the same order.
   Do not rename them and do not add others, so that every service reads the
   same way. Replace the placeholders in capitals.

   - **Introduction.** Say what the service does in one or two sentences and
     link to the upstream project. Leave feature lists to upstream.
   - **At a glance.** Give the Tailnet address, the port that Tailscale Serve
     forwards to, the image, and the data paths on the host. Add a row for
     each further port that users connect to, such as DNS or SMTP.
   - **Before you start.** List only what the Quick Start does not cover:
     values that must change in `.env`, secrets to generate, folders to
     create, and required host groups or devices.
   - **Deviations from the standard setup.** List every difference from
     [the standard setup](documentation/standard-setup.md) and give the
     reason. Examples are extra containers, published host ports, a changed
     or removed Serve configuration, DNS settings, and added capabilities.
   - **First run.** Describe what the user does after the first start, such
     as creating the first account or finding a generated password.
   - **Links.** Link to the upstream documentation and source code.

   When a section has nothing to report, keep the heading and the sentence
   from the template. A reader can then tell that the service follows the
   standard setup, and that the section was not forgotten.

   Add these optional sections between "First run" and "Links" when the
   service needs them, in this order:

   - **Configuration.** Optional settings that users commonly change.
   - **Troubleshooting.** Known errors and their solutions.
   - **Upgrading.** Steps for users of an older version of the stack.

   State only what you confirmed in the Compose file, the upstream
   documentation, or a running stack. Put guidance that applies to more than
   one service in `documentation/` and link to it.

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
