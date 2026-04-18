# Vikunja with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Vikunja** with Tailscale as a sidecar container, enabling secure, private access to your task management system over your Tailnet. With this setup, your Vikunja instance is only reachable from authorized devices, keeping your tasks, projects, and personal data off the public internet.

## Vikunja

[Vikunja](https://vikunja.io) is an open-source, self-hosted task management and to-do list application designed as a privacy-focused alternative to tools like Todoist, Trello, and Asana. It supports projects, tasks, labels, reminders, recurring tasks, and team collaboration.

Vikunja is ideal for individuals or teams who want full ownership of their productivity data while maintaining a modern and feature-rich task management experience. Pairing it with Tailscale ensures that your task system remains private while still being accessible from anywhere on your Tailnet.

## Key Features

- Projects, tasks, and sub-tasks with flexible organization
- Labels, priorities, due dates, and reminders
- Recurring tasks and advanced filtering
- Collaboration and shared projects
- REST API and integrations
- Clean web UI and mobile app support

## Configuration Overview

In this setup, the `tailscale-vikunja` service runs Tailscale, which manages secure networking for Vikunja. The `vikunja` service uses the Tailscale network stack via Docker's `network_mode: service:` configuration. This ensures the application is only accessible through your Tailnet unless you explicitly expose ports.

### Service-Specific Notes

- On first launch, you will need to create an admin account via the web UI
- Default URL will be your Tailscale IP or MagicDNS name
- Vikunja stores data in its configured database (SQLite by default unless changed)

## Useful Links

- Vikunja Website: <https://vikunja.io>
- Documentation: <https://vikunja.io/docs>
- GitHub: <https://github.com/go-vikunja/vikunja>
