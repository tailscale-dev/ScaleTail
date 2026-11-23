# Arcane Agent

[Arcane](https://getarcane.app/) is a web interface to manage Docker. This service is the agent, which lets an [Arcane manager](../arcane/) manage Docker on another host, so that you manage all your hosts from one web interface.

This stack runs Arcane Agent with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). The agent image does not include Tailscale, and the manager of the [Arcane](../arcane/) stack is reachable only through your Tailnet, so the sidecar connects the agent to it.

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | None                                   |
| Service port  | None                                   |
| Image         | `ghcr.io/getarcaneapp/agent`           |
| Data          | `./arcane-agent-data` (agent identity)            |
|               | The folder from `STACKS_DIR` (stacks of this host) |

## Before you start

- **Run the manager.** Start the [Arcane](../arcane/) stack first. The agent and the manager must run the same major version of Arcane, so update them together.
- **Set the manager address.** Set `ARCANE_MANAGER_API_URL` in `.env` to the Tailnet address of the manager, such as `https://arcane.<tailnet>.ts.net`.
- **Set the enrollment token.** Create an agent enrollment token in the manager, as described in the [Arcane agent documentation](https://getarcane.app/docs/remote/agents), and set it as `ARCANE_AGENT_TOKEN` in `.env`. It starts with `arc_etkn_`.
- **Name each agent.** Set `SERVICE` in `.env` to a different name on each host, such as `arcane-agent-nas`. It is the name of the device in your Tailnet.
- **Choose the stacks folder.** Set `STACKS_DIR` in `.env` to the absolute path of the folder on this host that holds your stacks, one folder per stack. The default is `/opt/stacks`. Create the folder before the first start, because Docker creates a missing folder as `root`, and the agent cannot write to it.
- **Set the owner.** Set `PUID` and `PGID` in `.env` to the user and group that own the stacks folder. Run `id -u` and `id -g` as that user to find them.

Compose stops with an error while `ARCANE_MANAGER_API_URL` or `ARCANE_AGENT_TOKEN` is empty.

## Deviations from the standard setup

- **No web interface.** The agent connects to the manager and listens on no port. The stack has no Tailscale Serve configuration, no `./config` folder, and no `ports` block.
- **MagicDNS.** `TS_ACCEPT_DNS=true` is set, so the agent can resolve the MagicDNS name of the manager. The HTTPS certificate of the manager is valid only for that name, not for its Tailscale IP address. The stack has no other containers to reach by name.
- **Docker socket.** The agent mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to the manager has full control over this Docker host.
- **Stacks folder.** The agent keeps the Compose projects of this host in the folder from `STACKS_DIR`, outside this directory. The stack mounts it at the same path in the container, as the [Arcane installation guide](https://getarcane.app/docs/get-started/installation#projects-folder) recommends. Relative paths in a project, such as `./config`, then point to the folder of that project on the host.
- **User and group.** `PUID` and `PGID` in `.env` set the user that the agent runs as and the owner of the files that it creates.
- **No health check.** The agent listens on no port, and the image has no shell or process tools, so the `application` service has no health check.

## First run

The agent exchanges the enrollment token for its own key at the first start, and stores that key in `./arcane-agent-data`. The host then appears as a new environment in the web interface of the manager. Keep the data folder, because the key in it identifies the agent to the manager.

Your Tailnet policy must allow this device to reach the manager on port `443`.

## Upgrading

Earlier versions of this stack kept the Compose projects of this host in `./arcane-agent-data/projects`. The stack now uses the folder from `STACKS_DIR`.

- If you keep your previous `.env`, Docker refuses to create the container with the error `invalid mount path: ':' mount path must be absolute`.
- If you take the new `.env`, the agent starts with `/opt/stacks`, and the projects in `./arcane-agent-data/projects` no longer appear in the manager. Their containers keep running.

Move the projects as follows:

1. Add `STACKS_DIR`, `PUID`, and `PGID` to your `.env`, as in the current `.env` of this stack.
2. Stop each project of this host in the web interface of the manager.
3. Move the projects to the stacks folder. Replace `/opt/stacks` with your `STACKS_DIR`. When `PUID` is not `1000`, also give the moved folders to that user:

   ```sh
   sudo mv ./arcane-agent-data/projects/* /opt/stacks/
   sudo chown -R <PUID>:<PGID> /opt/stacks/<project>
   ```

4. Run `docker compose up -d` in this directory, and start the projects again in the web interface of the manager.

## Links

- [Arcane agent documentation](https://getarcane.app/docs/remote/agents)
- [Arcane migration guide to version 3](https://getarcane.app/docs/get-started/migrate-v3)
- [Arcane source code](https://github.com/getarcaneapp/arcane)
