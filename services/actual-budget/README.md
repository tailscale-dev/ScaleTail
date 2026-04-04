# Actual Budget with Tailscale Sidecar Configuration

This Docker Compose configuration sets up **Actual Budget** with a Tailscale sidecar container, enabling secure and private access to your personal finance app over your Tailnet. With this setup, your budgeting data stays fully private and is only accessible from trusted devices, without exposing anything to the public internet.

## Actual Budget

[Actual Budget](https://github.com/actualbudget/actual) is an open-source, self-hosted personal finance and budgeting app focused on privacy and control. It serves as a modern alternative to tools like YNAB, allowing you to track spending, manage accounts, and plan budgets while retaining full ownership of your financial data.

When paired with Tailscale, Actual Budget becomes accessible across your devices through your secure Tailnet, eliminating the need for public exposure or complex reverse proxy configurations.

## Configuration Overview

In this setup, the `tailscale-actual` service runs Tailscale, which manages secure networking for Actual Budget. The `actual` service uses the Tailscale network stack via Docker's `network_mode: service:` configuration. This ensures the application is only reachable over your Tailnet unless you explicitly expose ports.

## Key Features

- Self-hosted personal budgeting platform
- Privacy-first approach with full data ownership
- Sync across devices without relying on third-party cloud services
- Transaction tracking, budgeting, and reporting
- Secure Tailnet-only access via Tailscale

## Files to check

Please check the following contents for validity as some variables need to be defined upfront.

- `.env`
  - Required: `TS_AUTHKEY`
