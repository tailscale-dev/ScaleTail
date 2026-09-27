# Ghost with Tailscale Sidecar Configuration  

This Docker Compose configuration sets up **[Ghost](https://github.com/TryGhost/Ghost)** with Tailscale as a sidecar container to securely manage and access your self-hosted publishing platform over a private Tailscale network. By integrating Tailscale, you can ensure that your Ghost instance remains private and accessible only to authorized devices within your Tailscale network.

## Ghost  

[Ghost](https://github.com/TryGhost/Ghost) is a modern, open-source publishing platform designed for professional blogs, newsletters, and online publications. It provides a sleek, minimalist editor, built-in SEO features, and powerful customization options. By integrating Tailscale, your Ghost instance remains secure and accessible only to authorized users, ensuring that your content is managed in a private environment.

## Key Features  

- **Minimalist & Fast** – A lightweight, streamlined writing experience for bloggers and content creators.  
- **Built-in SEO & Analytics** – Optimize content for search engines and track performance effortlessly.  
- **Customizable Themes & Integrations** – Extend Ghost with themes, memberships, and integrations.  
- **Self-Hosted Privacy** – Maintain full control over your content with a locally hosted instance.  
- **Secure Access with Tailscale** – Restrict access to only authorized devices within your private network.  

## Configuration Overview  

In this setup, the `tailscale-ghost` service runs Tailscale, which manages secure networking for the Ghost service. The `ghost` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Ghost’s web interface and publishing tools are only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy to your publishing workflow.

Set `GHOST_URL` in `.env` to the HTTPS hostname that you use on your Tailnet. Ghost listens on port `2368`, and Tailscale Serve forwards HTTPS traffic to that port.
