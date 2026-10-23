# Kasm Workspaces

[Kasm Workspaces](https://www.kasm.com/community-edition) streams desktops, browsers, and applications to your web browser, each in its own container. This stack runs the Community Edition from the all-in-one image that Kasm publishes.

This stack runs Kasm Workspaces with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md). The image does not contain Tailscale, so the sidecar is what puts Kasm on your Tailnet.

## At a glance

| Item           | Value                                                                |
| -------------- | -------------------------------------------------------------------- |
| Web interface  | `https://kasm.<tailnet>.ts.net`                                      |
| Service port   | `4443` (HTTPS with a self-signed certificate)                        |
| Install wizard | `https://<Tailscale IP>:3000` (HTTPS with a self-signed certificate) |
| Image          | `kasmweb/workspaces:1.19.0`                                          |
| Data           | `./kasm-data/opt/`                                                   |

## Before you start

- Reserve disk space. Kasm runs its own Docker, and everything it downloads goes to `./kasm-data/opt/`. A test install with one workspace image (Alpine desktop) used about 13 GB.
- Reach the install wizard on port `3000` of the device's Tailscale IP address. Your Tailnet policy must allow that port. Find the address with `docker exec tailscale-kasm tailscale ip -4`.
- Optional: put a Docker Hub username and password or access token in `.env`, so that Kasm is not limited by the anonymous pull rate when it downloads its images.

## Deviations from the standard setup

- **Privileged container.** Kasm runs its own Docker daemon inside the container (Docker-in-Docker) to start the services and the workspaces, so the `application` service has `privileged: true`.
- **Port `4443`, not `443`.** Tailscale Serve listens on port `443` of the Tailscale IP address, and Kasm cannot also publish `443` in the shared network namespace: the install fails with `failed to bind host port 0.0.0.0:443/tcp: address already in use`. `KASM_PORT` is `4443`, and Serve forwards to it. The install wizard passes `KASM_PORT` to the Kasm installer and upgrader, so a new value takes effect only with a new install or an upgrade.
- **Serve forwards to HTTPS.** Kasm serves its web interface on `4443` with a self-signed certificate. Tailscale Serve forwards to it with `https+insecure`.
- **Extra ports.** Port `4443` (Kasm directly, with the self-signed certificate) and port `3000` (install wizard) are reachable on the Tailscale IP address of the device, when your Tailnet policy allows it. Uncomment the `ports` lines to publish them on your local network.
- **Health check.** The check calls the Kasm API on port `4443`, which does not listen until you finish the install wizard. The container is `starting` for 10 minutes, and `unhealthy` after that until the install is complete.
- **No `/config` volume.** Kasm keeps all of its data under `/opt`, which is `./kasm-data/opt/`.

## First run

1. Open `https://<Tailscale IP>:3000` and accept the self-signed certificate warning.
2. Accept the license, then set the passwords of `admin@kasm.local` and `user@kasm.local`. A password has at least 8 characters, with an uppercase letter, a lowercase letter, a number, and one of `!#$%^&*@`.
3. Pick the workspace images to download, such as Firefox or an Alpine desktop, and start the install. Kasm downloads its own images first, so this takes several minutes.
4. When the wizard says the install is complete, open `https://kasm.<tailnet>.ts.net` and sign in. Start a workspace to check that it streams.

The wizard stays available on port `3000` after the install, and it has no sign-in. When you no longer need it, use "Stop Install Wizard" on its dashboard. It disables the wizard until you remove `./kasm-data/opt/NO_WIZARD` and restart the container, which an upgrade needs.

The "Web URL" link on the wizard dashboard points to port `4443`. Use the Tailscale Serve address instead, which has a valid certificate.

## Troubleshooting

- **The install fails with `address already in use`.** Something else uses the Kasm port in the shared network namespace, for example when `KASM_PORT` is `443`. Use a different port in `compose.yaml` (`KASM_PORT` and the Serve configuration), stop the stack, delete `./kasm-data/opt/`, and run the install wizard again.
- **The wizard says that Docker is still loading.** Refresh the page after a minute.

## Links

- [Kasm Workspaces documentation](https://docs.kasm.com/)
- [Kasm Workspaces Community Edition](https://www.kasm.com/community-edition)
- [kasm-workspaces-dind: the all-in-one image](https://github.com/kasmtech/kasm-workspaces-dind)
- [kasmweb/workspaces on Docker Hub](https://hub.docker.com/r/kasmweb/workspaces)
