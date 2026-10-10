# SearXNG

[SearXNG](https://github.com/searxng/searxng) is a metasearch engine. It combines the results of many search engines and does not track or profile its users.

This stack runs SearXNG with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                       |
| ------------- | ------------------------------------------- |
| Web interface | `https://searxng.<tailnet>.ts.net`          |
| Service port  | `8080`                                      |
| Images        | `docker.io/searxng/searxng`                 |
|               | `docker.io/valkey/valkey:8-alpine`          |
| Data          | `./searxng` (configuration, `settings.yml`) |
|               | Docker volume `valkey-data2` (Valkey data)  |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`. `compose.yaml` builds the base address `https://<SERVICE>.<TAILNET_NAME>.ts.net/` from it, which SearXNG uses for its links.
- **`SEARXNG_SECRET`.** A random value. Generate one with `openssl rand -hex 32`.

## Deviations from the standard setup

- **Settings file.** This directory contains `searxng/settings.yml`, which only sets `use_default_settings: true` and the secret key. Every other setting comes from the [default settings of SearXNG](https://github.com/searxng/searxng/blob/master/searx/settings.yml). The stack mounts the folder at `/etc/searxng`. Add your own settings to that file; see the [settings documentation](https://docs.searxng.org/admin/settings/settings.html). After you edit the file, run `docker compose restart application`.
- **Folder ownership.** `FORCE_OWNERSHIP=false` in `compose.yaml` stops SearXNG from making its own user the owner of the `searxng` folder. The folder stays yours, so you can edit `settings.yml` without `sudo`, and `git pull` can update it. At each start, SearXNG logs a warning that the folder `is not owned by "searxng:searxng"`. This is expected. Do not change the owner to match, because `git pull` then fails.
- **Extra container.** The stack runs a `valkey` container on the default Compose network. `SEARXNG_VALKEY_URL` in `.env` points SearXNG at it, because the default settings do not use Valkey. Keep `TS_ACCEPT_DNS` disabled, because MagicDNS cannot resolve the name `valkey`.
- **Reduced privileges.** Both containers drop all capabilities and add back only the few that they need.
- **Log size.** Both containers limit their log to one file of 1 MB.

## First run

Nothing to set up. Open the web interface and search. SearXNG has no login.

## Upgrading

Earlier versions of this stack had a full copy of the SearXNG settings file. Its list of engines contained modules that upstream has since removed, so SearXNG logged `Cannot load engine` errors. The file now only overrides the secret key.

Earlier versions also let SearXNG make its own user (ID `977`) the owner of the `searxng` folder. If you started the stack before, Git cannot replace `settings.yml`. `git pull` then stops with `unable to unlink old 'services/searxng/searxng/settings.yml': Permission denied` and leaves your clone half updated. To prevent this, take the folder back before you update your clone. Run this from the service directory:

```bash
sudo chown -R "$(id -u):$(id -g)" searxng
```

You need this only once, because the stack now sets `FORCE_OWNERSHIP=false`. If you changed `settings.yml`, also copy it to another folder and run `git restore searxng/settings.yml`, and move your own settings into the new file after the update.

After the update, run `docker compose up -d`. Compose recreates the `application` container, which then reads the new file.

If `git pull` already stopped with that error, run the `chown` command, and then finish the update with these commands. They keep your own changes, such as the values in `.env`:

```bash
git stash
git reset --hard origin/main
git stash pop
```

If you ran `git stash` before the pull, run `git stash pop` once more.

SearXNG now uses its default request method, `GET`, so a search query shows in the address bar and in the browser history. The old file set `POST`. To keep `POST`, add the line `method: "POST"` under the existing `server:` key in `settings.yml`.

## Links

- [SearXNG documentation](https://docs.searxng.org/)
- [SearXNG source code](https://github.com/searxng/searxng)
- [Video: replace Google with SearXNG](https://www.youtube.com/watch?v=cg9d87PuanE)
