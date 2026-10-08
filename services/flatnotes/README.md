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

- **`FLATNOTES_USERNAME` and `FLATNOTES_PASSWORD`.** The login of the web interface. The defaults are `user` and `changeMe!`.
- **`FLATNOTES_SECRET_KEY`.** A long random value that flatnotes uses to sign the login tokens.

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with the username and password from `.env`.

## Links

- [flatnotes documentation and source code](https://github.com/dullage/flatnotes)
