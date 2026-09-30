# Mattermost with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Mattermost](https://mattermost.com/platform-overview/) with Tailscale as a sidecar container to securely manage team communication over a private Tailscale network. By integrating Tailscale, you can ensure that your Mattermost instance remains private and accessible only to authorized devices on your Tailscale network.

## Mattermost

[Mattermost](https://mattermost.com/platform-overview/) is an open-source, self-hosted collaboration platform for secure team communication and workflow automation, functioning as a secure alternative to Slack. It provides tools for chat, file sharing, and integrations, with an emphasis on data control and security for enterprise use, especially in high-stakes sectors like defense and critical infrastructure. The platform is designed for flexibility and extensibility, allowing for deep customization and integration with other tools and processes to manage complex workflows.

## Key Features

- **Secure Messaging**: Offers public and private channels, direct messaging, and secure file sharing within teams and organizations.
- **Workflow Automation**: Includes features like Playbooks to streamline and automate complex processes and tasks.
- **Self-Hosting & Data Control**: Built to be self-hosted, giving IT administrators full control over data, security, and the platform's infrastructure.
- **Open-Source & Open Core**: Features an open-source core with an open-source edition and commercial, subscription-based editions that add advanced capabilities.
- **Extensive Integrations**: Designed for seamless integration with development tools and other enterprise software, such as GitLab.
- **Multi-Platform Support**: Available as web, desktop, and mobile applications for iOS, Android, Windows, and macOS.

## Configuration Overview

In this setup, the `tailscale-Mattermost` container runs Tailscale, which manages secure networking for the Mattermost service. The `Mattermost` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Mattermost’s web interface and functionality are only accessible through the Tailscale network unless you enable host port mappings.

The stack stores Mattermost and PostgreSQL data under the local `${SERVICE}-data` directory, which is `mattermost-data` by default. The path variables in `.env` are relative to this service directory, so the stack does not depend on the shell's current PWD variable.

## Troubleshooting

The Mattermost image runs as UID/GID `2000`. Docker creates missing bind-mount directories as `root:root`, and Mattermost then fails with:

```plain
app-mattermost        | Error: failed to load configuration: could not create config file: open /mattermost/config/config.json: permission denied
```

Create the Mattermost directories and set their owner before the first start. Run the commands from this service directory. If you changed `SERVICE` in `.env`, set `DATA_DIR` to `<SERVICE>-data`. Do not change the owner of the `postgres` directory, which PostgreSQL manages itself.

```bash
DATA_DIR=mattermost-data
mkdir -p "$DATA_DIR"/{config,data,logs,plugins,client/plugins,bleve-indexes}
sudo chown -R 2000:2000 "$DATA_DIR"/{config,data,logs,plugins,client,bleve-indexes}
```

Reference - [Starting/Stopping Docker](https://github.com/mattermost/mattermost-docker/commit/37331ba3d7122aeb30272308dddf51ef70e2134c#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5L146)
