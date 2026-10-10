# Free up port 53 on the Docker host

A DNS service such as Pi-hole or AdGuard Home needs port 53. This page applies only when you publish port 53 on the Docker host, for example to offer DNS to your local network. A stack that is reachable over your Tailnet only does not need it.

## Why port 53 is in use

On Debian-based systems that use `systemd-resolved`, such as Ubuntu Server 22.04 and 24.04, a DNS stub listener runs by default. It listens on `127.0.0.53:53` and, since systemd 250 (for example on Ubuntu 24.04), also on `127.0.0.54:53`. It answers DNS queries from local applications. A container that publishes port 53 on all host addresses then fails to start, because the port is already taken.

The `DNSStubListener` option in `/etc/systemd/resolved.conf` controls this listener:

- `DNSStubListener=yes`: `systemd-resolved` listens on port 53 of these addresses. This is the default.
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

3. Point `/etc/resolv.conf` to the file that lists your upstream DNS servers:

   ```bash
   sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
   ```

   Do this before the next step. On Ubuntu, `/etc/resolv.conf` points to the stub at `127.0.0.53`. That stub stops answering after the restart, so the host would lose DNS.

4. Restart the service:

   ```bash
   sudo systemctl restart systemd-resolved
   ```

5. Check that the host still resolves names:

   ```bash
   getent hosts github.com
   ```

   The command prints an IP address and the name. If it prints nothing, undo the change and enable the stub listener again:

   ```bash
   sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
   sudo sed -i 's/^DNSStubListener=no/#DNSStubListener=yes/' /etc/systemd/resolved.conf
   sudo systemctl restart systemd-resolved
   ```

6. Check that port 53 is free:

   ```bash
   sudo ss -tuln | grep ':53 '
   ```

   The command prints nothing when no process listens on port 53.
