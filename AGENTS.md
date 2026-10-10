# Agent guidance

ScaleTail is a collection of Docker Compose stacks. Each directory in `services/` is one stack, which usually runs a self-hosted application behind a Tailscale sidecar container.

## Where the rules live

- [CONTRIBUTING.md](CONTRIBUTING.md): how to add, update, verify, and submit a service. Follow it.
- [templates/service-template/](templates/service-template/): the starting point for every service. Its comments explain each setting.
- [documentation/standard-setup.md](documentation/standard-setup.md): the shared setup. A service README lists only what differs, under "Deviations from the standard setup".
- [.github/workflows/](.github/workflows/): the Compose validation and Markdown lint that CI runs.

## Before you edit

- Read the service's `compose.yaml`, `.env`, and README, including "Deviations from the standard setup".
- Confirm ports, commands, volumes, variables, and health checks in the image's upstream docs.
- Preserve documented exceptions. Some stacks use other Compose service keys or container names, and other containers or `.env` values refer to those names.
- Keep changes focused on the requested service or documentation.

## Files that change together

- Add, rename, or remove a service: the `services/<name>/` directory and its row in the root `README.md`. Insert a new row in alphabetical order by the bold name, and leave the other rows alone.
- Make existing users act, such as with a new required secret, a moved volume, or a changed `SERVICE`: add an "Upgrading" section to the service README. `SERVICE` also names the Tailnet device, the containers, and most data folders.
- Change the template: also update `documentation/standard-setup.md` and `CONTRIBUTING.md` where they describe the same setting. Validate it from `templates/service-template/` with `SERVICE=dummy IMAGE_URL=dummy docker compose config --quiet`, because the template leaves both values empty.

## Secrets and local data

- Every `.env` file is tracked and published. Never commit an auth key, password, token, or other credential.
- Leave each secret empty in `.env`. When the stack cannot start without it, read it in `compose.yaml` as `${VAR:?Set VAR in .env}`, and add a `# Required:` comment above it in `.env` that says what to set, such as how to generate it. Keep `TS_AUTHKEY` optional, because only the first start needs it.
- Start test stacks from a copy outside the repository, such as `cp -R services/<name> /tmp/<name>`, and put real values only in the copy. A running stack writes `./config`, `./ts/state` (with the device key), and its data folders next to `compose.yaml`.
- Before you commit, run `git status` and stage only the files you meant to change.

## Verification

From each changed service directory, validate Compose. The command gives each required variable a dummy value, as CI does, so you do not edit `.env`:

```sh
env $(grep -ohE '\$\{[A-Za-z0-9_]+:\?' compose.yaml .env | sed -E 's/^\$\{//; s/:\?$/=dummy/' | sort -u) docker compose config --quiet
```

It must exit with status 0. CI fails on "variable is not set" warnings.

From the repository root, lint all Markdown with the rumdl version that `.github/workflows/linting.yml` pins, currently 0.2.78, and check your changes for whitespace errors:

```sh
uvx rumdl@0.2.78 check --config .markdownlint.yml .
git diff --check origin/main
```

Lint the whole tree, because renaming a service breaks a link in the root `README.md`. `git diff --check origin/main` also covers staged and committed changes, but not untracked files, so stage new files first.

When you have an auth key, start the copied stack and test its main function through the Tailnet. Run each health check command in its container with `docker exec`.

Report the checks you ran. State any checks that credentials, hardware, permissions, or unavailable tools prevented.

## Pull requests

- Title the pull request `Service: what changes`, such as `Umami: new service`. For several services, list them or use `All services:`. For other areas, use `CI:`, `Docs:`, or `Template:`.
- Fill in the [pull request template](.github/PULL_REQUEST_TEMPLATE.md). Maintainers apply the labels.
