# flatnotes

[flatnotes](https://github.com/dullage/flatnotes) is a note-taking application that stores your notes as plain Markdown files. It has tags, full-text search, and no database.

This stack runs flatnotes with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                             |
| ------------- | ------------------------------------------------- |
| Web interface | `https://flatnotes.<tailnet>.ts.net`              |
| Service port  | `8080`                                            |
| Image         | `dullage/flatnotes`                               |
| Data          | `./flatnotes-data` (your notes as Markdown files) |

## Before you start

Change these values in `.env`:

- **`FLATNOTES_USERNAME` and `FLATNOTES_PASSWORD`.** The login of the web interface. The default user is `user`. The password is empty, and Compose stops with an error until you set it.
- **`FLATNOTES_SECRET_KEY`.** A long random value that flatnotes uses to sign the login tokens. Generate one with `openssl rand -hex 32`. Compose stops with an error if it is empty.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with the username and password from `.env`.

## Upgrading

Earlier versions of this stack had sample values for `FLATNOTES_PASSWORD` and `FLATNOTES_SECRET_KEY` in `.env`. They are now empty, and Compose stops with an error until you set them. If you already run the stack, keep the values that you use now.

## Links

- [flatnotes documentation and source code](https://github.com/dullage/flatnotes)
