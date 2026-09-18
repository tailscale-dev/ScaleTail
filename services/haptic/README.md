# Haptic with Tailscale Sidecar Configuration  

This Docker Compose configuration sets up **[Haptic](https://github.com/chroxify/haptic)** with Tailscale as a sidecar container to securely manage and access your self-hosted bookmark manager over a private Tailscale network. By integrating Tailscale, you can ensure that your Haptic instance remains private and accessible only to authorized devices within your Tailscale network.

## Haptic  

[Haptic](https://github.com/chroxify/haptic) is a modern, self-hosted bookmark manager designed for simplicity, speed, and privacy. It allows users to organize, search, and access saved links efficiently while providing a clean and user-friendly interface. With Haptic, you can take full control of your bookmarks without relying on third-party services. By integrating Tailscale, you can further secure your Haptic instance by ensuring access is restricted to authorized devices within your private network.

## Key Features  

- **Self-Hosted Bookmark Management** – Organize and store bookmarks securely.  
- **Full-Text Search** – Quickly find saved bookmarks with an intuitive search function.  
- **Minimalist & Fast** – Designed for speed and usability without unnecessary complexity.  
- **Privacy-Focused** – Keep your bookmarks safe and private with a self-hosted solution.  
- **Secure Access with Tailscale** – Restrict access to only authorized devices within your private network.  

## Configuration Overview  

In this setup, the `tailscale-haptic` service runs Tailscale, which manages secure networking for the Haptic service. The `haptic` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Haptic’s web interface is only accessible through the Tailscale network (or locally, if preferred), adding an extra layer of security and privacy for managing your bookmarks.
