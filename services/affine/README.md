# AFFiNE with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **AFFiNE** with a Tailscale sidecar container, enabling secure, private access to your workspace over your Tailnet. With this setup, your AFFiNE instance remains **private and accessible only from authorized devices on your Tailnet**, keeping your notes, documents, and collaborative content away from the public internet.

## AFFiNE

[**AFFiNE**](https://github.com/toeverything/affine) is an open-source, privacy-focused workspace that combines **documents, whiteboards, and databases** into a single platform. It is often described as an alternative to tools like Notion and Miro, giving individuals and teams a flexible environment for writing, planning, organizing, and collaborating.

AFFiNE is designed around modern knowledge work, blending structured content and visual collaboration while remaining self-hostable and open-source. That makes it a strong fit for users who want full ownership of their data and workflows.

## Key Features

- **Unified workspace** for docs, whiteboards, and knowledge organization
- **Open-source and self-hostable** for full control over your data
- **Privacy-focused design** without dependence on proprietary SaaS platforms
- **Collaborative editing** for teams and shared projects
- **Modern block-based editor** for flexible content creation
- **Visual thinking tools** with integrated whiteboard-style workflows
- **Notion and Miro alternative** in a single platform

## Configuration Overview

In this setup, the `tailscale-affine` service runs Tailscale and handles secure networking for the stack. The `affine` service shares the Tailscale container's network namespace using Docker's `network_mode: service:` configuration. This means AFFiNE is reachable through your Tailnet without exposing it directly to the public internet.

This approach provides a secure and simple way to self-host AFFiNE privately, whether for personal note-taking, team collaboration, or internal documentation.

## Typical Use Cases

This setup is especially useful for:

- Personal knowledge management
- Team wikis and internal documentation
- Project planning and collaborative workspaces
- Visual brainstorming and whiteboarding
- Private alternatives to cloud-based productivity suites
