# Isley with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [Isley](https://github.com/dwot/isley) with Tailscale as a sidecar container, enabling secure and private access to your self-hosted cannabis grow journal over a Tailscale network. With Tailscale, you can ensure that your sensitive grow data and notes are only accessible by trusted devices within your Tailnet.

## Isley

[Isley](https://github.com/dwot/isley) is a self-hosted cannabis grow journal designed for home growers to track and monitor their plants with ease. It replaces vendor apps, spreadsheets, and notepads by centralizing tools into a clean, intuitive interface. Isley helps growers with some Key Features 🚀

- **📒 Grow Logs**: Track plant growth, watering, and feeding schedules.
- **🌡️ Environmental Monitoring**: View real-time data from grow equipment (AC Infinity, Ecowitt).
- **📸 Image Uploads**: Attach photos to your grow logs for visual tracking.
- **🌱 Seed Inventory**: Manage your seed collection and strain library.
- **📊 Harvest Tracking**: Record harvest details and yields.
- **📈 Graphs and Charts**: Visualize environmental data and plant progress over time.
- **⚙️ Customizable Settings**: Add custom activities and measurements for your grow.
- **📱 Mobile-Friendly**: Works on desktop and mobile devices for convenience.

With integration options for popular grow equipment, Isley simplifies and elevates the grow experience by consolidating everything into one powerful and private tool.

## Default Credentials

- **Default Username:** `admin`
- **Default Password:** `isley`

## Configuration Overview

In this setup, the `tailscale-isley` service runs Tailscale, which manages secure networking for the Isley service. The `isley` service uses the Tailscale network stack via Docker's `network_mode: service:tailscale` configuration. This ensures that Isley's interface is not exposed to the public internet, protecting your grow journal and data with an additional layer of privacy.
