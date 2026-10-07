# Stirling-PDF

[Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) is a toolbox for PDF files. You merge, split, convert, compress, sign, and edit PDF files in your browser, and the files stay on your own server.

This stack runs Stirling-PDF with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                                   |
| ------------- | ----------------------------------------------------------------------- |
| Web interface | `https://stirlingpdf.<tailnet>.ts.net`                                  |
| Service port  | `8080`                                                                  |
| Image         | `frooodle/s-pdf`                                                        |
| Data          | `./stirlingpdf-data/extraConfigs` (settings and database)               |
|               | `./stirlingpdf-data/trainingData` (language files for text recognition) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

None.

## First run

Open the web interface and log in with username `admin` and password `stirling`. Stirling-PDF creates this account at the first start, so change the password right after you log in.

## Links

- [Stirling-PDF documentation](https://docs.stirlingpdf.com/)
- [Stirling-PDF source code](https://github.com/Stirling-Tools/Stirling-PDF)
