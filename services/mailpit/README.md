# Mailpit

[Mailpit](https://mailpit.axllent.org/) captures email and shows it in a web interface. It accepts messages over SMTP, stores them locally, and lets you inspect the content, headers, source, and attachments without mailbox accounts.

This stack accepts mail for every address at one domain, as a catch-all inbox. Mailpit does not send or relay the captured mail.

This stack runs Mailpit with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                 |
| ------------- | --------------------------------------------------------------------- |
| Web interface | `https://mailpit.<tailnet>.ts.net`                                    |
| Service port  | `8025`                                                                |
| SMTP          | TCP port `25` on the Docker host, forwarded to port `1025` of Mailpit |
| Image         | `axllent/mailpit`                                                     |
| Data          | `./mailpit-data/app/data` (SQLite database with the messages)         |

## Before you start

1. Set these values in `.env`:

   | Variable                   | Description                                                 | Example            |
   | -------------------------- | ----------------------------------------------------------- | ------------------ |
   | `MAIL_DOMAIN_REGEX`        | Regular expression for the recipients that Mailpit accepts  | `'@example\.com$'` |
   | `MAILPIT_MAX_MESSAGES`     | Maximum number of stored messages; `0` disables this limit  | `0`                |
   | `MAILPIT_MAX_AGE`          | Maximum age of a message in hours or days                   | `90d`              |
   | `MAILPIT_MAX_MESSAGE_SIZE` | Maximum size of a message in MB                             | `50`               |

   Escape the dots in the regular expression. For example, `'@mail\.example\.com$'` accepts every recipient at `mail.example.com`.

2. Create an address record for the mail host and point the MX record of the domain to it. Replace the sample values with your public host name and IP address:

   ```dns
   mail.example.com.    A     203.0.113.10
   example.com.         MX 10 mail.example.com.
   ```

   The MX target must resolve directly to the Docker host. Forward TCP port `25` through your firewall or router, and do not put the mail host behind an HTTP-only reverse proxy or CDN.

3. Check that your provider allows traffic on TCP port `25`. Some hosting providers block it.

## Deviations from the standard setup

- **Published SMTP port.** The `ports` block is active. It publishes TCP port `25` of the Docker host and forwards it to port `1025` of Mailpit, so that mail servers on the internet can deliver messages. The web interface stays on your Tailnet.
- **Recipient filter.** `MP_SMTP_ALLOWED_RECIPIENTS` only accepts mail for the recipients that match `MAIL_DOMAIN_REGEX`.
- **Retention.** `compose.yaml` passes the limits from `.env` to Mailpit, which deletes messages beyond them.

## First run

Nothing to set up. The web interface has no login. Send a message to an address at your domain and open the web interface to see it.

## Configuration

### Security

SMTP is open to the internet without authentication, so that other mail servers can deliver messages. `MAIL_DOMAIN_REGEX` limits the recipients, but Mailpit is a tool to test and inspect email and not a full mail server. Keep the web interface private, use firewall rules where they fit, update regularly, and do not keep sensitive mail longer than needed.

## Links

- [Mailpit documentation](https://mailpit.axllent.org/docs/)
- [Mailpit runtime options](https://mailpit.axllent.org/docs/configuration/runtime-options/)
- [Mailpit email storage](https://mailpit.axllent.org/docs/configuration/email-storage/)
