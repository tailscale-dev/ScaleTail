# Kitchenowl with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Kitchenowl](https://github.com/TomBursch/kitchenowl) with Tailscale as a sidecar container to securely access your meal planner over a private Tailscale network. By using Tailscale in a sidecar configuration, you can enhance the security and privacy of your Kitchenowl instance, ensuring that it is only accessible within your Tailscale network.

## Kitchenowl

[Kitchenowl](https://kitchenowl.org/) is a smart grocery list and recipe manager with features like expense tracking, weekly meal planner and rich recipe import options. This configuration leverages Tailscale to securely connect to your Kitchenowl dashboard, ensuring that your self-hosted interface is protected from unauthorized access and only reachable via your private Tailscale network. You can find options to set up Open ID Connect [here](https://docs.kitchenowl.org/latest/self-hosting/oidc/).

## Configuration Overview

In this setup, the `tailscale-kitchenowl` service runs Tailscale, which manages secure networking for the Kitchenowl service. The `app-kitchenowl` service uses the Tailscale network stack via Docker's `network_mode: service:` configuration. This setup ensures that Kitchenowl's web interface is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your self-hosted meal planner. 
You can find information on how to set up Open ID Connect [here](https://docs.kitchenowl.org/latest/self-hosting/oidc/). Just uncomment the section in both the .env-file and the docker-compose.yaml and set up your parameters in the .env-file to use them!
