# LibreTranslate

[LibreTranslate](https://libretranslate.com/) is a machine translation service with a web interface and an API. It translates on your own server, with no external service.

This stack runs LibreTranslate with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                                     |
| ------------- | --------------------------------------------------------- |
| Web interface | `https://libretranslate.<tailnet>.ts.net`                 |
| API           | `https://libretranslate.<tailnet>.ts.net/translate`       |
| Service port  | `5000`                                                    |
| Image         | `libretranslate/libretranslate:latest`                    |
| Data          | `./libretranslate-data/models/` (language models)         |

## Before you start

1. Create the models folder yourself and make user `1032` its owner. Docker creates missing folders as user `root`. LibreTranslate runs as user `1032` and cannot save the models to a folder that `root` owns.

   ```bash
   mkdir -p libretranslate-data/models
   sudo chown 1032 libretranslate-data/models
   ```

2. Choose the languages in `LT_LOAD_ONLY` in `.env`. The default, `en,de,fr,es`, downloads about 900 MB of models. When `LT_LOAD_ONLY` is empty, LibreTranslate downloads every language it supports, which takes several gigabytes.

## Deviations from the standard setup

None.

## First run

1. Start the stack. At the first start, LibreTranslate downloads the models for the languages in `LT_LOAD_ONLY`, and the web interface is not available until it has finished. With the default languages this took about 10 minutes in testing. The container reports healthy during the download, so follow the progress in the log:

   ```bash
   docker compose logs -f application
   ```

2. Open the web interface when the log shows `Booting worker`. Later starts take seconds, because the models stay in `./libretranslate-data/models`.

## Configuration

- **API.** Send a `POST` request to `/translate`, for example:

  ```bash
  curl -X POST https://libretranslate.<tailnet>.ts.net/translate \
    -H 'Content-Type: application/json' \
    -d '{"q":"Good morning","source":"en","target":"de"}'
  ```

- **More languages.** LibreTranslate downloads models by itself only when it has none. To add languages later, add their codes to `LT_LOAD_ONLY`, add `- LT_UPDATE_MODELS=true` to the `environment` list of the `application` service, and run `docker compose up -d`. Remove the line again when the download has finished, so that LibreTranslate does not check for model updates at every start.
- **Other settings.** LibreTranslate reads every command-line option from an `LT_` environment variable, such as `LT_REQ_LIMIT` and `LT_API_KEYS`. Add them to the `environment` list of the `application` service. See [Arguments](https://docs.libretranslate.com/guides/installation/#arguments).

## Links

- [LibreTranslate documentation](https://docs.libretranslate.com/)
- [LibreTranslate source code](https://github.com/LibreTranslate/LibreTranslate)
- [LibreTranslate on Docker Hub](https://hub.docker.com/r/libretranslate/libretranslate)
