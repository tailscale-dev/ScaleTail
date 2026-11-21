# Arcane Agent

[Arcane](https://getarcane.app/) is a web interface to manage Docker. This service is the agent, which lets an [Arcane manager](../arcane/) manage Docker on another host, so that you manage all your hosts from one web interface.

This stack runs Arcane Agent with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). The agent image does not include Tailscale, and the manager of the [Arcane](../arcane/) stack is reachable only through your Tailnet, so the sidecar connects the agent to it.

## At a glance

| Item          | Value                                  |
| ------------- | -------------------------------------- |
| Web interface | None                                   |
| Service port  | None                                   |
| Image         | `ghcr.io/getarcaneapp/agent`           |
| Data          | `./arcane-agent-data` (agent identity) |

## Before you start

- **Run the manager.** Start the [Arcane](../arcane/) stack first. The agent and the manager must run the same major version of Arcane, so update them together.
- **Set the manager address.** Set `ARCANE_MANAGER_API_URL` in `.env` to the Tailnet address of the manager, such as `https://arcane.<tailnet>.ts.net`.
- **Set the enrollment token.** Create an agent enrollment token in the manager, as described in the [Arcane agent documentation](https://getarcane.app/docs/remote/agents), and set it as `ARCANE_AGENT_TOKEN` in `.env`. It starts with `arc_etkn_`.
- **Name each agent.** Set `SERVICE` in `.env` to a different name on each host, such as `arcane-agent-nas`. It is the name of the device in your Tailnet.

Compose stops with an error while `ARCANE_MANAGER_API_URL` or `ARCANE_AGENT_TOKEN` is empty.

## Deviations from the standard setup

- **No web interface.** The agent connects to the manager and listens on no port. The stack has no Tailscale Serve configuration, no `./config` folder, and no `ports` block.
- **MagicDNS.** `TS_ACCEPT_DNS=true` is set, so the agent can resolve the MagicDNS name of the manager. The HTTPS certificate of the manager is valid only for that name, not for its Tailscale IP address. The stack has no other containers to reach by name.
- **Docker socket.** The agent mounts `/var/run/docker.sock` with write access, which it needs to manage Docker. Everyone who can log in to the manager has full control over this Docker host.
- **No health check.** The agent listens on no port, and the image has no shell or process tools, so the `application` service has no health check.

## First run

The agent exchanges the enrollment token for its own key at the first start, and stores that key in `./arcane-agent-data`. The host then appears as a new environment in the web interface of the manager. Keep the data folder, because the key in it identifies the agent to the manager.

Your Tailnet policy must allow this device to reach the manager on port `443`.

## Links

- [Arcane agent documentation](https://getarcane.app/docs/remote/agents)
- [Arcane migration guide to version 3](https://getarcane.app/docs/get-started/migrate-v3)
- [Arcane source code](https://github.com/getarcaneapp/arcane)
