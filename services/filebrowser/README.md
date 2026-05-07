# Filebrowser with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Filebrowser](https://filebrowser.org/index.html) with Tailscale as a sidecar container to keep the app reachable over your Tailnet.

## Filebrowser

[Filebrowser](https://filebrowser.org/index.html) File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview and edit your files. It is a create-your-own-cloud-kind of software where you can just install it on your server, direct it to a path and access your files through a nice web interface.

## Configuration Overview

In this setup, the `tailscale-Filebrowser` service runs Tailscale, which manages secure networking for Filebrowser. The `Filebrowser` service utilizes the Tailscale network stack via Docker's `network_mode: service:` configuration. This keeps the app Tailnet-only unless you intentionally expose ports.

## What to document for users

- The automatically generated password for the user admin is only displayed once when the container first runs. If you fail to remember it, you will need to manually delete the database and start File Browser again.

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env` // Main variable `TS_AUTHKEY`
