# LanguageTool

[LanguageTool](https://languagetool.org) checks grammar, style, and spelling in many languages. This stack runs its server, which the LanguageTool browser extensions and other clients can use in place of the public service.

This stack runs LanguageTool with a Tailscale sidecar, as described in [the standard setup](../../documentation/standard-setup.md).

## At a glance

| Item          | Value                                               |
| ------------- | --------------------------------------------------- |
| Web interface | None                                                |
| API           | `https://languagetool.<tailnet>.ts.net/v2`          |
| Service port  | `8010`                                              |
| Image         | `erikvl87/languagetool`                             |
| Data          | `./languagetool-data/ngrams` (optional n-gram data) |

## Before you start

Nothing beyond the [Quick Start](../../README.md#quick-start).

## Deviations from the standard setup

- **No web interface.** Tailscale Serve publishes the API of LanguageTool.
- **Memory.** `Java_Xms` and `Java_Xmx` in `compose.yaml` set the Java heap to between 512 MB and 1 GB.

## First run

Nothing to set up on the server. Test the API from a device on your Tailnet:

```bash
curl -d "language=en-US" -d "text=This are a test." https://languagetool.<tailnet>.ts.net/v2/check
```

In the LanguageTool browser extension, choose your own server in the advanced settings and enter `https://languagetool.<tailnet>.ts.net/v2`.

## Configuration

### Use n-gram data

LanguageTool can use large n-gram data sets to find errors with words that are often confused, such as *their* and *there*. See [Finding errors using n-gram data](https://dev.languagetool.org/finding-errors-using-n-gram-data).

1. [Download](https://languagetool.org/download/ngram-data/) the data for your languages.
2. Unzip each file into `./languagetool-data/ngrams`, so that each language has its own folder:

   ```text
   languagetool-data/ngrams/
   ├─ en/
   │  ├─ 1grams/
   │  ├─ 2grams/
   │  ├─ 3grams/
   ├─ nl/
   │  ├─ 1grams/
   │  ├─ 2grams/
   │  ├─ 3grams/
   ```

3. Restart the stack. `compose.yaml` already mounts the folder at `/ngrams` and sets `langtool_languageModel` to it.

## Links

- [LanguageTool HTTP API](https://dev.languagetool.org/http-server)
- [erikvl87/languagetool image](https://github.com/Erikvl87/docker-languagetool)
