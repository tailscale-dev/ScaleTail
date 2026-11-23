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

Earlier versions of this stack shipped `donetick-data/config/selfhosted.yaml` in the repository, and you replaced its JWT secret yourself. The repository no longer tracks the file. Your copy stays in place and keeps working, and Git ignores it after the update.

If you changed the file without a commit, `git pull` refuses to run, and `git stash pop` reports a conflict for the file. Before you update, move your copy to a private folder outside the clone, and restore the tracked file:

```bash
backup=$(mktemp -d)
mv donetick-data/config/selfhosted.yaml "$backup/"
git checkout -- donetick-data/config/selfhosted.yaml
```

Then update as described in [Update a stack](../../README.md#update-a-stack), and put your copy back from the same shell:

```bash
mkdir -p donetick-data/config
mv "$backup/selfhosted.yaml" donetick-data/config/
rmdir "$backup"
```

If `git stash pop` already reported the conflict, Git left your copy in place. Fix any conflict in `.env` first, then run `git reset` and `git stash drop`.

If you committed your change, Git reports a conflict for the file when you pull. Keep your copy and finish the pull with `git rm --cached donetick-data/config/selfhosted.yaml`, then `git commit --no-edit`. If you pushed or shared that commit, others can read the secrets in it. Set a new random `jwt.secret`, for example from `openssl rand -base64 32`, which signs everyone out. Also replace the email, OAuth, Telegram, and Pushover credentials that you set in the file.

## Links

- [Donetick documentation](https://docs.donetick.com/)
- [Donetick source code](https://github.com/donetick/donetick)
