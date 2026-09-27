# LanguageTool with Tailscale Sidecar Configuration

This Docker Compose configuration sets up [LanguageTool](https://languagetool.org) with Tailscale as a sidecar container to enhance secure networking.

## LanguageTool

[LanguageTool](https://languagetool.org) is a powerful grammar and spell-checking tool available for various languages. It can be used in various applications, including web browsers, office suites, and as a standalone server for integration with other services.

## Configuration Overview

In this setup, the `tailscale-adguardhome` service runs Tailscale, which manages secure networking for LanguageTool. The `languagetool` service utilizes the Tailscale network stack via Docker's `network_mode: service:tailscale`. This setup ensures that LanguageTool's service is only accessible through the Tailscale network (or locally, if preferred), providing an extra layer of security and privacy for your LanguageTool deployment.

## Using n-gram datasets

> LanguageTool can make use of large n-gram data sets to detect errors with words that are often confused, like __their__ and __there__.

*Source: [https://dev.languagetool.org/finding-errors-using-n-gram-data](https://dev.languagetool.org/finding-errors-using-n-gram-data)*

[Download](http://languagetool.org/download/ngram-data/) the n-gram dataset(s) onto your local machine and unzip them into a local ngrams directory:

```plain
home/
├─ /
│  ├─ ngrams/
│  │  ├─ en/
│  │  │  ├─ 1grams/
│  │  │  ├─ 2grams/
│  │  │  ├─ 3grams/
│  │  ├─ nl/
│  │  │  ├─ 1grams/
│  │  │  ├─ 2grams/
│  │  │  ├─ 3grams/
```

Mount the local ngrams directory to the `/ngrams` directory in the Docker container [using the `-v` configuration](https://docs.docker.com/engine/reference/commandline/container_run/#read-only) and set the `languageModel` configuration to the `/ngrams` folder.
