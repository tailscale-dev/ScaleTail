# Free up port 53 on the Docker host

A DNS service such as Pi-hole or AdGuard Home needs port 53. This page applies only when you publish port 53 on the Docker host, for example to offer DNS to your local network. A stack that is reachable over your Tailnet only does not need it.

## Why port 53 is in use

On Debian-based systems that use `systemd-resolved`, such as Ubuntu Server 22.04 and 24.04, a DNS stub listener runs by default. It listens on `127.0.0.53:53` and answers DNS queries from local applications. A container that publishes port 53 on all host addresses then fails to start, because the port is already taken.

The `DNSStubListener` option in `/etc/systemd/resolved.conf` controls this listener:

- `DNSStubListener=yes`: `systemd-resolved` listens on `127.0.0.53:53`. This is the default.
- `DNSStubListener=no`: `systemd-resolved` does not listen on port 53, so another DNS service can use it.

## Steps

1. Open the configuration file:

   ```bash
   sudo nano /etc/systemd/resolved.conf
   ```

2. Find the line `#DNSStubListener=yes` and change it to:

   ```ini
   DNSStubListener=no
   ```

3. Restart the service:

   ```bash
   sudo systemctl restart systemd-resolved
   ```

4. Check that port 53 is free:

   ```bash
   sudo ss -tuln | grep ':53 '
   ```

   The command prints nothing when no process listens on port 53.
