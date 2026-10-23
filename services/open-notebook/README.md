# Open Notebook

[Open Notebook](https://www.open-notebook.ai/) is an open-source, self-hosted alternative to Google's NotebookLM. You collect sources such as web pages, PDFs, and text in notebooks, then chat with them, search them, and generate notes and podcasts with the AI provider of your choice.

This stack runs Open Notebook with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). The image does not include Tailscale, so the sidecar gives it Tailnet access.

## At a glance

| Item          | Value                                                  |
| ------------- | ------------------------------------------------------ |
| Web interface | `https://open-notebook.<tailnet>.ts.net`               |
| Service port  | `8502`                                                 |
| Images        | `lfnovo/open_notebook:v1-latest`                       |
|               | `surrealdb/surrealdb:v2`                               |
| Data          | `./open-notebook-data/notebook` (uploads and settings) |
|               | `./open-notebook-data/surreal` (database)              |

## Before you start

Set these values in `.env`. Compose stops with an error if one of them is empty.

- **`TAILNET_NAME`.** Your Tailnet name, the part between the service name and `.ts.net`, for example `tail1234`. `compose.yaml` builds the address `https://<SERVICE>.<TAILNET_NAME>.ts.net` from it.
- **`OPEN_NOTEBOOK_ENCRYPTION_KEY`.** Encrypts the AI provider keys that you save in the web interface. Generate one with `openssl rand -hex 32`. Keep it: with a different key, the saved provider keys can no longer be decrypted and you must enter them again.
- **`SURREAL_PASSWORD`.** The password of the database. Generate one with `openssl rand -hex 32`. The database applies it only when it creates the root user at the first start. If you change it later, Open Notebook can no longer log in to the database and logs `There was a problem with authentication`. Set the old password again, or delete `./open-notebook-data/surreal` to start with an empty database, which removes all notebooks.

## Deviations from the standard setup

- **Extra container.** The stack runs a `db` container with SurrealDB. It uses the network of the `tailscale` container as well, so Open Notebook reaches it at `127.0.0.1`. The database listens only on the loopback address of the device (`SURREAL_BIND`), so other devices on your Tailnet cannot reach it. The image listens on all addresses by default.
- **Root user.** The `db` container runs as root, as upstream requires, to write to the bind-mounted folder. The folder `./open-notebook-data/surreal` is therefore owned by root.
- **API address.** `API_URL` in `compose.yaml` is the Tailnet address of the service. The browser sends its API calls there, and the web interface forwards them to the API on port `5055`. Without it, the browser would call port `5055` of the Tailnet address, which Serve does not publish. If you change `SERVICE` or `TAILNET_NAME`, the address changes with them. For the same reason the optional `ports` block gives a page that loads from your local network, but its API calls go to the Tailnet address, so it works only on a device that is connected to your Tailnet.
- **Health check.** The image defines no health check, so the `application` container calls `/health` of the API on port `5055`.

## First run

Open the web interface. Open Notebook has no login until you set a password, so anyone on your Tailnet can use it. To require a password, set `OPEN_NOTEBOOK_PASSWORD` in `.env` and run `docker compose up -d`.

Then connect an AI provider: open Manage, then Models, add a credential for your provider (a cloud API key, or an Ollama address), test it, add models, and set the default models. Chat and search do not work until the default models are set. The first start can take a minute, because the API runs database migrations.

## Configuration

The Docling engine (OCR and image sources) and a local Crawl4AI browser are not installed by default. To enable them, uncomment `OPEN_NOTEBOOK_ENABLE_DOCLING` or `OPEN_NOTEBOOK_ENABLE_CRAWL4AI` in `compose.yaml` and run `docker compose up -d`. They are downloaded at the next start, which takes several minutes, and are cached in `./open-notebook-data/notebook`.

Open Notebook accepts more settings as environment variables. Add them to the `application` service. The [environment reference](https://github.com/lfnovo/open-notebook/blob/main/docs/5-CONFIGURATION/environment-reference.md) lists them.

## Links

- [Open Notebook documentation](https://github.com/lfnovo/open-notebook/tree/main/docs)
- [Docker Compose installation guide](https://github.com/lfnovo/open-notebook/blob/main/docs/1-INSTALLATION/docker-compose.md)
- [Reverse proxy guide](https://github.com/lfnovo/open-notebook/blob/main/docs/5-CONFIGURATION/reverse-proxy.md)
- [Open Notebook source code](https://github.com/lfnovo/open-notebook)
