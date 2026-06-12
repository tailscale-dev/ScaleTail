# Kitchenowl with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Kitchenowl** with a Tailscale sidecar container, enabling secure, private access to your self-hosted grocery list, recipe manager, and meal planner over your Tailnet. With this setup, your Kitchenowl instance is **not exposed to the public internet** and is only accessible from authorized devices connected via Tailscale.

## Kitchenowl

[**Kitchenowl**](https://github.com/TomBursch/kitchenowl) is a self-hosted grocery list, recipe manager, and meal planning application designed for households and shared kitchens. It helps you organize shopping lists, recipes, weekly meal plans, pantry items, and household food planning from a central web interface.

Kitchenowl is useful for families, housemates, and home labs that want a private alternative to cloud-hosted grocery and recipe apps. It supports collaborative lists, recipe import workflows, meal planning, and optional account integration features, making it a practical tool for day-to-day kitchen organization.

## Key Features

- 🛒 Shared grocery lists for households and teams
- 🍽️ Recipe management with rich recipe import options
- 📅 Weekly meal planning for organizing upcoming meals
- 💸 Expense tracking for grocery and household food costs
- 🧺 Pantry and household item organization
- 👥 Multi-user collaboration for shared kitchens
- 🔐 Optional OpenID Connect support for external authentication
- 🛡️ Tailnet-only access when paired with the included Tailscale sidecar

## Tailscale Integration

This setup uses a **Tailscale sidecar container** to provide secure private networking for Kitchenowl. The Kitchenowl container shares the Tailscale container's network stack using Docker's `network_mode: service:<tailscale-service-name>` pattern.

Because of this, Kitchenowl does not need to publish ports directly to the host. Instead, you access the web interface through the Tailscale hostname or Tailnet IP assigned to the sidecar. This keeps the service private, reduces exposure, and avoids the need for public DNS, inbound firewall rules, or a public reverse proxy.

## Configuration Overview

The Compose stack is built around two services:

1. **Tailscale sidecar**  
   Handles authentication to your Tailnet and provides the private network endpoint for the application.

2. **Kitchenowl application**  
   Runs the Kitchenowl web interface and uses the Tailscale sidecar's network namespace for secure Tailnet-only access.

Kitchenowl should be configured with persistent storage so recipes, shopping lists, users, pantry data, meal plans, and application settings are retained across container restarts and updates. Review the provided `compose.yaml` and `.env` file before deployment, especially if you want to enable authentication integrations.

## OpenID Connect

Kitchenowl supports OpenID Connect for external authentication providers. This can be useful when integrating Kitchenowl with an existing identity provider such as Authentik, Authelia, Keycloak, or another OIDC-compatible service.

To enable OIDC in this ScaleTail service, review the commented OIDC sections in both the `.env` file and the `compose.yaml` file. Uncomment the relevant values and fill in the required provider details before starting the stack.

You can find the upstream Kitchenowl OIDC documentation here: [Kitchenowl OpenID Connect Documentation](https://docs.kitchenowl.org/latest/self-hosting/oidc/).

## Usage Notes

Once logged in, create your household, configure users, and begin adding grocery lists, recipes, pantry items, and meal plans. Since Kitchenowl is designed for shared household use, review user permissions and authentication settings before inviting other people to the instance.

## References

- [Kitchenowl Website](https://kitchenowl.org/)
- [Kitchenowl GitHub Repository](https://github.com/TomBursch/kitchenowl)
- [Kitchenowl Documentation](https://docs.kitchenowl.org/)
- [Kitchenowl OpenID Connect Documentation](https://docs.kitchenowl.org/latest/self-hosting/oidc/)
- [Tailscale Docker Documentation](https://tailscale.com/kb/1282/docker)
