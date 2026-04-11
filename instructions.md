# Claude Code Instructions: ScaleTail Minecraft Service Contribution

You are helping contribute a new service to the ScaleTail repository
(https://github.com/tailscale-dev/ScaleTail). ScaleTail is a collection
of Docker Compose configurations that run self-hosted services alongside
a Tailscale sidecar container, making them accessible privately over a
Tailnet without port forwarding.

Your task is to create a complete, contribution-ready Minecraft server
entry following the exact structure and conventions of existing services
in the repo.

---

## CONTEXT: How ScaleTail services are structured

Every service in ScaleTail lives at `services/<service-name>/` and
contains exactly these files:

- `docker-compose.yml` — the main compose file with Tailscale sidecar
- `README.md` — documentation for the service
- `.env` — environment variable defaults (committed with placeholder values)
- `config/serve.json` — Tailscale Serve config (only for HTTP services)

The sidecar pattern is always the same:

1. A `tailscale-<service>` container runs the Tailscale client
2. The actual service container uses `network_mode: service:tailscale-<service>`
   to route all traffic through the Tailscale interface
3. The Tailscale container has a healthcheck on `http://127.0.0.1:41234/healthz`
4. Credentials go in a `.env` file; `TS_AUTHKEY` is always required

**IMPORTANT technical difference from HTTP services:** Minecraft Java Edition
uses TCP port 25565. Tailscale Serve only supports HTTP/HTTPS proxying,
so a `serve.json` is NOT needed or appropriate here. Players connect
directly to the Tailscale node at `minecraft.<tailnet-name>.ts.net:25565`.
Do NOT create a `config/serve.json` file for this service.

---

## TASK: Create the following files

### 1. `services/minecraft/docker-compose.yml`

Use `itzg/minecraft-server:latest` as the Minecraft image (it's the
community standard with 1B+ pulls, supports Java Edition with Paper,
Fabric, Forge, Vanilla, etc.).

The compose file must follow this exact structure pattern (derived from
existing ScaleTail services like radarr, vaultwarden, forgejo):

```yaml
services:
  tailscale-minecraft:
    image: tailscale/tailscale:latest
    container_name: tailscale-minecraft
    hostname: minecraft                     # becomes the Tailnet device name
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY}
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_USERSPACE=false
      # NO TS_SERVE_CONFIG — Minecraft uses raw TCP, not HTTP
    volumes:
      - ./config:/config
      - ts-minecraft-data:/var/lib/tailscale
    devices:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    # Optional DNS override block (commented out by default):
    # dns:
    #   - 1.1.1.1
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://127.0.0.1:41234/healthz"]
      interval: 1m
      timeout: 10s
      retries: 3
    restart: unless-stopped

  minecraft:
    image: itzg/minecraft-server:latest
    container_name: minecraft
    network_mode: service:tailscale-minecraft
    environment:
      - EULA=TRUE                         # Required — accepted by the user
      - TYPE=${SERVER_TYPE}               # VANILLA, PAPER, FABRIC, FORGE, etc.
      - VERSION=${MINECRAFT_VERSION}      # e.g. LATEST or 1.21.4
      - DIFFICULTY=${DIFFICULTY}
      - MAX_PLAYERS=${MAX_PLAYERS}
      - MOTD=${MOTD}
      - MEMORY=${MEMORY}
      - ONLINE_MODE=${ONLINE_MODE}        # set false for cracked/offline servers
      # Uncomment to also bind to the local network (outside Tailnet):
      # ports:
      #   - "0.0.0.0:25565:25565"
    volumes:
      - minecraft-data:/data
    depends_on:
      tailscale-minecraft:
        condition: service_healthy
    restart: unless-stopped

volumes:
  ts-minecraft-data:
  minecraft-data:
```

All environment variables must come from the `.env` file. Add inline
comments explaining non-obvious fields, matching the style of other
ScaleTail services (see the radarr compose for reference tone).

---

### 2. `services/minecraft/.env`

Include all variables referenced in the compose file with sensible
defaults and a comment for each line:

```
# Tailscale auth key — get one from https://login.tailscale.com/admin/settings/keys
TS_AUTHKEY=

# Minecraft server type: VANILLA, PAPER, FABRIC, FORGE, SPIGOT, BUKKIT
SERVER_TYPE=PAPER

# Minecraft version: LATEST or a specific version like 1.21.4
MINECRAFT_VERSION=LATEST

# Server difficulty: peaceful, easy, normal, hard
DIFFICULTY=normal

# Maximum number of concurrent players
MAX_PLAYERS=10

# Message of the day shown in the server list
MOTD=A Minecraft Server on Tailscale

# JVM memory allocation (increase for larger servers or more players)
MEMORY=2G

# Online mode: true = requires valid Minecraft account, false = allows offline/cracked clients
ONLINE_MODE=true
```

---

### 3. `services/minecraft/README.md`

Write a complete README following the exact style of other ScaleTail
service READMEs (see forgejo and vaultwarden for tone and structure).

The README must include the following sections:

**Header section:**
- A brief description of what Minecraft is
- A brief description of what this Docker Compose config does
  (Tailscale sidecar, private Tailnet access, no port forwarding needed)

**Key features section** (bullet list):
- Private multiplayer without opening router ports
- Friends connect using the Tailscale MagicDNS hostname
- Supports multiple server types (Vanilla, Paper, Fabric, Forge)
- Persistent world data in a named Docker volume
- Configurable via environment variables

**Technical note on networking:**
Explain clearly that this service uses raw TCP on port 25565, NOT
Tailscale Serve/Funnel (which are for HTTP only). Players connect at
`minecraft.<tailnet-name>.ts.net:25565`. This is the key distinction
from web-based services in the repo.

**How it works section:**
Explain the sidecar pattern briefly — the tailscale container runs the
Tailscale client, the Minecraft container shares its network stack via
`network_mode: service:tailscale-minecraft`, and all traffic is routed
over the Tailnet.

**Setup instructions:**
1. Clone the repo and navigate to `services/minecraft/`
2. Edit `.env` and paste in your Tailscale auth key (from https://login.tailscale.com/admin/settings/keys)
3. (Optional) Adjust SERVER_TYPE, MEMORY, MAX_PLAYERS in `.env`
4. Run `docker compose up -d`
5. Find your Tailnet name in the Tailscale admin console
6. Connect in Minecraft: Multiplayer → Add Server → `minecraft.<tailnet-name>.ts.net`

**Connecting section:**
- All players must be on the same Tailnet (or have been shared access to the node)
- ONLINE_MODE=false allows offline/non-premium accounts but reduces security
- Bedrock Edition uses UDP port 19132, which is not proxied through Tailscale Serve.
  Bedrock players can still connect directly via the Tailscale IP on port 19132,
  but this requires using the Bedrock edition of itzg/minecraft-server (set TYPE=BEDROCK)
  and is outside the scope of this configuration.

**Environment variables table:**
A markdown table documenting every variable in `.env`:

| Variable | Default | Description |
|---|---|---|
| TS_AUTHKEY | _(empty)_ | Tailscale auth key from the admin console |
| SERVER_TYPE | PAPER | Server software: VANILLA, PAPER, FABRIC, FORGE, SPIGOT, BUKKIT |
| MINECRAFT_VERSION | LATEST | Game version: LATEST or a pinned version like 1.21.4 |
| DIFFICULTY | normal | Game difficulty: peaceful, easy, normal, hard |
| MAX_PLAYERS | 10 | Maximum concurrent players |
| MOTD | A Minecraft Server on Tailscale | Message shown in the server browser |
| MEMORY | 2G | JVM heap size — increase for larger worlds or player counts |
| ONLINE_MODE | true | Require valid Minecraft accounts (set false for offline/LAN play) |

**Useful links section:**
- itzg/minecraft-server on Docker Hub: https://hub.docker.com/r/itzg/minecraft-server
- itzg/minecraft-server documentation: https://docker-minecraft-server.readthedocs.io
- Tailscale Serve docs: https://tailscale.com/kb/1242/tailscale-serve
- Tailscale Funnel docs: https://tailscale.com/kb/1223/funnel
- Tailscale Docker guide: https://tailscale.com/blog/docker-tailscale-guide

---

### 4. Update the root `README.md`

Open the root `README.md` of the repository. Find the table of available
services. Check whether a `### 🎮 Gaming` section already exists.

- **If a Gaming section exists:** add the Minecraft row to its table.
- **If no Gaming section exists:** create a new section immediately before
  `### 📱 Utilities` (or wherever makes sense alphabetically/thematically)
  with the following header and table:

```markdown
### 🎮 Gaming

| 🎮 Service | 📝 Description | 🔗 Link |
| --- | --- | --- |
| 🎮 **Minecraft** | A self-hosted Minecraft Java Edition server accessible privately over your Tailnet — no port forwarding required. | [Details](/services/minecraft) |
```

Match the column order and formatting of existing tables exactly
(emoji + bold name | description | link).

---

## CONSTRAINTS

- Do NOT create a `config/serve.json` — this is a TCP game server,
  not an HTTP service. Tailscale Serve is for HTTP proxying only.
- Do NOT include `TS_SERVE_CONFIG` in the compose environment.
- Use named volumes (not bind mounts) for both `minecraft-data` and
  `ts-minecraft-data` — this is consistent with other ScaleTail services
  and avoids file permission issues on different host systems.
- The `./config` bind mount for the Tailscale container is correct and
  intentional — it stores the Tailscale config files that persist the
  node identity across container restarts.
- Match the comment style and density of existing ScaleTail services —
  helpful but not excessive.
- The contribution must be self-contained inside `services/minecraft/`.
  The only other file to modify is the root `README.md`.

---

## VALIDATION CHECKLIST

After creating all files, verify the following before finishing:

- [ ] `docker-compose.yml` references only variables defined in `.env`
- [ ] No `serve.json` file exists anywhere under `services/minecraft/`
- [ ] No `TS_SERVE_CONFIG` appears anywhere in the Minecraft service files
- [ ] The Tailscale healthcheck uses `http://127.0.0.1:41234/healthz`
      (this is Tailscale's built-in health endpoint used by all services)
- [ ] The `minecraft` container has `depends_on` pointing to
      `tailscale-minecraft` with `condition: service_healthy`
- [ ] The root `README.md` table row matches the column structure of
      adjacent rows exactly
- [ ] All `.env` variables have a comment explaining their purpose
- [ ] The README networking section explicitly states this is TCP/raw
      socket, NOT Tailscale Serve/Funnel
