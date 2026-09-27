# Eigenfocus with Tailscale Sidecar Configuration  

This Docker Compose configuration sets up **[Eigenfocus](https://github.com/Eigenfocus/eigenfocus)** with Tailscale as a sidecar container to securely manage and access your self-hosted task and project management tool over a private Tailscale network. By integrating Tailscale, you can ensure that your Eigenfocus instance remains private and accessible only to authorized devices within your Tailscale network.

## Eigenfocus  

[Eigenfocus](https://github.com/Eigenfocus/eigenfocus) is a self-hosted, privacy-focused task and project management tool that helps individuals and teams stay organized. With its clean, minimalist interface and structured workflow, Eigenfocus is designed for those who prefer a lightweight yet powerful alternative to traditional project management apps. By integrating Tailscale, your Eigenfocus instance is secured, allowing access only from trusted devices within your private network.

## Key Features  

- **Task & Project Management** – Organize tasks, set deadlines, and track progress effortlessly.  
- **Privacy-Focused** – Self-hosted to keep your data secure and under your control.  
- **Minimalist Interface** – A distraction-free, efficient workflow for productivity.  
- **Collaboration Ready** – Share tasks and projects with team members.  
- **Secure Access with Tailscale** – Restrict access to only authorized devices within your private network.  

## Configuration Overview  

In this setup, the `tailscale-eigenfocus` service runs Tailscale, which manages secure networking for the Eigenfocus service. The `eigenfocus` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Eigenfocus’ web interface is only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy for managing tasks and projects.
