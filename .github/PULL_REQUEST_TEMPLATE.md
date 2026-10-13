<!-- rumdl-disable MD041 -->
<!-- Title format: "Service: what changes", as in CONTRIBUTING.md. Examples: "Dockhand: new service" or "Changedetection: fix port mapping". -->

## Description
<!-- Briefly describe what changed. -->

## Related Issues
<!-- Link any related issues (e.g. Fixes #123). Use "None" if not applicable. -->

- None.

## Verification
<!-- Tick what you ran. For each check you skipped, say why, for example "no auth key available". Add logs, command output, or screenshots if useful. -->

- [ ] `docker compose config --quiet` from each changed service directory, with dummy values for required variables
- [ ] The stack started, Tailscale is healthy, and the service is reachable through the Tailnet
- [ ] The main function of the service works, and its data survives a restart
- [ ] `rumdl check --config .markdownlint.yml .` on the whole repository, and `git diff --check`

## Impact on existing users
<!-- Say what users of an existing stack must do after they pull this change, such as moving data, renaming a volume, or setting a new variable. Use "None" if not applicable. -->

- None.

## Checklist

- [ ] I have performed a self-review of my code and followed the [templates](https://github.com/tailscale-dev/ScaleTail/tree/main/templates/service-template) structure.
- [ ] I did not commit a working auth key, password, token, or other credential.
- [ ] The service README uses the headings of the template, in the same order, and is up to date.
- [ ] I added, removed, or renamed the service in the [root README.md](https://github.com/tailscale-dev/ScaleTail/blob/main/README.md), in alphabetical order, or this PR does not change the list of services.

## Additional Context
<!-- Any extra info for reviewers, such as gotchas, special requirements, devices, or dependencies. Use "None" if not applicable. -->

- None.
