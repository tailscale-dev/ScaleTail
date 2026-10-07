# Memos

[Memos](https://usememos.com/) is a note-taking service for quick thoughts. You write short notes in Markdown, tag them, and find them again in a timeline.

This stack runs Memos with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                            |
| ------------- | -------------------------------- |
| Web interface | `https://memos.<tailnet>.ts.net` |
| Service port  | `5230`                           |
| Image         | `neosmemo/memos:stable`          |
| Data          | `./memos-data`                   |

## Before you start

Set `MEMOS_INSTANCE_URL` in `compose.yaml` to the address of the web interface, `https://memos.<tailnet>.ts.net`.

## Deviations from the standard setup

- **Database.** `MEMOS_DRIVER=sqlite` makes Memos store its data in a SQLite database in the data folder.

## First run

Open the web interface and sign up. The first account becomes the administrator.

## Links

- [Memos documentation](https://usememos.com/docs)
- [Memos source code](https://github.com/usememos/memos)
