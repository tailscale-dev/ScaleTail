# linkding

[linkding](https://linkding.link/) is a bookmark manager. You save, tag, and search your links, and a browser extension adds bookmarks with one click.

This stack runs linkding with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                               |
| ------------- | ----------------------------------- |
| Web interface | `https://linkding.<tailnet>.ts.net` |
| Service port  | `9090`                              |
| Image         | `sissbruecker/linkding`             |
| Data          | `./linkding-data/data`              |

## Before you start

The settings of linkding are in the file `.linkding.env` in this directory.

- **`LD_SUPERUSER_NAME` and `LD_SUPERUSER_PASSWORD`.** Set both to let linkding create your account at the first start. If you leave them empty, create the account by hand after the start, as described under the first run.

## Deviations from the standard setup

- **Separate settings file.** The `application` container loads `.linkding.env` through `env_file`, in addition to the variables in `compose.yaml`.

## First run

Open the web interface and log in with the account from `.linkding.env`.

If you did not set an account there, create one first:

```bash
docker exec -it app-linkding python manage.py createsuperuser --username=<name> --email=<email>
```

## Links

- [linkding documentation](https://linkding.link/)
- [linkding options](https://linkding.link/options/)
- [linkding source code](https://github.com/sissbruecker/linkding)
