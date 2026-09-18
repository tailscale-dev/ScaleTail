# Nanote with Tailscale Sidecar Configuration  

This Docker Compose configuration sets up **[Nanote](https://github.com/omarmir/nanote)** with Tailscale as a sidecar container to securely manage and access your self-hosted note-taking application over a private Tailscale network. By integrating Tailscale, you can ensure that your Nanote instance remains private and accessible only to authorized devices within your Tailscale network.

## Nanote  

[Nanote](https://github.com/omarmir/nanote) is a lightweight, self-hosted note-taking application designed for simplicity and speed. It provides a distraction-free environment to jot down quick notes, ideas, or reminders without the complexity of traditional note-taking apps. By integrating Tailscale, you can keep your Nanote instance secure and accessible only within your private network.

## Key Features  

- **Minimalist Design** – A clean and distraction-free interface for note-taking.  
- **Fast & Lightweight** – Optimized for quick note-taking without unnecessary bloat.  
- **Self-Hosted Privacy** – Keep your notes secure and under your control.  
- **Markdown Support** – Write notes in Markdown for easy formatting.  
- **Secure Access with Tailscale** – Restrict access to only authorized devices within your private network.  

## Configuration Overview  

In this setup, the `tailscale-nanote` service runs Tailscale, which manages secure networking for the Nanote service. The `nanote` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Nanote’s web interface and note storage are only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy to your note-taking workflow.
