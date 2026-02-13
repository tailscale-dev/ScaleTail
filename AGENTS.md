# AGENTS.md - ScaleTail Development Guide

This document provides guidelines for agentic coding agents working in the ScaleTail repository.

## Project Overview

ScaleTail is a collection of Docker Compose configurations that set up various self-hosted services with Tailscale as a sidecar container. Each service directory contains:
- `compose.yaml` - Docker Compose configuration
- `.env` - Environment variables (no secrets)
- `README.md` - Service documentation

## Build/Lint/Test Commands

### Linting (Markdown)

```bash
# Run markdown linting locally using the config
markdownlint ./services/**/*.md

# Or with Docker
docker run -v $PWD:/work avto-dev/markdown-lint@v1.5.0 --config .markdownlint.yml ./services/**/*.md
```

### Generate Registry

```bash
# Generate registry.json from services (Python 3 required)
python3 scripts/generate_registry.py

# With custom repo and ref
python3 scripts/generate_registry.py --repo owner/repo --ref main
```

### Docker Compose Validation

```bash
# Validate a service's compose.yaml
docker compose -f services/<service>/compose.yaml config
```

### Running Tests

There are no automated unit tests in this repository. Validation is done via:
1. Markdown linting (CI runs on push/PR)
2. Docker Compose config validation
3. Registry generation (CI runs on push to main)

## Code Style Guidelines

### File Organization

- Service directories go in `services/<service-name>/`
- Each service must have exactly three files:
  - `compose.yaml`
  - `.env`
  - `README.md`
- Use the template in `templates/service-template/` when adding new services

### Docker Compose Conventions

1. **Tailscale container naming**: Must be `tailscale-<service>`
2. **Application container naming**: Must be `app-<service>`
3. **Network mode**: Application must use `network_mode: service:tailscale`
4. **Health checks**: Both containers require health checks
5. **depends_on**: Must reference Tailscale with `condition: service_healthy`
6. **Ports**: Keep `ports` section commented unless LAN exposure is explicitly required
7. **Volumes**: Pre-create bind-mount paths to avoid root-owned folders

### Compose.yaml Structure

```yaml
configs:
  ts-serve:
    content: |
      {"TCP":{"443":{"HTTPS":true}},
      "Web":{"$${TS_CERT_DOMAIN}:443":
          {"Handlers":{"/":
          {"Proxy":"http://127.0.0.1:<INTERNAL_PORT>"}}}},
      "AllowFunnel":{"$${TS_CERT_DOMAIN}:443":false}}

services:
  tailscale:
    image: tailscale/tailscale:latest
    container_name: tailscale-${SERVICE}
    hostname: ${SERVICE}
    environment:
      - TS_AUTHKEY=${TS_AUTHKEY}
      - TS_STATE_DIR=/var/lib/tailscale
      - TS_SERVE_CONFIG=/config/serve.json  # Remove if not using Serve
      - TS_USERSPACE=false
      - TS_ENABLE_HEALTH_CHECK=true
      - TS_LOCAL_ADDR_PORT=127.0.0.1:41234
    volumes:
      - ./config:/config
      - ./ts/state:/var/lib/tailscale
    devices:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - net_admin
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://127.0.0.1:41234/healthz"]
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 10s
    restart: always

  application:
    image: ${IMAGE_URL}
    network_mode: service:tailscale
    container_name: app-${SERVICE}
    environment:
      - <APP_ENV_VARS>
    volumes:
      - ./${SERVICE}-data/<path>:/container/path
    depends_on:
      tailscale:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "<check_command>"]
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 30s
    restart: always
```

### .env File Structure

```bash
#version=1.1
#URL=https://github.com/tailscale-dev/ScaleTail

# Service Configuration
SERVICE=<service-name>
IMAGE_URL=<docker-image-url>

# Network Configuration
SERVICEPORT=<external-port>
DNS_SERVER=9.9.9.9

# Tailscale Configuration
TS_AUTHKEY=

# Optional Service variables
TAILNET_NAME=
```

### README.md Structure

```markdown
# <Service Name> with Tailscale Sidecar Configuration

Brief description of the service and why Tailscale helps.

## <Service Name>

More detailed description from upstream project.

## Configuration Overview

Explain the sidecar setup and how traffic is routed.
```

### Markdown Conventions

- Use ATX-style headers (`#`, `##`, `###`)
- Keep line length reasonable (markdownlint default rules apply)
- No inline HTML unless necessary
- Use fenced code blocks with language identifiers

### Naming Conventions

- **Service directories**: lowercase with hyphens (e.g., `qbittorrent`, `home-assistant`)
- **Environment variables**: uppercase with underscores (e.g., `TS_AUTHKEY`, `SERVICEPORT`)
- **Container names**: use `${SERVICE}` variable (e.g., `tailscale-${SERVICE}`)
- **Docker images**: Use `${IMAGE_URL}` variable; prefer `:latest` tag

### Variable Usage in compose.yaml

- Use `${VARIABLE}` syntax for environment variables
- Use `$$` prefix for literal dollar signs (e.g., `$${TS_CERT_DOMAIN}`)
- Always define all variables in `.env` file

### Error Handling

- Always validate compose files with `docker compose config`
- Ensure health checks are properly configured for both containers
- Use `restart: always` for production reliability
- Pre-create directories for bind mounts to avoid root-owned folders

### Adding New Services

1. Copy `templates/service-template/` to `services/<service-name>/`
2. Rename files and update content
3. Update `compose.yaml`:
   - Set correct `SERVICEPORT` and `IMAGE_URL` in `.env`
   - Update `Proxy` port in `TS_SERVE_CONFIG` to match internal app port
   - Remove `TS_SERVE_CONFIG` if not using Tailscale Serve/Funnel
   - Add required volumes, devices, or capabilities
4. Fill in README with service description and any gotchas
5. Validate with `docker compose config`
6. Run markdown lint before committing

### Registry Generation

The `scripts/generate_registry.py` script:
- Scans `services/` for all `compose.yaml` files
- Requires each service to have a corresponding `.env` file
- Extracts service name from README frontmatter or first heading
- Generates `registry.json` for the ScaleTail catalog

### Git Workflow

- Create feature branches for changes
- Run markdown linting before submitting PRs
- Ensure `docker compose config` passes for modified services
- Update `registry.json` by running the generation script (or let CI do it)

### Important Notes

- **Never commit real secrets** - use placeholder values in `.env`
- **Keep Tailscale health check** - ensures app starts after Tailscale is ready
- **Document port exposures** - explain why any `ports:` section is uncommented
- **Test locally first** - use `docker compose up -d` to verify before submitting
