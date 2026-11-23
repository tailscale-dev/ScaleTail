# Arcane

[Arcane](https://getarcane.app/) is a web interface to manage Docker containers, images, networks, volumes, and Compose projects.

This stack runs the Arcane manager with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). To manage Docker on other hosts from the same manager, run the [Arcane Agent](../arcane-agent/) stack on each of them.

## At a glance

| Item          | Value                                 |
| ------------- | ------------------------------------- |
| Web interface | `https://arcane.<tailnet>.ts.net`     |
| Service port  | `3552`                                |
| Image         | `ghcr.io/getarcaneapp/manager`        |
| Data          | `./arcane-data` (application data)          |
|               | The folder from `STACKS_DIR` (your stacks) |

## Before you start

- **Set your Tailnet name.** Set `TAILNET_NAME` in `.env` to your Tailnet name, without `.ts.net`. `compose.yaml` builds the address of the application, `ARCANE_APP_URL`, from it.
- **Set the encryption key.** Set `ENCRYPTION_KEY` in `.env` to a random value of at least 32 characters. Generate it with `openssl rand -hex 32`. Compose stops with an error while it is empty.
- **Choose the stacks folder.** Set `STACKS_DIR` in `.env` to the absolute path of the folder on the Docker host that holds your stacks, one folder per stack. The default is `/opt/stacks`. Create the folder before the first start, because Docker creates a missing folder as `root`, and Arcane cannot write to it.
- **Set the owner.** Set `PUID` and `PGID` in `.env` to the user and group that own the stacks folder. Run `id -u` and `id -g` as that user to find them. Arcane runs as this user, and it cannot create a project in a folder that this user cannot write to.

Do not use the `services` folder of your ScaleTail clone as the stacks folder. Arcane would list every ScaleTail stack, and the changes that you make in Arcane would change the files of your Git checkout. Copy the stacks you use to the stacks folder instead.

## Deviations from the standard setup

- **Docker socket.** Arcane mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to Arcane has full control over the Docker host.
- **Stacks folder.** Arcane keeps the Compose projects in the folder from `STACKS_DIR`, outside this directory. The stack mounts it at the same path in the container, as the [Arcane installation guide](https://getarcane.app/docs/get-started/installation#projects-folder) recommends. Relative paths in a project, such as `./config`, then point to the folder of that project on the host.
- **User and group.** `PUID` and `PGID` in `.env` set the user that Arcane runs as and the owner of the files that it creates.

## First run

Arcane creates the user `arcane` with a random password at the first start, and writes the password to `./arcane-data/initial-admin-password`. The file belongs to the `PUID` from `.env`, and only that user can read it:

```sh
cat ./arcane-data/initial-admin-password
```

Open the web interface and log in with username `arcane` and that password. Arcane asks you to change the password at the first login.

Arcane lists the stacks in the stacks folder, up to three folders deep, also the ones that you started with `docker compose`. It creates each new project in its own folder there, such as `/opt/stacks/ntfy`. When this directory is in the stacks folder too, Arcane also lists its own stack. Manage that stack with `docker compose` on the host.

## Upgrading

### Stacks folder

Earlier versions of this stack kept the Compose projects in `./opt/dockerdata`, inside this directory. The stack now uses the folder from `STACKS_DIR`.

- If you keep your previous `.env`, Docker refuses to create the container with the error `invalid mount path: ':' mount path must be absolute`.
- If you take the new `.env`, Arcane starts with `/opt/stacks`, and the projects in `./opt/dockerdata` no longer appear in the web interface. Their containers keep running.

Move the projects as follows:

1. Add `STACKS_DIR`, `PUID`, and `PGID` to your `.env`, as in the current `.env` of this stack. If you replaced `./opt/dockerdata` in `compose.yaml` with a folder of your own, use that folder as `STACKS_DIR`.
2. Stop each project in `./opt/dockerdata`, in the web interface or with `docker compose down` in its folder.
3. Move the projects to the stacks folder. Replace `/opt/stacks` with your `STACKS_DIR`. Each project keeps its `./ts/state`, so its device keeps its name in your Tailnet. The containers created some of the files as `root`, so use `sudo`. When `PUID` is not `1000`, also give the moved folders to that user:

   ```sh
   sudo mv ./opt/dockerdata/* /opt/stacks/
   sudo chown -R <PUID>:<PGID> /opt/stacks/<project>
   ```

4. Run `docker compose up -d` in this directory. When `PUID` or `PGID` changed, Arcane gives `./arcane-data` to the new user at the start.
5. Start the projects again in the web interface, and delete the empty `./opt` folder with `sudo rm -r ./opt`.

### Arcane 3

Arcane 3 renamed its image and its settings. Follow the [Arcane migration guide](https://getarcane.app/docs/get-started/migrate-v3) together with these steps:

1. Upgrade to Arcane 2.17.3 first. The previous image of this stack, `ghcr.io/getarcaneapp/arcane`, stays at 2.17.3. Run `docker compose pull` and `docker compose up -d` with the previous files, and wait until the container is healthy.
2. Update `compose.yaml`. It now passes the `ARCANE_` names, such as `ARCANE_APP_URL` and `ARCANE_ENCRYPTION_KEY`. Arcane 3 does not start while an old name such as `APP_URL` is set. If you added your own variables, rename them as the migration guide describes.
3. In your `.env`, set `IMAGE_URL=ghcr.io/getarcaneapp/manager:latest` and delete `JWT_SECRET`, which Arcane 3 no longer uses. Keep `ENCRYPTION_KEY`.
4. Run `docker compose pull` and `docker compose up -d`. Arcane migrates its database at the first start, and your users, settings, and API keys stay.
5. Upgrade every agent to Arcane 3 as well, for example with the [Arcane Agent](../arcane-agent/) stack. The manager and its agents must run the same major version.

### Secrets in `.env`

Earlier versions of this stack had a sample value for `ENCRYPTION_KEY` in `compose.yaml`. It is now empty in `.env`, and you must set it.

- If you replaced the value in `compose.yaml` before, move your value to `.env`.
- If you still used the sample value, set a new one. Arcane cannot decrypt what it encrypted with the previous `ENCRYPTION_KEY`, so keep the previous value if you need that data.

## Links

- [Arcane documentation](https://getarcane.app/docs)
- [Arcane installation](https://getarcane.app/docs/get-started/installation)
- [Arcane source code](https://github.com/getarcaneapp/arcane)
