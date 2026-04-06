# Frigate with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Frigate** with Tailscale as a sidecar container, enabling secure, private access to your NVR and AI-based camera monitoring system over your Tailnet.

## Frigate

[Frigate](https://github.com/blakeblackshear/frigate) is an open-source network video recorder (NVR) designed for real-time object detection using AI. It integrates with IP cameras and leverages hardware acceleration (such as Google Coral, GPUs, or CPUs) to detect objects like people, cars, and animals with high efficiency.

Frigate is often paired with Tailscale to ensure that camera feeds, recordings, and detection events remain completely private, accessible only from trusted devices on your Tailnet rather than being exposed to the public internet.

## Configuration Overview

In this setup, the `tailscale-frigate` service runs Tailscale, which manages secure networking for Frigate. The `frigate` container shares the network stack using Docker’s `network_mode: service:tailscale-frigate`.

This ensures:

- No public ports are exposed by default
- Access is restricted to your Tailnet
- HTTPS access can be enabled via Tailscale Serve if desired

## Key Features

- Real-time AI object detection (people, vehicles, animals, etc.)
- Local processing with optional hardware acceleration (Coral, GPU, CPU)
- RTSP camera support
- Event-based recording and snapshots
- Web UI for live view and playback
- MQTT integration for automation systems like Home Assistant

## Files to Check

Please review:

- `.env` → Ensure `TS_AUTHKEY` is set

## Useful Links

- Frigate Documentation: <https://docs.frigate.video/>
- GitHub Repository: <https://github.com/blakeblackshear/frigate>
- Hardware Acceleration Guide: <https://docs.frigate.video/hardware/>
