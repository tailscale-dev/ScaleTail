# Contributing to ScaleTail

Thanks for helping improve these Tailscale sidecar examples.

## Add a service

1. Copy the service template from the repository root. Replace `my-service` with your service name:

   ```sh
   cp -R templates/service-template services/my-service
   ```

   This command includes the hidden `.env` file. Use a lowercase directory name.

2. Update `.env`.

   Set `SERVICE`, usually to the directory name, and set `IMAGE_URL`,
   `SERVICEPORT`, and the application variables. Define every variable that
   `compose.yaml` uses, unless it has a default such as `${VAR:-value}`. Put
   comments on their own line: `VAR= # note` sets `VAR` to `# note`.

   `.env` is published with the repository. Never commit a working auth key,
   password, token, or other credential. Leave each secret empty. When the stack
   cannot start without it, require it in `compose.yaml`:

   ```yaml
   - DB_PASSWORD=${DB_PASSWORD:?Set DB_PASSWORD in .env}
   ```

   Compose then stops with an error until the user sets a value. Above the
   empty variable in `.env`, add a comment that starts with `# Required:` and
   says what to set, such as
   `# Required: signs the sessions. Generate it with: openssl rand -hex 32`.
   Keep `TS_AUTHKEY` and optional secrets without `:?`.

3. Adapt `compose.yaml`.

   - Keep the Compose service keys `tailscale` and `application`.
   - Name the containers `tailscale-${SERVICE}` and `app-${SERVICE}`, unless the
     stack documents a deviation under "Deviations from the standard setup".
   - Keep `network_mode: service:tailscale` on the application.
   - Keep the application's health-based dependency on `tailscale`.
   - Add all required persistent volumes.
   - Add required devices and capabilities explicitly.
   - When the stack needs another Compose service key or container name, more
     than one application container, or none, list the difference and the
     reason under "Deviations from the standard setup". Prefer
     `app-${SERVICE}-<role>` for extra containers, such as `app-${SERVICE}-db`.
   - Pass `PUID` and `PGID` only when the image reads them, such as LinuxServer.io
     images. Keep `TZ`, as the template does.
   - Write the image tag explicitly and use the tag upstream recommends. Pin
     databases, caches, and search engines to a major or major.minor tag. When
     you pin an exact version, say why in a comment.
   - Keep application data under `./${SERVICE}-data/`, so that `.gitignore`
     covers it.

4. Set the Serve proxy to the application's internal port.

   Hard-code the port in the Serve JSON. Do not use `${SERVICEPORT}`: it is
   meant for the optional LAN `ports` block and can differ from the port that
   Serve must proxy to. Keep runtime variables escaped, such as
   `$${TS_CERT_DOMAIN}`.

   Keep the `ports` block commented for Tailnet-only access. Document any LAN
   port you expose. When nothing in the stack uses Tailscale Serve, remove the
   Serve configuration: the `TS_SERVE_CONFIG` line, the `configs` entry of the
   `tailscale` service, and the top-level `configs` block.

5. Configure the application's health check.

   Use the first option that the image supports.

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

   Use the comment text from the template's `compose.yaml`, which covers the
   same options, the database case, and the no-check cases. Run the command
   inside the running container before you commit it. Keep the Tailscale health
   check.

6. Complete the service README.

   Every service README uses the headings of the template, in the same order.
   Do not rename them, and add no headings other than the optional sections
   below, so that every service reads the same way. Replace the placeholders in
   capitals.

   - **Introduction.** The paragraph under the title. Say what the service does
     in one or two sentences and link to the upstream project. Leave feature
     lists to upstream.
   - **At a glance.** Give the Tailnet address, the port that Tailscale Serve
     forwards to, the image, and the data paths on the host. Add a row for
     each further port that users connect to, such as DNS or SMTP. Write `None`
     for the web interface when there is none, and add an `API` row when Serve
     publishes an API.
   - **Before you start.** List only what the Quick Start does not cover:
     values that must change in `.env`, secrets to generate, folders to
     create, and required host groups or devices. List every required secret
     and say that Compose stops with an error until it is set.
   - **Deviations from the standard setup.** List every difference from
     [the standard setup](documentation/standard-setup.md) and give the
     reason. Examples are extra containers, published host ports, a changed
     or removed Serve configuration, DNS settings, and added capabilities.
   - **First run.** Describe what the user does after the first start, such
     as creating the first account or finding a generated password. When there
     is nothing to do, write `Nothing to set up. Open the web interface.`
   - **Links.** Link to the upstream documentation and source code.

   When a section has nothing to report, keep the heading and the sentence
   from the template. A reader can then tell that the service follows the
   standard setup, and that the section was not forgotten.

   Add these optional sections between "First run" and "Links" when the
   service needs them, in this order:

   - **Configuration.** Optional settings that users commonly change.
   - **Troubleshooting.** Known errors and their solutions.
   - **Upgrading.** Required when a change makes existing users act, such as a
     new required secret, a moved data folder, or a changed `SERVICE`. Say what
     to do, as in [FossFLOW](services/fossflow/README.md#upgrading).

   State only what you confirmed in the Compose file, the upstream
   documentation, or a running stack. Put guidance that applies to more than
   one service in `documentation/` and link to it.

7. Add the service to the correct category in the root `README.md`.

   Insert the row in alphabetical order of the bold name, ignoring case.

## Update a service

- Read the service README and Compose file before you make changes.
- Preserve the shared network namespace and Tailscale dependency.
- Preserve persistent volumes unless you document a safe migration.
- Use `${VARIABLE}` for Compose interpolation, not `$(VARIABLE)`.
- Update the service README when ports, paths, setup, or behavior change.
- Update the root service list when you add, remove, or rename a service.
- Changing `SERVICE` renames the Tailnet device and its address, the
  containers, and the `./${SERVICE}-data` folder. Treat it like a volume change
  and add an "Upgrading" section.
- Do not rename existing containers or service keys. Other containers and
  `.env` values may refer to them.

Preserve valid service-specific exceptions.

## Verify your change

Run Compose validation from each changed service directory. Stacks that
require your own secrets stop with "required variable ... is missing a value".
Give those variables a dummy value on the command line, as CI does, instead of
editing `.env`:

```sh
env $(grep -ohE '\$\{[A-Za-z0-9_]+:\?' compose.yaml .env | sed -E 's/^\$\{//; s/:\?$/=dummy/' | sort -u) docker compose config --quiet
```

The command must exit with status 0 and add no "variable is not set"
warnings. It does not prove that the application works.

From the repository root, lint all Markdown with the rumdl version that
`.github/workflows/linting.yml` pins, currently 0.2.78:

```sh
uvx rumdl@0.2.78 check --config .markdownlint.yml .
```

After you stage new files, check whitespace with `git diff --check origin/main`.

When possible, start the stack from a copy outside the repository, such as
`cp -R services/my-service /tmp/my-service`, and put real values only in the
copy. A running stack writes `./config`, `./ts/state` (with the Tailscale
device key), and its data folders next to `compose.yaml`. Before you commit,
run `git status` and stage only the files you changed on purpose.

Then confirm:

- Tailscale becomes healthy and joins the Tailnet.
- The application starts and is reachable through the Tailnet.
- The application's main function works.
- Persistent storage and documented LAN access work, when applicable.

## Submit a pull request

Title the pull request `Service: what changes`, such as `Umami: new service`.
For several services, list them or use `All services:`. For other areas, use
`CI:`, `Docs:`, or `Template:`. Fill in the pull request template, and report
the checks you ran and any checks you could not run. Maintainers apply the
labels.
