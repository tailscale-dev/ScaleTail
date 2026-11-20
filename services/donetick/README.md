# Donetick

[Donetick](https://github.com/donetick/donetick) is a task and chore manager for households and small groups.

This stack runs Donetick with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                       |
| ------------- | ----------------------------------------------------------- |
| Web interface | `https://donetick.<tailnet>.ts.net`                         |
| Service port  | `2021`                                                      |
| Image         | `donetick/donetick`                                         |
| Data          | `./donetick-data/config` (configuration, `selfhosted.yaml`) |
|               | `./donetick-data/data` (database)                           |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **Configuration file.** `DT_ENV=selfhosted` makes Donetick read `donetick-data/config/selfhosted.yaml`. When the file does not exist, Donetick writes it on the first start, with a random JWT secret that signs the logins.

## First run

Open the web interface and sign up to create the first account.

## Configuration

- **Settings.** Change email, OAuth, and other settings in `donetick-data/config/selfhosted.yaml`, then run `docker compose restart application`. Donetick creates the file as `root` with mode `0600`, so edit it with `sudo`. Keep `jwt.secret`: a new value signs everyone out.

## Upgrading

Earlier versions of this stack shipped `donetick-data/config/selfhosted.yaml` in the repository, and you replaced its JWT secret yourself. The repository no longer tracks the file, and your copy stays in place and keeps working.

When you update with `git pull` and changed the file without a commit, Git refuses to pull. Move your copy aside first, then put it back:

```bash
mv donetick-data/config/selfhosted.yaml selfhosted.yaml.bak
git checkout -- donetick-data/config/selfhosted.yaml
git pull
mkdir -p donetick-data/config
mv selfhosted.yaml.bak donetick-data/config/selfhosted.yaml
```

When you committed your change, Git reports a conflict for the file instead. Keep your copy and finish the pull with `git rm --cached donetick-data/config/selfhosted.yaml`, then `git commit --no-edit`.

## Links

- [Donetick documentation](https://docs.donetick.com/)
- [Donetick source code](https://github.com/donetick/donetick)
