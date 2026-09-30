# Agent guidance

Follow [CONTRIBUTING.md](CONTRIBUTING.md) and the current service template.

## Before you edit

- Inspect the target service and its README.
- Confirm ports, commands, volumes, and variables in the image's upstream docs.
- Preserve service-specific exceptions that still apply.
- Keep changes focused on the requested service or documentation.
- Never commit working auth keys, passwords, tokens, or other credentials.

## Verification

Run `docker compose config --quiet` from each changed service directory. When
possible, start the stack and test its main function through the Tailnet.

From the repository root, lint the changed Markdown files. Replace the example paths below as needed:

```sh
rumdl check --config .markdownlint.yml AGENTS.md CONTRIBUTING.md
git diff --check
```

Report the checks you ran. State any checks that credentials, hardware,
permissions, or unavailable tools prevented.
